# Codebase Recon Guide

How to understand an unfamiliar codebase before contributing. This is Step 3 of
the oss-contribute workflow — read this file when you reach that step.

## The Recon-First Principle

From Mitchell Hashimoto (HashiCorp founder): "Understand the problem domain before
the code — domain context speeds comprehension 10x vs code-first approach."

Never start writing code in an unfamiliar repo without first building a mental model.
The recon report you produce at this step becomes your reference for every subsequent
step — implementation, testing, commit messages, PR descriptions all draw from it.

## Systematic Reading Order

1. **README and architecture docs** — overall purpose, design philosophy
2. **CONTRIBUTING.md** — workflow expectations, build/test/lint commands
3. **Run the test suite** — confirms environment works AND shows what code does
4. **Read 5-10 recent merged PRs** — reveals unwritten conventions
5. **git blame on confusing code** — find the WHY behind decisions
6. **Trace one complete operation end-to-end** — don't try to understand everything at once

## Building a Mental Model

- Identify the "core loop" — main entry point, trace one complete user action
- Build a 3-5 component mental model first (not everything)
- Identify "connective tissue" — message buses, event systems, shared state
- Start with core data structures — everything flows from how data is represented
- Read interfaces/contracts first — public APIs carry more signal than implementation

## Spotting Unwritten Conventions via Git History

```bash
# Typical modification patterns in a directory
git log --oneline -20 path/to/dir/

# Find area experts (who to ping if stuck)
git log --format='%an' path/to/file | sort | uniq -c | sort -rn

# Trace a file's evolution
git log -p --follow -3 path/to/file

# What do recent commit messages look like?
git log --oneline -30
```

**What to look for:**
- How existing PRs are structured (single commit vs many, squash policy)
- What reviewers comment on (reveals unstated expectations)
- Formatting not captured in linter config
- PR discussions (not just diffs) for design decisions

## Using Subagents for Large Codebases

For repos with 100+ files, parallelize the recon:

- **Agent 1:** "Map the module dependency graph and identify core abstractions"
- **Agent 2:** "Read the last 10 merged PRs and extract unwritten conventions"
- **Agent 3:** "Analyze the test suite structure and identify testing patterns"

Synthesize findings from all three into the recon report.

## Per-Project CLAUDE.md

After recon, persist what you learned in a CLAUDE.md at the project root:

```markdown
# Build: npm run build
# Test: npm test (unit), npm run test:e2e (integration)
# Lint: npm run lint
# Commit format: conventional commits (feat/fix/docs/chore)
# PR convention: reference issue number, squash on merge
# Key conventions: functional components only, Result type for errors
```

This survives across sessions — next time you work on this repo, you don't
re-derive everything from scratch.

## Dependency Graphs

| Language | Tool |
|----------|------|
| JavaScript/TypeScript | madge, dependency-cruiser |
| Python | pydeps, import-linter |
| Go | go mod graph + Graphviz |
| Rust | cargo-depgraph |
| Cross-repo | Sourcegraph |

Start with the package manifest (package.json / requirements.txt / go.mod / Cargo.toml).
Identify "god modules" imported everywhere — these are core abstractions you must
understand first.

## Tests as Documentation

Tests are the most reliable documentation because they must stay in sync with code:

- Read test names first (without bodies) — table of contents of behaviors
- Test assertions reveal API semantics: inputs, expected outputs, illegal states
- Integration tests reveal the "story" of the system better than unit tests
- Test fixtures show expected data shapes
- `@skip` / `xit` tests document known bugs or unfinished features
