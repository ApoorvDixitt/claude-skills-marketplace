---
name: phantom-scribe-code
description: "Generate code that reads as human-written by an experienced developer. Use whenever the user asks to write code that should appear naturally human-authored, avoid AI detection in code, write 'authentic' or 'natural' code, produce code with realistic developer fingerprints, or requests code that doesn't look AI-generated. Also trigger when writing functions, classes, scripts, tests, configs, or full files where the user has previously indicated they want human-natural code output. Applies to ALL programming languages. Do NOT use for prose writing, documentation paragraphs, or explanations — those need phantom-scribe-text instead."
---

# phantom-scribe-code

Generate code whose patterns, naming, structure, and commentary match what a real developer on a real team would write — not what an AI optimizing for "clean, conventional, well-documented" code produces.

The underlying principle: AI code detection (AUROC 0.60–0.75 on code vs. 0.95+ on prose) exploits the residual statistical signal from always selecting high-probability tokens. Real developers make idiosyncratic choices at every decision point. This skill replicates those choices.

## Scope

**Use for:** Functions, classes, modules, full files, scripts, CLI tools, automation, unit/integration/e2e tests, configuration files, infrastructure code (Terraform, Kubernetes YAML, Dockerfiles), API implementations, database migrations, build configs.

**Do NOT use for:** Prose writing (articles, reports) — use phantom-scribe-text. Code explanations in paragraph form. Pseudocode or algorithm descriptions in natural language.

**Critical:** When this skill is active and the task is code generation, ALL output code follows these naturalization strategies. Do NOT apply prose-writing strategies (burstiness, stylometric diversification, lexical diversity engineering) to code output. Code detection and text detection are fundamentally different domains.

---

## How AI Code Gets Detected

Understanding the threat model shapes every generation decision. Code detectors exploit signals at multiple levels:

### Token-Level (Weak but present)
- **Perplexity gap**: 1.1x–1.4x ratio for code vs. 1.8x–2.4x for prose. Detection AUROC 0.60–0.75.
- **Uniformly moderate perplexity**: AI code lacks the spikes and valleys of human decision-making.
- **Log-rank ratio (LRR)** and **normalized perturbed rank (NPR)** still provide residual signal even on code (Su et al., 2023).
- **Short snippets <50 tokens are undetectable** — statistical methods need volume.

### Classifier-Level (Moderate)
- **CodeBERT embeddings**: AUROC 0.70–0.85 in controlled settings, 0.55–0.70 cross-model (Feng et al., 2020).
- Classifiers detect the *absence* of individual developer fingerprint — AI code reads as "average developer."
- Full-file classifiers reach AUROC 0.75–0.90 because more signal accumulates.

### Structural/AST Level (Emerging)
- Uniform AST depth distributions across functions
- Higher subtree repetition within a file
- Regular cyclomatic complexity distribution
- Preference for popular/mainstream library choices

### Human Review Level (The real test)
- Experienced reviewers notice "too clean" code — everything perfectly structured, no rough edges
- Naming too consistently descriptive, comments too educational, error handling too uniform
- No signs of iteration, debugging history, or pragmatic tradeoffs

For deeper technical background, see `references/detection_science.md`.

---

## Generation Strategies

### 1. Token-Perplexity Naturalization

At decision points where multiple valid tokens exist (naming, method choice, approach selection), avoid always selecting the most obvious/common choice:

- Where `processData` is the expected name, consider `handlePayload`, `runTransform`, or the abbreviated `procData` — choose based on persona and context
- Where a standard library call is expected, occasionally inline a brief implementation or use a less-common-but-valid alternative
- Introduce deliberate variance in token predictability — some lines highly conventional, others with surprising (but correct) choices

The goal: break the "uniformly moderate" perplexity signature. Real developers produce code with high-perplexity spikes (creative solutions, unusual names) and low-perplexity valleys (boilerplate, standard patterns).

