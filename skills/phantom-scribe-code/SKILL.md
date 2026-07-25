---
name: phantom-scribe-code
description: "Generate code that reads as human-written by an experienced developer. Use whenever the user asks to write code that should appear naturally human-authored, avoid AI detection in code, write 'authentic' or 'natural' code, produce code with realistic developer fingerprints, or requests code that doesn't look AI-generated. Also trigger when writing functions, classes, scripts, tests, configs, or full files where the user has previously indicated they want human-natural code output. Applies to ALL programming languages. Do NOT use for prose writing, documentation paragraphs, or explanations — those need phantom-scribe-text instead."
---

# phantom-scribe-code

Generate code whose patterns, naming, structure, and commentary match what a real developer on a real team would write — not what an AI optimizing for "clean, conventional, well-documented" code produces.

## Scope

**Use for:** Functions, classes, modules, full files, boilerplate, tests (unit/integration/e2e), configuration, infrastructure code, scripts, automation, CLI tools, API implementations, refactoring.

**Do NOT use for:** Prose writing (articles, reports) — use phantom-scribe-text. Code explanations in paragraph form. Pseudocode or algorithm descriptions in natural language.

**Critical:** When this skill is active and the task is code generation, ALL output should be code, code comments, and minimal necessary explanation. Do NOT apply prose-writing strategies (burstiness, stylometric diversification, perplexity engineering) to code output. Code has its own distinct naturalism patterns.

---

## Why AI Code Gets Detected

Code detection is harder than text detection because programming languages have low entropy — syntax constraints limit valid tokens at most positions. But detectable patterns exist:

1. **Perplexity gap** (1.1x–1.4x ratio vs. human code; detection AUROC 0.60–0.75). Short snippets <50 tokens are undetectable. (Su et al., 2023)
2. **Naming uniformity** — AI gravitates toward `result`, `data`, `index`, `item`, `response`, `handler`. Humans use project-specific terms, abbreviations, single-letter vars in tight scopes.
3. **AST pattern regularity** — Uniform nesting depth, consistent structural patterns, high subtree repetition within a file.
4. **Comment formulaicity** — Over-explanatory ("// Iterate through the array") or formulaic docstrings. Humans comment the "why," leave TODOs, reference tickets.
5. **Error handling uniformity** — Same pattern applied everywhere. Humans are thorough in critical paths, lazy in utilities.
6. **Embedding classifiers** — CodeBERT-based: AUROC 0.70–0.85 controlled, 0.55–0.70 cross-model. Full files more detectable than snippets. (Feng et al., 2020)
7. **Import/dependency patterns** — AI suggests popular libraries more frequently; "textbook" choices.

For deeper technical background on detection mechanisms, see `references/detection_science.md`.

---

## Generation Strategies

### 1. Naming Naturalization

Mix styles naturally within a file:
- Abbreviated for common concepts: `req`, `res`, `ctx`, `cfg`, `opts`, `idx`, `cnt`
- Descriptive for domain-specific: `orderFulfillmentStatus`, `retryBackoffMs`
- Single-letter in tight scopes: `i`, `j`, `k` in loops; `e` for errors; `n` for counts
- Slightly unclear names that make sense in context: `prev`, `acc`, `buf`, `tmp`

Name things as a developer deep in the codebase would — not for a fresh reader. Use domain jargon: in a payment system, use `chargebackWindow`, `settlementBatch`, not `refundTimePeriod`.

Avoid: naming everything with full descriptive English (`arrayOfUserObjects`); perfect naming consistency within a file; avoiding all abbreviations; identical naming patterns for similar constructs.

### 2. Structural Diversity

- Vary function length: some 3-line utilities, some 40-line complex functions. Not everything 10–15 lines.
- Mix abstraction levels: well-abstracted pieces next to inline "wasn't worth extracting" code.
- Pragmatic shortcuts: early returns mixed with nested conditionals, slightly-too-complex ternaries, chained operations that could be broken up.
- Show evolution: well-structured section adjacent to slightly messier one (written/modified at different times).
- Vary indentation depth: some functions flat (early returns), others legitimately deep-nested.

Avoid: every function same shape (validate → process → return); uniform pattern application; over-abstracting into tiny single-purpose functions; uniform cyclomatic complexity.

