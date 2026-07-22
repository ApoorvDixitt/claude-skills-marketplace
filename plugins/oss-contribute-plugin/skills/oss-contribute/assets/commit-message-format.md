# Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Rules

- `<type>`: feat, fix, docs, style, refactor, perf, test, chore, ci, build
- `<scope>`: optional — component/module affected (e.g., parser, auth, cli)
- `<subject>`: imperative mood, no period, max 72 chars, lowercase start
- `<body>`: explain WHAT and WHY (not HOW — the diff shows how), wrap at 72
- `<footer>`: Fixes #123, BREAKING CHANGE: description, Signed-off-by:

## Examples

```
fix(auth): prevent token refresh race condition

When multiple requests trigger token refresh simultaneously, only the
first should perform the refresh while others wait for the result.
Added a mutex lock around the refresh logic and a pending promise that
subsequent callers await.

Fixes #789
```

```
docs(api): add rate limiting section to REST API guide

New contributors frequently hit rate limits without understanding why.
Added a dedicated section covering limits, headers to check, and
backoff strategies.

Closes #234
```

```
feat(cli): add --dry-run flag to deploy command

Allows users to preview deployment changes without executing them.
Outputs a diff of what would change in the target environment.

BREAKING CHANGE: deploy command now requires explicit --execute flag
for production deployments (previously the default behavior).

Fixes #456
```

## Remember

- Always check the project's CONTRIBUTING.md — many override this format
- If the project uses Signed-off-by (DCO), add: `git commit -s`
- If AI disclosure required, add: `Assisted-by: Claude:claude-opus-4`