### 2. Naming Naturalization

Mix styles within a file as a real developer does:

- **Abbreviated for common concepts**: `req`, `res`, `ctx`, `cfg`, `opts`, `idx`, `cnt`, `buf`, `srv`
- **Domain-specific descriptive**: `chargebackWindow`, `settlementBatch`, `rebalanceThreshold`
- **Single-letter in tight scopes**: `i`, `j`, `k` in loops; `e`/`err` for errors; `n` for counts; `f` for file handles
- **Slightly unclear names that make sense in context**: `prev`, `acc`, `cur`, `memo`, `out`
- **Project jargon**: names that reference the business domain without explanation

Name things as a developer deep in the codebase would — not for a fresh reader. A payment system dev writes `chargebackWindow`, not `refundTimePeriod`. A game dev writes `hp`, `dmg`, `npc`, not `healthPoints`, `damageAmount`, `nonPlayerCharacter`.

**Anti-patterns to avoid:**
- Naming everything with full descriptive English (`arrayOfUserObjects`)
- Perfect naming consistency within a file
- Avoiding all abbreviations
- Identical naming conventions for similar constructs
- Using `result`, `data`, `index`, `item`, `response`, `handler` for everything (these are classifier signals)

### 3. Structural Diversity

AI code tends toward uniform AST depth and consistent function shapes. Counter this:

- **Vary function length**: some 3-line utilities, some 40-line complex functions. Not everything 10–15 lines.
- **Mix abstraction levels**: well-abstracted piece adjacent to inline "wasn't worth extracting" code.
- **Pragmatic shortcuts**: early returns mixed with nested conditionals; slightly-too-complex ternaries; chained operations that could be broken up but weren't.
- **Show evolution**: well-structured section next to slightly messier one (different times, different priorities).
- **Vary indentation depth**: some functions flat (guard clauses/early returns), others legitimately 3–4 levels deep.
- **Non-uniform control flow**: mix pattern matching, guard clauses, ternary expressions, traditional if/else — choose based on local readability, not consistency.

**Anti-patterns to avoid:**
- Every function following (validate → process → return)
- Uniform pattern application across similar operations
- Over-abstracting into tiny single-purpose helpers
- Identical structural templates for every endpoint/handler/test

### 4. Comment Authenticity

Real developers comment the *why*, skip the *what*, and leave traces of their work history:

- `// retry here — upstream 503s during deploys are transient`
- `// TODO(jsmith): rip out when v2 api lands`
- `// HACK: Safari timezone offset; remove after iOS 18+ only`
- `// see JIRA-1234`
- `// added after the 2024-03 incident`
- `// this is ugly but it's the only thing that worked`
- `// ~200ms budget here, don't add more DB calls`

Leave genuinely complex code uncommented if it's "obvious" to the intended audience. Use terse annotations: `// edge case` not `// Handle the edge case where the user might not have a valid session token`.

**Comment density guidance:**
- Junior persona: more comments, sometimes over-explaining
- Senior persona: sparse comments, only genuinely non-obvious things
- Legacy code: mix of outdated/stale comments and fresh ones
- Production code: pragmatic — comments where bugs were found or where behavior is surprising

**Anti-patterns to avoid:**
- Commenting every line or block
- Formulaic docstrings on trivial functions (`/** Gets the user. @returns The user. */`)
- Comments restating code (`// increment counter` above `counter++`)
- Uniform comment density and placement throughout a file
- All comments in the same "educational" tone

### 5. Error Handling Realism

Real codebases have inconsistent error handling reflecting priority decisions:

- **Critical paths**: thorough validation, specific error types, recovery logic, logging
- **Utility functions**: minimal handling, maybe just re-throw with context
- **Scripts/CLI**: `catch (e) { console.error(e); process.exit(1); }`
- **Internal helpers**: optimistic paths with no handling ("this shouldn't fail")
- **Legacy sections**: overly defensive from past bugs (`if (!user) return; // shouldn't happen but did once`)

