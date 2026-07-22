# AI Policy Handling

How to navigate AI contribution policies. This is the reference for Step 2
(pre-flight check) of the oss-contribute workflow.

## Known Policies (as of 2026)

### BANS

**Gentoo Linux** (April 2024 Council vote):
"It is expressly forbidden to contribute to Gentoo any content that has been
created with the assistance of NLP AI tools."
- Scope: All Gentoo contributions
- Rationale: Copyright, quality, ethical concerns
- Source: wiki.gentoo.org/wiki/Project:Council/AI_policy

**curl** (de facto ban, no formal policy):
- Maintainer Daniel Stenberg is the most vocal anti-AI-slop voice in OSS
- 20% of 2025 submissions were AI slop; valid rate collapsed to 5%
- Any AI-assisted contribution faces extreme scrutiny
- Source: daniel.haxx.se/blog/2025/07/14/death-by-a-thousand-slops/

### DISCLOSURE REQUIRED

**Linux Kernel** (mandatory Assisted-by tag):
```
Assisted-by: AGENT_NAME:MODEL_VERSION [TOOL1] [TOOL2]
```
Example: `Assisted-by: Claude:claude-opus-4 coccinelle sparse`
- AI agents MUST NOT add Signed-off-by (only humans certify DCO)
- Human takes full responsibility
- Source: Documentation/process/coding-assistants.rst

**Apache Software Foundation** (recommended):
Include `Generated-by: <tool> <version>` in commit message.
- "Recommended practice," not mandatory
- Individual PMCs may be stricter
- Source: apache.org/legal/generative-tooling.html

### NO STATED POLICY (verified silent)

Rust, Go, Python/CPython, Kubernetes, React, Rails, Next.js — all silent.
Default: contributions judged on technical merit; contributor bears responsibility.

## Decision Matrix

| Policy Found | Action |
|-------------|--------|
| Explicit ban | DO NOT contribute with AI. Contribute manually or choose another project. |
| Disclosure required | Add `Assisted-by:` tag per project format. |
| Disclosure recommended | Add tag. Good practice even if not mandatory. |
| No policy + DCO | Your sign-off certifies authorship. Understand implications. |
| No policy at all | Proceed with quality practices. Disclose if asked. |
| Hostile culture signals | Treat as de facto ban. Extra scrutiny guaranteed. |

## What Separates Responsible AI Use from "AI Slop"

### The Single Most Reliable Signal

**"Can this person have a technical conversation about their contribution?"**

If yes → contribution is welcome regardless of how it was produced.
If no → contribution is unwelcome regardless of superficial quality.

### Behavioral Signals

| Dimension | Responsible | Slop |
|-----------|-------------|------|
| Review response | Responds 24-48h, explains reasoning | Goes silent |
| Code style | Uses project's utilities, matches patterns | Generic boilerplate |
| Tests | Edge cases, error paths, project framework | Happy-path, tautological |
| PR description | References issues, explains approach | Generic "improves quality" |
| Post-merge | Monitors for regressions | Disappears |
| Problem selection | Picks labeled issues | Unsolicited refactoring |
| Scope | Small, focused, one logical change | 20+ file mega-PRs |

### Contribution Types That Succeed with AI

1. Bug fixes for labeled issues
2. Documentation improvements
3. Test additions for untested code
4. Dependency updates
5. Accessibility improvements
6. i18n/localization

### Types That Consistently Fail

1. Unsolicited refactoring
2. Massive multi-file "improvements"
3. Security "fixes" for non-existent vulnerabilities
4. Algorithm replacements
5. Spray-and-pray across dozens of repos
