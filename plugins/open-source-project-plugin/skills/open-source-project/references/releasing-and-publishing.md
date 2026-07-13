# Releasing & Publishing Packages

Deeper reference for the "ship it" half of phase 6. This is about getting a version into
users' hands: cutting a release *and* — for anything meant to be installed — publishing an
artifact to a registry so `install <name>` just works.

Registry-agnostic by design. The **release process is the same everywhere**; only the
manifest, the publish command, and the registry differ. Learn the process once, then use the
cheat-sheet for the stack in front of you. Advise the user and propose commands/workflows; let
them run them. Right-size to the tier — a solo tool needs a tag and one publish command, not a
signed multi-arch matrix on day one.

## Table of contents
- [Release vs. publish — two different things](#release-vs-publish)
- [The general release process (any stack)](#the-general-release-process)
- [Trusted publishing (OIDC) — the modern default](#trusted-publishing-oidc)
- [Registry cheat-sheet](#registry-cheat-sheet)
- [Publishing checklist before the first release](#publishing-checklist)
- [Building release artifacts (CLIs & apps)](#building-release-artifacts)
- [Automating it in CI](#automating-it-in-ci)
- [Provenance, signing & supply-chain hygiene](#provenance-signing)
- [Common failure modes](#common-failure-modes)

---

## Release vs. publish

These get conflated; keep them distinct because not every project does both.

- **A release** is a marked point in history: a `vX.Y.Z` git tag plus a GitHub Release with
  notes. *Every* project can do this — it needs no registry.
- **Publishing a package** is uploading an installable artifact to a registry (npm, PyPI,
  crates.io, Docker/GHCR, etc.) so people install by name instead of cloning. Only projects
  meant to be *depended on or installed* do this.

Which applies?

| Project type | Release? | Publish a package? | Goes where |
|---|---|---|---|
| Library / SDK | yes | yes | language registry (npm, PyPI, crates.io, Maven…) |
| CLI tool | yes | often | registry **and/or** prebuilt binaries on the GitHub Release |
| Container / service | yes | yes (image) | GHCR / Docker Hub |
| App / website | yes | no (deploy instead) | your host; release = a deploy tag |

Decide this in phase 2 (distribution path) so the release workflow you set up matches reality.

---

## The general release process

The same seven steps regardless of language. Manual is completely fine early — automate only
once repetition hurts (see [automating in CI](#automating-it-in-ci)).

1. **Pick the version** per SemVer (see `git-workflow.md`). `fix:`→ patch, `feat:`→ minor,
   breaking → major. Stay in `0.y.z` until the public API is stable.
2. **Update the changelog** — move `Unreleased` items under the new version + date (or let
   release automation generate it).
3. **Bump the version in the manifest** — the single source of truth for the number
   (`package.json`, `pyproject.toml`, `Cargo.toml`, etc.). Keep tag and manifest in lockstep.
4. **Commit** the bump: `chore(release): v1.4.0`.
5. **Tag** it, annotated and `v`-prefixed: `git tag -a v1.4.0 -m "v1.4.0" && git push origin v1.4.0`.
6. **Create the GitHub Release** from the tag (`gh release create v1.4.0 --generate-notes`).
   GitHub can auto-draft notes from merged PRs.
7. **Publish the artifact** (if the project ships one) — run the registry's publish command, or
   let a tag-triggered CI workflow do it. Then **verify** by installing the published version
   fresh in a clean environment.

The manifest version, the git tag, and the published package version must all agree. Drift here
is the single most common release bug.

---

## Trusted publishing (OIDC)

**Recommend this over long-lived API tokens wherever the registry supports it.** It is now the
default best practice across the major registries and the direction the whole ecosystem is
moving (an OpenSSF standard).

The idea: instead of storing a registry token as a CI secret (long-lived, exfiltratable, easy to
leak), the registry and your CI provider establish a trust relationship. At publish time the
workflow mints a **short-lived, workflow-scoped** OIDC token — nothing sensitive is stored, and a
leaked log can't be replayed.

Supported today (as of 2026): **PyPI, npm, crates.io, RubyGems**, via GitHub Actions and GitLab
CI cloud-hosted runners. npm went GA in 2025 and **deprecated its classic long-lived tokens** in
late 2025, so for JS this is effectively the expected path now. Self-hosted runners aren't
supported yet — those still need tokens.

Setup is two steps, no secrets involved:

1. **On the registry**, register a trusted publisher scoped to the *exact* `owner/repo`, workflow
   filename, and (recommended) environment name. Trusting the wrong repo/workflow is equivalent
   to handing out a token, so be precise. PyPI and npm both support a **"pending"/first-use**
   publisher so you can publish the very first version this way too.
2. **In the workflow**, grant `id-token: write` (plus `contents: read`) and drop the
   username/password — the publish action/CLI picks up the OIDC token automatically.

Hardening that applies to any trusted-publishing setup:

- **Split build and publish into separate jobs.** Build with least privilege; give only the tiny
  publish job the `id-token: write` permission. Keep that permission at the **job** level, never
  workflow-wide.
- **Gate the publish job behind a dedicated GitHub environment** (e.g. `release`) with required
  reviewers and branch/tag restrictions, so a human okays each publish.
- **Protect release tags** (a `v*` tag protection rule) so only maintainers can create the tags
  that trigger publishing.

If OIDC isn't available (self-hosted runner, unsupported registry), fall back to a registry API
token stored as a CI secret — scoped as narrowly as the registry allows, and rotated.

---

## Registry cheat-sheet

Same process above; here's the manifest, the one-liner, and the token/OIDC note per ecosystem.
`npm publish` etc. read the version from the manifest — bump the manifest, don't retype it.

| Ecosystem | Registry | Manifest | Manual publish | Auth |
|---|---|---|---|---|
| Node / JS | npm (registry.npmjs.org) | `package.json` | `npm publish --access public` | **OIDC (trusted publishing)**; classic tokens deprecated |
| Python | PyPI | `pyproject.toml` | `python -m build` then `twine upload dist/*` | **OIDC**; else API token |
| Rust | crates.io | `Cargo.toml` | `cargo publish` | **OIDC**; else `cargo login` token |
| Ruby | RubyGems | `*.gemspec` | `gem build` then `gem push *.gem` | **OIDC**; else API key |
| Go | (no upload) | `go.mod` | `git tag v1.2.3 && git push --tags` — the module *is* the tagged repo | proxy indexes it on first fetch |
| Java / Kotlin | Maven Central | `pom.xml` / Gradle | `mvn deploy` / `gradle publish` | Central portal token + GPG signature |
| .NET | NuGet | `.csproj` | `dotnet pack` then `dotnet nuget push` | API key |
| PHP | Packagist | `composer.json` | push a tag; Packagist auto-updates via webhook | webhook |
| Container | GHCR / Docker Hub | `Dockerfile` | `docker build -t` then `docker push` | GITHUB_TOKEN (GHCR) / registry login |
| Homebrew (CLI) | tap or homebrew-core | Formula (Ruby) | PR the formula, or let GoReleaser update a tap | — |

Notes worth flagging to the user:

- **npm**: scoped public packages (`@you/pkg`) need `--access public` the first time. `files` in
  `package.json` (or `.npmignore`) controls what ships — check you're not publishing source-only
  or, worse, secrets. `npm publish --dry-run` shows the exact tarball contents.
- **Go** has no registry upload at all — publishing *is* pushing a SemVer tag; `v2+` requires a
  `/v2` module-path suffix. This trips people up.
- **Maven Central** is the strict one: it *requires* GPG-signed artifacts and complete POM
  metadata. Budget extra time.
- **crates.io** publishes are effectively permanent (you can yank but not delete) — get the name
  and first `0.1.0` right.

---

## Publishing checklist

Before the *first* publish to any registry, confirm with the user:

- **The name is available** on that registry and matches the repo (check before you fall in love
  with it — do this back in phase 2).
- **The manifest metadata is complete**: description, license (SPDX id), repository URL,
  homepage, keywords/topics, author. Registries surface these; empty fields look abandoned.
- **A `LICENSE` is present** and the license field matches it.
- **Only intended files ship.** Use the manifest allow-list and a dry-run to inspect the tarball.
  Never publish `.env`, keys, or `node_modules`.
- **README renders** on the registry page (it's often the package's real landing page).
- **The version is fresh** — most registries make a published version+number immutable; you
  can't re-upload over a mistake, only publish a new number.

---

## Building release artifacts

Libraries publish source/bytecode and are done. **Compiled CLIs and apps** should also attach
prebuilt binaries to the GitHub Release so users don't need a toolchain — build for each target
(`linux/macos/windows` × `amd64/arm64`), archive, and upload with checksums.

Doing this by hand across platforms is miserable; use a release tool:

- **GoReleaser** — the standard for Go (and now Rust/Zig too). One `.goreleaser.yaml` builds the
  full OS/arch matrix, makes archives + checksums, can build Docker images and SBOMs, sign
  artifacts, and update **Homebrew/Scoop/Winget/AUR/Nix** packages — all from a tag push via
  `goreleaser/goreleaser-action`. Needs `fetch-depth: 0` for changelog generation; test locally
  with `goreleaser release --snapshot --clean`.
- **cargo-dist ("dist")** — the Rust-native equivalent. Generates the GitHub Actions workflow
  that builds across target triples and produces installers, archives, and checksums.
- **Generic** — otherwise a GitHub Actions build **matrix** (`strategy.matrix` over os/arch) that
  compiles each target and uploads with `gh release upload` / `softprops/action-gh-release`.

Always ship **checksums** (`SHA256SUMS`) alongside binaries so users can verify downloads.

---

## Automating it in CI

Escalate along this ladder — don't jump to the top for a solo tool:

1. **Fully manual** — run the seven steps by hand. Perfect for a young solo project.
2. **Tag-triggered publish** — you tag manually; a `release.yml` workflow (`on: push: tags: ['v*']`)
   builds and publishes via trusted publishing. This is the sweet spot for most small libraries:
   see the `release.yml` starter in `templates.md`. The one rule: **never publish from the
   generic `ci.yml`** — publishing needs elevated permissions and should be a separate,
   narrowly-scoped workflow.
3. **Release-PR / changelog automation** — a bot manages versioning + changelog and opens a
   "release PR"; merging it tags and publishes. Add when hand-maintaining versions/changelogs
   hurts. Pick by shape of the project:

   | Tool | Model | Best for |
   |---|---|---|
   | **release-please** (Google) | Maintains a review-gated "release PR" from Conventional Commits; polyglot (Node, Python, Go, Rust, Java, Ruby…) | GitHub-native projects and **polyglot monorepos**; a reviewable release step |
   | **Changesets** | Contributor adds an intent file per change; bot bumps + publishes | **JS/TS monorepos** wanting per-package control and human-written changelogs |
   | **semantic-release** | Fully automated from commits, publishes immediately, no human gate | a **single** library with disciplined commits wanting zero-touch CD |

   For a **polyglot monorepo**, default to release-please; for a **JS/TS monorepo**, Changesets;
   for **one package, zero-touch**, semantic-release.

---

## Provenance, signing

For a public package these are increasingly expected, and mostly free once you publish from CI:

- **Provenance / attestations** cryptographically link a published artifact to the exact source
  commit and build. With **npm** trusted publishing, provenance is generated **automatically**
  (the old `--provenance` flag is no longer needed). **PyPI** trusted publishing attaches
  Sigstore **digital attestations by default**. GitHub's **artifact attestations**
  (`actions/attest-build-provenance`) add SLSA provenance for release binaries and images.
- **Signed release tags** (`git tag -s`) and **signed commits** — see `git-workflow.md`.
- **SBOMs** (software bill of materials) — GoReleaser and others can emit one per release for
  downstream security scanning.

The single highest-leverage move: **publish from CI via trusted publishing**. It removes stored
secrets *and* gives you provenance in one step.

---

## Common failure modes

- **Version drift** — tag says `v1.4.0`, manifest still says `1.3.0`. Bump the manifest first;
  have CI assert tag == manifest version before publishing.
- **Publishing secrets or junk** — no allow-list, so the tarball includes `.env`/keys/`.git`.
  Always `--dry-run` and inspect before the first publish.
- **Can't overwrite a bad release** — most registries make a version immutable. Fix forward with
  a new patch; never plan to re-publish the same number.
- **Publishing from the CI test workflow** — gives every PR run publish-level privileges. Keep
  publish in its own workflow, job-scoped permissions, environment-gated.
- **Long-lived tokens in CI** — the classic leak vector. Prefer OIDC; if you must use a token,
  scope and rotate it.
- **Forgot `--access public`** on a scoped npm package — the publish fails or goes private.
- **Go `v2+` without the `/v2` path suffix** — consumers can't resolve the new major.