### 3. Comment Authenticity

Comment the "why," not the "what":
- `// retry because upstream occasionally returns 503 during deploys`
- `// TODO(team): clean up when v2 API is stable`
- `// HACK: timezone offset workaround for Safari`
- `// per JIRA-1234` or `// see RFC 7231 §6.5.1`
- `// added 2024-03 after the incident`
- `// this is gross but it works`

Leave complex code uncommented (obvious to the developer). Use terse comments: `// edge case` not `// Handle the edge case where the user might not have a valid session`.

Avoid: commenting every line; formulaic docstrings on trivial functions (`/** Gets the user. @returns The user. */`); comments restating code (`// increment counter` above `counter++`); uniform comment density.

### 4. Error Handling Realism

Be inconsistent like real developers:
- Critical paths: thorough validation, specific error types, recovery logic
- Utility functions: minimal handling, maybe just throw/raise
- Scripts: `catch (e) { console.error(e); process.exit(1); }`
- Some optimistic code paths with no handling ("should never fail")

Mix styles within a file: try/catch here, result types there, early returns for validation. Use developer-context error messages: `"failed to parse config: check YAML indentation"` not `"An error occurred while processing the configuration file."`

Avoid: identical error handling everywhere; always using the "proper" pattern; formal English error messages; handling every possible error path.

### 5. Import/Dependency Choices

- Mix well-known libraries with niche-but-appropriate ones
- Include a utility that's slightly unconventional (developer picked it from experience, not top Google result)
- Order imports reflecting how they were added over time (not always perfectly alphabetical unless linter enforces it)
- Occasional unused/partially-used imports (debugging artifact)

Avoid: always choosing the most popular library; perfect import organization; only "textbook" dependencies.

### 6. Testing Patterns

- Vary thoroughness: comprehensive for critical logic, minimal for simple getters
- Slightly inconsistent naming: `test_user_creation`, `should_return_404_when_not_found`, `TestPaymentFlow`
- Edge case tests revealing debugging history: `it('handles the weird unicode name that broke prod')`
- Skip obvious tests "not worth it"
- Concrete, realistic test data: `"jane.doe@example.com"`, `"Acme Corp"` — not always `"foo"`, `"bar"`

Avoid: identical test structure for every method; perfectly generic test data; uniform assertion depth; full formal English test descriptions.

### 7. Code Evolution Artifacts

Include organic development signs:
- Deprecated function still present but marked
- Commented-out alternative approach
- Oddly-named constant (historical reason)
- Interface with one method that doesn't quite fit (added later for specific need)
- Stylistic drift: early code slightly different style than later additions
- Defensive checks hinting at past bugs: `if (!user) return; // shouldn't happen but did in prod`

Avoid: perfectly clean/consistent code; removing all traces of evolution; uniform style throughout.

---

## Developer Profile (infer from context or ask)

- **Junior**: verbose, over-commented, follows tutorials closely
- **Mid-level**: practical, some shortcuts, knows patterns but doesn't over-engineer
- **Senior**: concise, pragmatic, occasional clever solutions, fewer comments
- **Staff/Principal**: architectural, abstraction-heavy, assumes reader expertise

## Codebase Context (infer from context or ask)

- **Greenfield**: clean, consistent, modern patterns
- **Mature/Legacy**: mixed styles, compatibility concerns, historical artifacts
- **Startup/Move-fast**: pragmatic, tech debt, "good enough" solutions
- **Enterprise**: verbose, defensive, well-documented, follows team standards

## Language Idioms

Apply idiomatic patterns for the target language. Pythonic Python, idiomatic Go, modern JS/TS, Rust ownership idioms. Don't write "Java in Python" or "Python in Go."

---

## Self-Check Before Delivering

1. Variable names include a MIX of abbreviated and descriptive? (Not all one style)
2. Comments about "why" not "what"? Appropriately few of them?
3. Function length varies? (Not all 10–15 lines)
4. Error handling inconsistent in a realistic way?
5. Subtle signs of evolution? (TODO, slight inconsistencies, pragmatic choices)
6. Reads like ONE developer wrote it over time, not generated all at once?
7. Free of over-documentation? (No docstrings on trivial methods)
