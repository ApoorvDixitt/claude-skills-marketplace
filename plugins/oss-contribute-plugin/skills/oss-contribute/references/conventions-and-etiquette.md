# Conventions and Etiquette

Standards for open source contribution — commit formats, communication norms,
and the mistakes that get PRs rejected. Read this during Steps 5-7 of the workflow.

## Commit Message Conventions

### Conventional Commits Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Rules:**
- `<type>`: feat, fix, docs, style, refactor, perf, test, chore, ci, build
- `<scope>`: optional, component/module affected
- `<subject>`: imperative mood, no period, max 72 chars, lowercase start
- `<body>`: explain WHAT and WHY (not HOW — the diff shows how), wrap at 72 chars
- `<footer>`: `Fixes #123`, `BREAKING CHANGE: desc`, `Co-authored-by:`

### Linux Kernel Convention

Imperative mood: "make xyzzy do frotz" not "this patch makes xyzzy do frotz."

### Always Check the Project's CONTRIBUTING.md

Many projects override these defaults. Common variations:
- Prefix with issue number: `[#123] fix: correct token refresh`
- Prefix with component: `auth: fix token refresh race`
- Require sign-off: `Signed-off-by: Name <email>`

## Communication Norms

- **Keep communication public** (issue tracker, not DMs)
- **Be patient** — maintainers are often volunteers across timezones
- **Defer to maintainers** — they know the project better than you
- **Don't feel entitled** to a response or merge
- **Read all documentation** before asking questions
- **Give context** — do homework first, keep requests short and direct
- **Propose large changes in an issue first** — before writing code

From Mike McQuaid (Homebrew): "Understand that it's not the job of the
maintainers to teach you how the project works."

## Matching Code Style

1. Check linting/formatting configuration (`.eslintrc`, `.prettierrc`, `rustfmt.toml`)
2. Run the formatter before committing
3. Read recent merged PRs for current conventions
4. Use `git log -p` on files you're modifying to see patterns
5. Linux kernel rule: "Coding style must match the existing codebase exactly"

**Specific things to match:**
- Import ordering
- Comment style (// vs /* */, JSDoc vs plain)
- Error handling pattern (Result type, throw + boundary, error codes)
- File organization (co-located tests vs separate __tests__ dir)
- Naming (camelCase vs snake_case, prefixes, suffixes)

## The Review/Revision Cycle

- Respond to ALL reviewer comments (even just "done" or "good point, fixed")
- Use "Resolve conversation" button when addressed
- Push additional commits to the same branch (they auto-appear in the PR)
- Force-push vs new commits: follow project convention
- If no response after 7 days, a polite follow-up ping is appropriate
- Be patient and gracious — maintainers volunteer their time

## Common Mistakes That Get PRs Rejected

1. **PRs too large** — one logical change per PR
2. **No tests included** — maintainers require tests for new code
3. **Ignoring CI failures** — if CI breaks, fix it or explain why
4. **Drive-by PRs with no context** — no related issue, no description of why
5. **AI-generated code without review** — many projects are hostile to this
6. **Not reading CONTRIBUTING.md** — instant close, pointer to docs
7. **Not matching existing code style** — violating linting/formatting norms
8. **Stale PRs** — not responding to review feedback within ~2 weeks
9. **Features out of scope** — always propose in an issue first
10. **Unsolicited refactoring** — "I made your code better" without being asked

## PR Size Guidelines

- Ideal: 50-200 lines changed
- Acceptable: up to 500 lines for well-scoped features
- Danger zone: 500+ lines — split into multiple PRs if possible
- Exception: generated files (migrations, snapshots) don't count

## Forking and Branching

**Remote naming:**
- `origin` = your fork
- `upstream` = the original project

**Standard workflow:**
```bash
git clone <your-fork-url>
git remote add upstream <original-repo-url>
git pull upstream main
git checkout -b fix/issue-123
# ... make changes ...
git push origin fix/issue-123
# Open PR from your fork's branch to upstream's main
```

**Branch naming:** Descriptive of the change:
- `fix/typo-in-config`
- `feature/add-parser`
- `docs/update-readme`