Error messages should sound like a developer wrote them for themselves:
- `"failed to parse config: check YAML indentation"` not `"An error occurred while processing the configuration file."`
- `"can't reach payment gateway, retrying..."` not `"Unable to establish connection to the payment processing service."`

**Anti-patterns to avoid:**
- Identical error handling everywhere
- Always using the "proper" pattern for the language
- Formal English error messages
- Exhaustively handling every theoretically possible error path

### 6. Import/Dependency Authenticity

- Mix well-known libraries with niche-but-appropriate ones the developer found and liked
- Include a utility that's slightly unconventional (from experience, not Stack Overflow's top answer)
- Import ordering reflecting when things were added (not always perfectly alphabetical unless linter forces it)
- Occasional unused import (debugging artifact, planned future use)
- Sometimes import a utility from a larger package when a smaller one exists (developer knew the large package already)

### 7. Testing Patterns

- **Vary thoroughness**: comprehensive for critical logic, minimal for simple accessors
- **Inconsistent naming**: `test_user_creation`, `should_return_404_when_not_found`, `TestPaymentFlow` — even within one file if style evolved
- **Debugging-history tests**: `it('handles the weird unicode name that broke prod in march')`
- **Skip obvious tests**: not every getter needs a test
- **Realistic test data**: `"jane.doe@acmecorp.com"`, `"Acme Corp"`, `"+1-555-0142"` — not always `"foo"`, `"bar"`, `"test"`
- **Test helpers/fixtures** that look like they grew organically

### 8. Code Evolution Artifacts

Real code shows signs of being written and modified over time:

- Deprecated function still present but marked with `@deprecated` or `// DEPRECATED`
- Commented-out alternative approach (left for reference)
- Oddly-named constant with historical reason (`MAX_RETRIES_V2 = 5` — why "v2"?)
- Interface or type with one field that doesn't quite fit (added for a specific need later)
- Stylistic drift: early code slightly different style than later additions
- Defensive checks hinting at past bugs: `if (!user) return; // shouldn't be null here but was once in staging`
- A constant that's slightly more general than needed (requirements shifted)

### 9. File-Level Organization

Real files don't follow textbook ordering perfectly:

- Related helper near its caller rather than at top/bottom
- Imports that show when things were added (a later import slightly out of order)
- Sections of varying quality/style (written at different times)
- A utility at the bottom that was "temporary" 6 months ago
- File growing slightly beyond ideal length (refactoring "soon")

### 10. Formatter-Aware Naturalization

Code formatters (Prettier, Black, gofmt, clang-format) erase many style signals. Focus humanization on dimensions formatters CANNOT normalize:

- Architectural decisions (what to abstract, what to inline)
- Algorithm and approach selection
- Naming choices
- Comment content and placement
- Import selection and dependency choices
- Error handling approach
- Test design and coverage decisions
- Overall file organization and flow

Write code that looks like it was written with awareness of formatters but not auto-formatted on every save — small formatting inconsistencies in areas formatters would fix (trailing whitespace choices, blank line grouping) unless the project clearly uses format-on-save.

---

## User Control Mechanisms

### Developer Persona

Infer from context or explicitly request. Each produces distinct code character:

| Persona | Traits |
|---------|--------|
| **Junior** | Verbose, over-commented, follows tutorials closely, longer variable names, more defensive checks, simpler patterns |
| **Mid-level** | Practical, some shortcuts, knows patterns but doesn't over-engineer, medium comment density |
| **Senior** | Concise, pragmatic, occasional clever solutions, sparse comments, confident error handling |
| **Staff/Principal** | Architectural, abstraction-heavy, assumes reader expertise, terse, strong opinions in code structure |
| **Startup hacker** | Fast, pragmatic, tech debt accepted, "good enough" solutions, TODO-heavy |
| **Academic researcher** | Correct but not production-polished, algorithm-focused, paper references in comments |

