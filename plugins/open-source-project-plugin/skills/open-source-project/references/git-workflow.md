# Git Workflow, Branching, Versioning & Releases

Deeper reference for phases 5-6 of the skill. Advise the user and propose commands; let them run these.

## Table of contents
- [Conventional Commits](#conventional-commits)
- [Branching strategies by size](#branching-strategies-by-size)
- [Branch protection](#branch-protection)
- [PR and merge methods](#pr-and-merge-methods)
- [Semantic Versioning](#semantic-versioning)
- [Tags and releases](#tags-and-releases)
- [Release automation](#release-automation)
- [Signed commits](#signed-commits)

---

## Conventional Commits

Format: `<type>[optional scope][!]: <description>`, optional body, optional footers.

```
feat(auth): add OAuth2 login via Google
fix: prevent race condition on concurrent writes
docs(readme): add quickstart section
refactor(parser)!: drop support for legacy config format
```

Types: `feat` (→ MINOR bump), `fix` (→ PATCH bump), `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`. Only `feat`/`fix`/breaking changes affect SemVer.

Breaking changes, two equivalent ways:
- `!` before the colon: `feat(api)!: remove deprecated /status endpoint`
- Footer (uppercase): a `BREAKING CHANGE: <what changed and migration>` line.

Atomic commits: one logical change each; imperative subject ~50 chars; body (wrapped ~72) explains *why*; footers as git trailers (`Refs: #123`, `Co-authored-by: ...`). Enforce locally with commitlint + husky (`commit-msg` hook) if the project wants guardrails, but CI is the real gate.

---

## Branching strategies by size

**GitHub Flow (solo/small — default):** one long-lived `main` + short-lived branches → PR → merge → deploy. Simple and CD-friendly.
- Branch names: `feat/short-description`, `fix/issue-123-null-crash`.

**Trunk-based (medium with strong CI):** everyone integrates to `main` at least daily; hide unfinished work behind feature flags. Highest throughput but needs feature-flag infra and fast CI.

**Git Flow (large / multi-version):** long-lived `main` + `develop`, plus `feature/*`, `release/*`, `hotfix/*`. Built for scheduled/versioned releases; heavy — avoid unless the project genuinely maintains multiple shipped versions.

**Release branching (large):** cut `release/x.y` off trunk to maintain multiple shipped versions with backported fixes.

Recommendation: start with GitHub Flow. Move to trunk-based or release branches only when scale forces it.

---

## Branch protection

Set on `main` from day one for public repos (Settings → Branches / Rulesets):
- Require a PR before merging; require ≥1 approval on team projects (dismiss stale approvals on new commits).
- Require status checks to pass (name your CI jobs) and branches to be up to date.
- Require linear history.
- Block force-pushes and deletions.
- Optional: require signed commits; require CODEOWNERS review (larger projects).

---

## PR and merge methods

- **Fork-and-PR** for external contributors (no write access needed); **shared-repo branches** for trusted core.
- **Draft PRs** for early feedback.
- Merge methods:
  - **Squash and merge** — best default for solo/small: PR collapses to one clean commit on `main`; contributors commit freely; `git bisect`/`revert` work per PR.
  - **Rebase and merge** — linear, no merge commit, but rewrites SHAs and drops signatures.
  - **Merge commit** — preserves topology; for long-running integration branches.
- Enable "Require linear history" to disallow merge commits. Solo/small standard: **squash-merge + linear history**.

---

## Semantic Versioning

`MAJOR.MINOR.PATCH`:
- MAJOR — incompatible API change.
- MINOR — backward-compatible feature / deprecation.
- PATCH — backward-compatible bug fix.
- `0.y.z` — initial dev, anything can change. `1.0.0` — you commit to a public API.
- Pre-releases: `1.0.0-alpha` < `-alpha.1` < `-beta` < `-rc.1` < `1.0.0`.

Key rule: a breaking change is MAJOR even if the diff is one line. Deprecate across at least one minor before removing in a major.

---

## Tags and releases

Annotated (and ideally signed) tags, `v`-prefixed:
```bash
git tag -s v1.2.3 -m "Release 1.2.3"
git push origin v1.2.3
```
Create a GitHub Release per tag with notes/assets; GitHub can auto-generate notes from merged PRs/labels. Ship early and often: patch releases as needed, features batched into minors, `-rc.x` pre-releases before a major.

A tag + GitHub Release is the whole story for a project nobody *installs* (an app, a website, a template). If the project is a library, CLI, or image that people install from a registry, the release also has a **publish** half — the end-to-end process, per-registry cheat-sheet, trusted publishing (OIDC), and CI publish workflows live in `references/releasing-and-publishing.md`.

---

## Release automation

Add only when manual versioning/changelog upkeep starts to hurt:

| Tool | Model | Best for |
|---|---|---|
| **semantic-release** | Fully automated from Conventional Commits, no human step | single library, disciplined commits, zero-touch publish |
| **release-please** | Maintains a "release PR" you merge; GitHub-native, tolerant of commit variation | web apps, GitHub-centric, reviewable releases |
| **Changesets** | Contributor writes an intent file per change | monorepos / multi-package, human-readable changelogs |

---

## Signed commits

Verified commits get a green badge and prevent impersonation.
- **SSH signing** (simplest, reuse existing GitHub SSH key, Git ≥ 2.34):
  ```bash
  git config --global gpg.format ssh
  git config --global user.signingkey ~/.ssh/id_ed25519.pub
  git config --global commit.gpgsign true
  ```
  Then add the key as a **Signing key** in GitHub settings (separate slot from auth).
- **GPG signing** — more setup, supports expiry/revocation and works across hosts.
- Caveat: GitHub's "Rebase and merge" produces unsigned commits — use squash or merge commit if you require signatures.
