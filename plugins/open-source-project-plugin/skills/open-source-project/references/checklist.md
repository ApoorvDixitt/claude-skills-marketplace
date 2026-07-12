# Master Setup Checklist

Tailor this to the project and its size tier, then hand it to the user as an ordered to-do. Drop items that don't fit a solo/small project; add the "grows to medium+" items only when relevant. Offer to generate any specific file body or exact command.

## Phase 0 — Decide
- [ ] One-line description and target user written down
- [ ] Language/stack chosen
- [ ] Size tier chosen (solo/small · medium · large) → drives branching, CI, releases
- [ ] License chosen (default MIT)
- [ ] Repo name picked (short, lowercase-hyphens, available on the target package registry)

## Phase 1 — Architecture
- [ ] MVP scope written; a clear "out of scope for now" list
- [ ] Module boundaries / public API sketched with contribution in mind
- [ ] Local dev setup defined (clone → install → run → test in 1-2 commands)
- [ ] Distribution/deployment path decided (registry publish · release binaries · Docker/self-host)

## Phase 2 — Create the repo
- [ ] Local repo initialized, `main` as default branch
- [ ] `LICENSE` added (correct year + name; NOTICE + headers for Apache-2.0)
- [ ] `README.md` with description, badges, install, quickstart
- [ ] `.gitignore` (from github/gitignore) and `.editorconfig`
- [ ] First commit using Conventional Commits (`chore: initial commit` or `feat: initial ...`)
- [ ] GitHub repo created (public) and pushed

## Phase 3 — Community files
- [ ] `CONTRIBUTING.md`
- [ ] `CODE_OF_CONDUCT.md` (Contributor Covenant 2.1 + contact)
- [ ] `SECURITY.md`
- [ ] `CHANGELOG.md` (or automated release tooling instead)
- [ ] `.github/ISSUE_TEMPLATE/` (bug + feature YAML forms) and `PULL_REQUEST_TEMPLATE.md`
- [ ] Enable Discussions (optional, keeps issues actionable)

## Phase 4 — Git hygiene & protection
- [ ] Branch protection / ruleset on `main`: require PR, passing checks, linear history; block force-push/delete
- [ ] Merge method set to squash-and-merge
- [ ] (Optional) signed commits configured and required
- [ ] Branch naming convention documented (`feat/*`, `fix/*`)

## Phase 5 — CI & automation
- [ ] `.github/workflows/ci.yml` running lint + test + build on PR
- [ ] Actions pinned to full commit SHAs; least-privilege `permissions`
- [ ] `.github/dependabot.yml` for deps + github-actions
- [ ] (Grows to medium+) CodeQL / code scanning; release automation (release-please/changesets)

## Phase 6 — Docs & launch
- [ ] Quickstart verified by following it from scratch
- [ ] `examples/` folder with a runnable sample (if it helps)
- [ ] First tagged release `v0.1.0` + GitHub Release notes
- [ ] Repo description, topics/tags, and website link set on GitHub
- [ ] (Grows) docs site (MkDocs/Docusaurus/VitePress) when search/versioning needed

## Ongoing
- [ ] Keep README/CHANGELOG current with each release
- [ ] Triage issues; decline out-of-scope contributions kindly with reference to the scope
- [ ] Add a second maintainer before the bus factor bites