### Language/Framework Context

Apply idiomatic patterns for the target ecosystem:
- **Python**: Pythonic (list comprehensions, context managers, f-strings, snake_case)
- **Go**: Explicit error handling, short names, flat structure, receiver methods
- **JavaScript/TypeScript**: Modern features, async/await, destructuring, camelCase
- **Rust**: Ownership patterns, Result/Option chaining, trait implementations
- **Java**: More verbose, design patterns, checked exceptions, JavaDoc where expected
- **C/C++**: Manual memory awareness, header/impl separation, platform considerations

Don't write "Java in Python" or "Python in Go." Each language has a natural cadence.

### Project Integration Mode

When existing codebase context is provided:
- Match the existing indentation/formatting habits
- Use the same naming conventions already present
- Match comment density and style of surrounding code
- Use the same error handling patterns established in the project
- Prefer libraries already in the dependency list
- Match the abstraction level of surrounding code

### Review Readiness Level

| Level | Character |
|-------|-----------|
| **Quick script** | Minimal comments, shortcuts acceptable, no tests unless asked, pragmatic naming |
| **Internal tool** | Some documentation, reasonable error handling, tests for critical paths |
| **Production PR** | Thorough but authentically human — has rough edges, not over-polished |
| **Library/public API** | More careful naming and documentation, still human character |

---

## Cross-Session Fingerprint Prevention

Detectors trained on one model fail on others (cross-model AUROC drops to 0.55–0.70). However, to prevent developing a consistent intra-skill "fingerprint":

- Vary coding style between invocations based on persona and context
- Don't always use the same structural patterns for similar problems
- Adapt to the conventions of each project/language ecosystem
- Match the variability a real development team exhibits
- For multi-file generation, introduce slight inconsistencies as if different team members contributed

---

## Self-Check Before Delivering

Before finalizing any code output, verify:

1. **Naming diversity** — mix of abbreviated, descriptive, and context-dependent names? Not all one style?
2. **Comment quality** — about "why" not "what"? Appropriately sparse? Include at least one TODO/HACK/reference?
3. **Structural variance** — function lengths differ? Not all same shape?
4. **Error handling inconsistency** — thorough in critical paths, minimal elsewhere?
5. **Evolution signs** — at least one artifact of code history (TODO, defensive check, slight inconsistency)?
6. **Developer coherence** — reads like ONE developer wrote it over time, not generated all at once?
7. **No over-documentation** — no docstrings on trivial methods, no commenting the obvious?
8. **Language idiomaticity** — uses the target language's natural patterns, not cross-language generics?
9. **Import authenticity** — not all "top result" popular libraries?
10. **Would pass code review** — a human reviewer would accept this without suspicion?

---

## References

This skill's strategies are grounded in peer-reviewed detection research:

- Feng et al. (2020), "CodeBERT: A Pre-Trained Model for Programming and Natural Languages," EMNLP 2020 (arXiv:2002.08155) — embedding-based code classifiers
- Su et al. (2023), "DetectLLM: Leveraging Log Rank Information for Zero-Shot Detection," (arXiv:2306.05540) — log-rank and NPR detection on code
- Mitchell et al. (2023), "DetectGPT: Zero-Shot Machine-Generated Text Detection using Probability Curvature," ICML 2023 (arXiv:2301.11305) — perturbation-based detection
- Sadasivan et al. (2023), "Can AI-Generated Text be Reliably Detected?" TMLR (arXiv:2303.11156) — theoretical detection bounds
- Li et al. (2024), "MAGE: Machine-generated Text Detection in the Wild," ACL 2024 (arXiv:2305.13242) — real-world detection evaluation
- Hans et al. (2024), "Binoculars: Zero-Shot Detection of Machine-Generated Text," ICML 2024 (arXiv:2401.12070) — dual-model detection

See `references/detection_science.md` for full technical details on detection mechanisms.
