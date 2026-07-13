# File Templates

Copy-paste starting points for the community-health files. Adapt names, years, and stack-specific bits. Propose the relevant subset for the project's size tier — don't dump everything at once.

## Table of contents
- [README structure](#readme-structure)
- [LICENSE](#license)
- [CONTRIBUTING.md](#contributingmd)
- [CODE_OF_CONDUCT.md](#code_of_conductmd)
- [SECURITY.md](#securitymd)
- [CHANGELOG.md](#changelogmd)
- [.gitignore and .editorconfig](#gitignore-and-editorconfig)
- [Issue templates](#issue-templates)
- [Pull request template](#pull-request-template)
- [dependabot.yml](#dependabotyml)
- [ci.yml (starter)](#ciyml-starter)
- [release.yml (publish on tag)](#releaseyml-publish-on-tag)
- [FUNDING.yml](#fundingyml)

---

## README structure

The README is read in under a minute. Lead with what it *does*, keep it scannable, link out for depth.

```markdown
# project-name

> One sentence: what it does and for whom. ("A CLI that converts CSV to Markdown tables.")

[![CI](https://github.com/USER/REPO/actions/workflows/ci.yml/badge.svg)](https://github.com/USER/REPO/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
<!-- add version/coverage badges when they exist; keep to one tidy row -->

## Features
- Bullet the 3-5 things that matter.

## Installation
```bash
# the exact, copy-paste command(s), all install methods
npm install project-name
```

## Quickstart
```bash
# the smallest runnable example — this is make-or-break
project-name input.csv
```

## Usage
Slightly deeper examples, common flags/options, a screenshot or GIF for UI/CLI.

## Documentation
Link to the docs site / docs/ folder if one exists.

## Contributing
Contributions welcome — see [CONTRIBUTING.md](CONTRIBUTING.md) and the [Code of Conduct](CODE_OF_CONDUCT.md).

## License
[MIT](LICENSE) © YEAR NAME
```

Add a table of contents only if the README grows past ~5 sections.

---

## LICENSE

Don't hand-type license text. Use the exact text from https://choosealicense.com or GitHub's "Add file → Choose a license template." For **MIT**, the only fill-ins are the year and copyright holder:

```
MIT License

Copyright (c) YEAR NAME

Permission is hereby granted, free of charge, to any person obtaining a copy
... (full text from choosealicense.com/licenses/mit/) ...
```

For **Apache-2.0**, add the full `LICENSE`, a short header comment to each source file, and a `NOTICE` file for attributions.

---

## CONTRIBUTING.md

```markdown
# Contributing

Thanks for your interest in improving **project-name**!

## Development setup
```bash
git clone https://github.com/USER/REPO.git
cd REPO
<install deps>      # e.g. npm install
<run tests>         # e.g. npm test
```

## Workflow
1. Create a branch off `main`: `feat/short-description` or `fix/short-description`.
2. Make atomic commits using [Conventional Commits](https://www.conventionalcommits.org): `feat(scope): ...`, `fix: ...`, `docs: ...`.
3. Ensure lint and tests pass locally.
4. Open a pull request. Fill in the template and link any related issue.
5. Maintainers squash-merge once checks pass and review is approved.

## Reporting bugs / requesting features
Open an issue using the provided templates. For questions, use Discussions.

## Code of Conduct
This project follows the [Code of Conduct](CODE_OF_CONDUCT.md).
```

---

## CODE_OF_CONDUCT.md

Use **Contributor Covenant 2.1** verbatim from https://www.contributor-covenant.org/version/2/1/code_of_conduct/ and fill in the enforcement contact (an email you monitor).

---

## SECURITY.md

```markdown
# Security Policy

## Supported versions
| Version | Supported |
|---------|-----------|
| latest  | ✅         |
| < latest| ❌         |

## Reporting a vulnerability
Please do **not** open a public issue for security problems.
Report privately via GitHub's "Report a vulnerability" (Security tab → Advisories),
or email SECURITY-CONTACT. We aim to respond within X days.
```

---

## CHANGELOG.md

Follow [Keep a Changelog](https://keepachangelog.com). Skip this file entirely if you automate releases (release-please/changesets generate it).

```markdown
# Changelog

All notable changes to this project are documented here.
The format is based on Keep a Changelog, and this project adheres to Semantic Versioning.

## [Unreleased]

## [0.1.0] - YYYY-MM-DD
### Added
- Initial release.
```

---

## .gitignore and .editorconfig

Pull a stack-appropriate `.gitignore` from https://github.com/github/gitignore. Minimal `.editorconfig`:

```ini
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
indent_style = space
indent_size = 2
```

---

## Issue templates

Prefer YAML "issue forms" in `.github/ISSUE_TEMPLATE/`. Bug report (`bug_report.yml`):

```yaml
name: Bug report
description: Report something that isn't working
labels: [bug]
body:
  - type: textarea
    id: what-happened
    attributes:
      label: What happened?
      description: Include steps to reproduce, expected vs actual behavior.
    validations:
      required: true
  - type: input
    id: version
    attributes:
      label: Version
    validations:
      required: true
```

Add `feature_request.yml` similarly, and a `config.yml` to add contact links / disable blank issues.

---

## Pull request template

`.github/PULL_REQUEST_TEMPLATE.md`:

```markdown
## Summary
What does this change and why?

## Related issue
Closes #

## Checklist
- [ ] Tests pass locally
- [ ] Docs / CHANGELOG updated if needed
- [ ] Commits follow Conventional Commits
```

---

## dependabot.yml

`.github/dependabot.yml` (adjust ecosystem):

```yaml
version: 2
updates:
  - package-ecosystem: "npm"     # or pip, cargo, gomod, docker...
    directory: "/"
    schedule:
      interval: "weekly"
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
```

---

## ci.yml (starter)

`.github/workflows/ci.yml`. Pin actions to full commit SHAs (the `# vX` comment is for humans; Dependabot updates the SHA):

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:
permissions:
  contents: read
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
      - uses: actions/setup-node@1e60f620b9541d16bece96c5465dc8ee9832be0b # v4.0.3
        with:
          node-version: "20"
      - run: npm ci
      - run: npm run lint
      - run: npm test
      - run: npm run build --if-present
```

Swap the language setup steps for the project's stack. Keep installs deterministic (`npm ci`, `poetry install`, etc.) and commit the lockfile.

---

## release.yml (publish on tag)

Add this **only when a project ships an installable artifact** and manual publishing has become
repetitive — it's the step-2 automation from `releasing-and-publishing.md`. Keep it a **separate
workflow from `ci.yml`**: publishing needs elevated permissions and should be narrowly scoped.

The example below uses **PyPI trusted publishing (OIDC)** — the canonical pattern. It shows the
two ideas that generalize to any registry: **build and publish are separate jobs**, and only the
tiny publish job gets `id-token: write` (job-scoped), gated by a `release` environment. No API
token is stored anywhere. First configure the trusted publisher on the registry, scoped to this
`owner/repo` + workflow filename + environment.

```yaml
name: Release
on:
  push:
    tags: ["v*"]          # publish only when a version tag is pushed
permissions: {}           # default to nothing; grant per-job below

jobs:
  build:                  # build with least privilege — no publish rights
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
      - uses: actions/setup-python@0b93645e9fea7318ecaed2b359559ac225c90a2b # v5.3.0
        with:
          python-version: "3.12"
      - run: python -m pip install build && python -m build
      - uses: actions/upload-artifact@65c4c4a1ddee5b72f698fdd19549f0f0fb45cf08 # v4.6.0
        with: { name: dist, path: dist/ }

  publish:                # the only job with publish rights
    needs: build
    runs-on: ubuntu-latest
    environment: release  # gate: add required reviewers on this environment in repo settings
    permissions:
      id-token: write      # mint the short-lived OIDC token — this line is what enables OIDC
    steps:
      - uses: actions/download-artifact@fa0a91b85d4f404e444e00e005971372dc801d16 # v4.1.8
        with: { name: dist, path: dist/ }
      - uses: pypa/gh-action-pypi-publish@76f52bc884231f62b9a034ebfe128415bbaabdf1 # v1.12.4
        # no username/password: the action uses the OIDC token automatically
```

Adapting to other registries — the skeleton (tag trigger → build job → OIDC publish job, env-gated)
stays identical; swap the publish step:

- **npm** (OIDC, provenance automatic): in the publish job, `setup-node` with
  `registry-url: https://registry.npmjs.org`, then `npm ci && npm publish`. Keep `id-token: write`.
  Requires npm CLI ≥ 11.5.1; use `--access public` for a scoped package's first publish.
- **crates.io / RubyGems**: swap in their OIDC publish action / `cargo publish` / `gem push`.
- **Compiled CLI/app**: replace the build job with **GoReleaser** (`goreleaser/goreleaser-action`,
  `fetch-depth: 0`) or **cargo-dist**, which build the OS/arch matrix and upload binaries +
  checksums to the GitHub Release themselves.
- **No OIDC available** (self-hosted runner / unsupported registry): drop `id-token: write`, add
  the registry token as a repo/environment secret, and pass it to the publish step instead.

---

## FUNDING.yml

Add only when relevant. `.github/FUNDING.yml`:

```yaml
github: [USERNAME]
# open_collective: name
# ko_fi: name
```
