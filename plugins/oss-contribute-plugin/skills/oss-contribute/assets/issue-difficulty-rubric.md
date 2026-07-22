# Issue Difficulty Assessment: [Issue Title] (#[number])

## Issue Summary
[1-2 sentence summary of what the issue asks for]

## Scoring Rubric

| Dimension | Score (1-5) | Notes |
|-----------|-------------|-------|
| **Scope** (files affected) | _ | 1=single file, 3=multiple related, 5=cross-cutting |
| **Complexity** (logic required) | _ | 1=typo/config, 3=new function, 5=architectural change |
| **Test burden** | _ | 1=none needed, 3=unit tests, 5=integration+e2e |
| **Breaking change risk** | _ | 1=additive only, 3=internal API, 5=public API |
| **Domain knowledge** | _ | 1=self-evident, 3=need to read docs, 5=deep expertise |
| **Codebase familiarity needed** | _ | 1=isolated, 3=touch core abstractions, 5=understand full system |

**Total: _/30**

### Difficulty Rating
- 6-10: Beginner-friendly (good first issue)
- 11-16: Intermediate (comfortable contributor)
- 17-22: Advanced (experienced with this codebase)
- 23-30: Expert (maintainer-level understanding needed)

## Files Likely Affected
1. [file path] — [what changes]
2. [file path] — [what changes]

## Prerequisites
- [ ] Understand [concept/module]
- [ ] Read [related issue/PR/doc]
- [ ] Set up [tooling/env requirement]

## Related Context
- Previous attempts: [PR #X — why it failed/stalled]
- Related issues: [#Y, #Z]
- Relevant discussions: [links]

## Estimated Effort
- **Time:** [hours/days for someone familiar with the codebase]
- **For a new contributor:** [multiply by 2-3x for ramp-up]
