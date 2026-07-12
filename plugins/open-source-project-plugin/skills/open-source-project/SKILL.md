---
name: open-source-project
description: Plan, structure, and ship a project as a proper open source project on GitHub, following current industry standards. Use this whenever the user wants to build, start, or release something "as open source", "for the community", "public on GitHub", "as an OSS project/library/tool", or asks how to open-source an existing project, add a license, set up contribution files, choose a branching or commit strategy, or make a repo look professional. Trigger even when the user only says "let's make this open source" or "I want to build a tool and put it on my GitHub for everyone" without naming specific files — this skill supplies the architecture brainstorming, the standards, and the setup checklist. Do NOT use for closed-source/internal work, or for generic coding help with no intent to publish.
---

# Open Source Project

Help the user take a project from idea to a credible, contributor-ready open source repository on GitHub — the way well-run OSS projects are actually built in 2025-2026.

Your role here is **planner and advisor, not autopilot**. Brainstorm the architecture, recommend the standards that fit *this* project's size, and propose the files and git commands. Then let the user drive execution: show them what to add and why, propose exact file contents and commands, and let them apply/run them (or explicitly ask you to). Don't silently scaffold a pile of files or fire off `git`/`gh` commands without walking through the plan first. The user has told you they want to stay in the loop.

Default assumptions unless the user says otherwise: the repo lives on **the user's personal GitHub account**, the license is **MIT**, and the project starts **small/solo** (so favor the simplest workable standard, not enterprise ceremony). Stay **stack-agnostic** — ask or detect the language/framework rather than assuming one.

## The core idea: match ceremony to project size

The biggest mistake in new OSS projects is either doing too little (no license, no docs — legally not open source and unusable by others) or too much (Git Flow, monorepo tooling, five branch types for a solo weekend tool). Right-size everything. When in doubt, start lean and add structure when a real pain appears.

Use this to size the project up front, then let it drive every later choice:

| Tier | Looks like | Branching | Merge | Release/CI |
|---|---|---|---|---|
| **Solo / small** (1 maintainer, few contributors) | most new tools & libraries | GitHub Flow: `main` + short-lived `feat/*`, `fix/*` | squash + linear history | tag + GitHub Release; basic CI (lint/test/build) |
| **Medium** (a handful of regular contributors, real CI) | growing library with users | GitHub Flow; optional trunk-based if feature flags exist | squash + linear history; CODEOWNERS reviews | automated changelog (release-please/changesets); Dependabot |
| **Large** (many contributors, multiple shipped versions) | popular framework / multi-package | Git Flow *or* trunk + `release/x.y` branches | rebase or merge as topology needs | full automation, code scanning, release branches, governance |

Most of what the user brings you is **solo/small**. Say so and default there unless they describe otherwise.

## Workflow

Work through these phases conversationally. Skip or compress phases the user has already decided, and don't turn this into an interrogation — ask a few sharp questions, then move.

### 1. Understand and scope

Get just enough to plan well: what the project does in one sentence, who it's for, the language/stack, and the size tier. Confirm it's genuinely meant to be public and open — if so, a license is non-negotiable (without one it is all-rights-reserved by default, so nobody can legally use it).

Nudge the user toward a sharp, minimal MVP and a one-line vision. A written scope is what lets the project say "no" later and avoid contributor-driven scope creep. Capture it (README intro or a short `VISION`/`ROADMAP` note).

### 2. Brainstorm architecture for openness

This is where the skill earns its keep. Design the architecture with *contribution and adoption* as first-class goals, not just "does it run":

- **Modularity and clear boundaries** so a stranger can change one part without understanding all of it. Small, well-named public API/interface; obvious extension points.
- **Simplicity over cleverness.** Ship the smallest useful thing. Over-engineering is the top reason contributors bounce. Avoid Bazel/Nx/monorepo complexity at solo scale — default to a **single repo** and add a light monorepo (pnpm/Turborepo workspaces) only if there are genuinely multiple shipped packages.
- **A fast, documented local dev setup** (one or two commands to clone → run → test). If setup is painful, contributions never come.
- **Deployment / distribution path** appropriate to the type: a library publishes to a registry (npm/PyPI/crates/etc.); a CLI ships binaries/releases; a web app documents self-hosting (Docker/one-click) so people can actually run it.
- **Good UX from the first run**: sensible defaults, a working example, clear errors. For a tool, the quickstart *is* the product.

Propose 1-2 concrete architecture options with tradeoffs and a recommended pick. Name things well: short, lowercase-with-hyphens, memorable, and available on the relevant package registry.

### 3. Choose the license

Default to **MIT** — simplest, maximum adoption, zero friction — unless the project's goals point elsewhere. Present the choice plainly and recommend:

- **MIT** — libraries/tools you want everyone to use freely. (Default.)
- **Apache-2.0** — same freedom plus an explicit patent grant; better when corporate contributors or patent exposure are likely.
- **AGPL-3.0** — strong copyleft that closes the SaaS loophole; use to keep a hosted product from being cloned by competitors while staying open (note: scares off some corporate users).
- **MPL-2.0 / GPL-3.0** — file-level or full copyleft when derivatives should stay open.

Add the license as a top-level `LICENSE` file with the correct year and the user's name/handle. For Apache-2.0, also add source headers and a `NOTICE` file.

### 4. Plan the repo structure and community files

Propose the file set for the tier. For **solo/small**, the practical baseline is: `README.md`, `LICENSE`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, `CHANGELOG.md`, `.gitignore`, `.editorconfig`, and a `.github/` folder (issue templates, a PR template, `dependabot.yml`, a CI workflow). Add `CODEOWNERS`, discussions, and `FUNDING.yml` as the project grows.

Explain what each file is for and offer ready-to-paste contents. When the user wants the actual file bodies, read `references/templates.md` — it has copy-paste templates for every file above plus a great-README structure. Don't dump all of them unprompted; propose the set, then fill in what they want.

The README is the front door — spend real effort here. Lead with a one-line "what it does" (not "what it is"), a tidy single row of badges, install, and a copy-paste quickstart. Write `CONTRIBUTING.md` *proactively*, before contributors arrive.

### 5. Set up git, commits, and branching

Advise (and propose the commands for the user to run) on a clean git history from commit one:

- **Conventional Commits** for every commit: `<type>(scope): description` with types `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `ci`, etc. This keeps history readable *and* powers automated versioning/changelogs later. Commits should be atomic (one logical change) with an imperative subject and a body explaining *why*.
- **Branching by tier** (see the table above). For solo/small: work on `feat/*` or `fix/*` branches off `main`, open a PR, **squash-merge**, keep history linear.
- **Branch protection on `main`** from day one for anything public: require PR + passing checks, require linear history, block force-push/deletion. Add required reviews/CODEOWNERS as the team grows.
- Optionally set up **verified (signed) commits** — SSH signing is the low-friction path and reusing the existing GitHub key is fine.

For the full commit-type reference, branching-strategy deep dive, PR/merge guidance, SemVer rules, and release automation options, read `references/git-workflow.md` when you reach this phase.

### 6. CI, releases, and docs (right-sized)

- **CI (GitHub Actions):** a single `ci.yml` running lint + test + build on every PR is plenty to start. **Pin actions to full commit SHAs, not tags** (mutable tags are a real supply-chain risk). Add Dependabot and CodeQL as value grows.
- **Versioning & releases:** follow **SemVer** (`MAJOR.MINOR.PATCH`); `0.y.z` while the API is unstable, `1.0.0` when you commit to it. Tag releases (`vX.Y.Z`) and cut a GitHub Release. Add automated changelog/release tooling (release-please or changesets) only when manual upkeep starts to hurt.
- **Docs:** README-only is correct for most small projects. Escalate to a `docs/` folder, then a docs site (MkDocs/Docusaurus/VitePress) only when you need search/versioning. An `examples/` folder lowers onboarding friction cheaply.

`references/git-workflow.md` covers releases and CI in more depth.

### 7. Hand off with a checklist

Close by giving the user a concrete, ordered checklist of what to create/run and in what order, tailored to their project and tier — so they can execute at their own pace. Offer to generate any specific file body or exact command on request. See `references/checklist.md` for the master checklist to adapt.

## Guardrails and anti-patterns to steer away from

- **No LICENSE = not open source.** Never let a "public" repo ship without one.
- **Docs are the product's on-ramp.** Weak install/usage docs are the #1 thing separating adopted projects from ignored ones. Assume the reader shares none of your context.
- **Don't over-build.** Git Flow, monorepo tooling, and heavy governance on a solo tool are cargo-culting. Match ceremony to the size tier.
- **Respect SemVer.** A breaking change is major even if the diff is tiny — SemVer tracks compatibility, not code size.
- **Pin CI actions to SHAs**, commit lockfiles, and give workflows least-privilege permissions.
- **Plan for a real human maintainer.** Encourage boundaries, a clear scope to decline out-of-scope contributions kindly, and (as it grows) a second maintainer to avoid a bus factor of one.

## Reference files

Read these as needed — don't load them all up front:

- `references/templates.md` — copy-paste templates: README structure, LICENSE pointer, CONTRIBUTING, CODE_OF_CONDUCT, SECURITY, CHANGELOG, `.gitignore`/`.editorconfig`, issue/PR templates, `dependabot.yml`, a starter `ci.yml`.
- `references/git-workflow.md` — Conventional Commits full type list, branching strategies by size, PR/merge methods, SemVer, tags/releases, release automation, signed commits.
- `references/checklist.md` — the master setup checklist to tailor and hand to the user.
