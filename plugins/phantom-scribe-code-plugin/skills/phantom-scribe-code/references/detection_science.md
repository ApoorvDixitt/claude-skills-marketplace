# Code Detection Science — Technical Reference

Read this file when you need deeper understanding of WHY specific generation strategies
work against specific detector types. The strategies in SKILL.md are derived directly
from this research.

## Table of Contents
1. Token-Level Perplexity in Code
2. Classifier-Based Detection (CodeBERT)
3. AST/Structural Pattern Analysis
4. Full-File Detection
5. Cross-Model Generalization
6. The Formatter Effect
7. Comparative Signal Strength
8. Theoretical Detection Bounds
9. Key Academic References

---

## 1. Token-Level Perplexity in Code

### The Low-Entropy Problem

Code has inherently lower entropy than natural language due to syntactic constraints.
At many positions, the legal token set is severely restricted — after `for (int i = 0; i <`,
the next token must be a variable or literal. Both humans and AI produce high-probability
tokens at these positions.

**Empirical consequences:**
- Prose perplexity gap: AI 35–85, Human 100–180 (ratio ~1.8x–2.4x)
- Code perplexity gap: ratio only 1.1x–1.4x
- Perplexity-based detector AUROC: >0.95 on prose, drops to 0.60–0.75 on code
- Short snippets (<50 tokens): AUROC ~0.50–0.55 (random chance)

### DetectLLM Applied to Code (Su et al., 2023)

The log-rank ratio (LRR) and normalized perturbed rank (NPR) methods provide SOME
signal on code, but with significantly reduced discrimination. Additional challenge:
perturbing code tokens often produces syntactically invalid variants, making the
perturbation distribution q(·|x) harder to define meaningfully.

### What This Means for Generation

The residual perplexity signal comes from AI code being "uniformly moderate" — always
selecting reasonable tokens without the spikes (creative/unusual choices) and valleys
(highly predictable boilerplate stretches) that human code exhibits.

**Strategy implication:** At decision points where multiple valid tokens exist (variable
names, method choices, approach selection), deliberately introduce variance. Some choices
should be surprising-but-valid (high perplexity), some should be standard (low perplexity).
The variance pattern, not the average, distinguishes human from AI.

---

## 2. Classifier-Based Detection (CodeBERT)

### Architecture

CodeBERT (Feng et al., 2020; arXiv:2002.08155): RoBERTa architecture, pre-trained on
code-natural language pairs across 6 programming languages. Fine-tuned with binary
classification head on labeled human/AI code datasets.

### What Classifiers Actually Detect

The classifier learns complex nonlinear combinations in embedding space. Research
suggests these resolve to:

1. **Average developer style** — AI code lacks individual idiosyncrasies. It reads as
   "generic competent developer" rather than a specific person with habits and preferences.

2. **Comment pattern regularity** — AI generates comments that are either over-explanatory
   or formulaic. Real developers have irregular comment patterns reflecting priority and
   context.

3. **Error handling uniformity** — AI applies the same error handling pattern everywhere.
   Real developers are thorough on critical paths and lazy on utilities.

4. **Naming conventionality** — AI gravitates toward descriptive-but-common names from
   training data patterns (`result`, `data`, `index`, `item`, `response`, `handler`).
   Real developers use project-specific terminology, abbreviations, and contextual names.

### Performance Boundaries

| Scenario | AUROC |
|----------|-------|
| In-distribution (known model, controlled) | 0.70–0.85 |
| Cross-model (trained GPT-3.5, tested GPT-4) | 0.55–0.70 |
| Short snippets (<100 tokens) | 0.50–0.55 |
| Full files (500+ tokens) | 0.75–0.90 |

**Critical finding:** Cross-model generalization is POOR. Detectors trained on one
model's output fail on other models. This means each model has a distinct code style
that classifiers overfit to — but also means a consistent generation fingerprint could
eventually be trained against.

---

## 3. AST/Structural Pattern Analysis

### What Gets Detected

Beyond token-level statistics, structural analysis reveals:

- **AST depth distributions**: AI produces more UNIFORM nesting depth across functions.
  Human code has high variance — some functions flat, some deeply nested.

- **Subtree repetition**: AI code reuses similar structural patterns (sub-trees) more
  frequently within a single file. If you need 5 similar handlers, AI tends to generate
  them with nearly identical structure. Humans drift.

- **Control-flow graph complexity**: More uniform cyclomatic complexity across functions.
  Real codebases have a mix — simple getters and complex business logic in the same file.

- **Node-type frequency distributions**: AI shows different ratios of if/else, loops,
  function calls, and assignments compared to human code at the file level.

### Why Human Code Has Structural Irregularity

Human code evolves organically:
- Functions added at different times with different immediate goals
- Different team members with different abstraction preferences
- Requirements changes that modified some functions but not others
- Refactoring that touched some areas but not others
- Copy-paste-modify that created subtle structural differences

This creates natural structural irregularity that AI code lacks unless explicitly
introduced.

### Strategy Implication

For similar operations within a file, deliberately vary the structural approach:
- First handler: early returns with guard clauses
- Second handler: nested if/else with a default case
- Third handler: switch/match statement
- Fourth handler: try/catch with specific error types

This mirrors how real code evolves as different approaches are tried at different times.

---

## 4. Full-File Detection

### Why Files Are More Detectable Than Snippets

Full-file detection achieves AUROC 0.75–0.90 because:

1. **Statistical accumulation** — more tokens means more signal
2. **File-level patterns emerge** — import choices, overall architecture, dependency
   selection become visible
3. **Consistency itself is a signal** — real files have natural inconsistency from being
   written/modified across multiple sessions and priorities

### What File-Level Detectors Look For

- **Import organization**: Perfectly grouped and alphabetized suggests automation
- **Function ordering**: Textbook top-down or bottom-up ordering throughout
- **Style consistency**: Perfect uniformity suggests single-pass generation
- **Architecture choices**: "Textbook" architectural decisions vs. pragmatic ones
- **Dependency selection**: Always choosing the most popular library for every need

### Strategy Implication

Introduce file-level irregularity:
- Imports reflecting when things were added (slightly out of order)
- Functions ordered by logical proximity to callers, not alphabetically
- Varying quality between sections (some polished, some rougher)
- At least one "pragmatic shortcut" that breaks the overall pattern
- Mix of approaches for similar problems within the same file

---

## 5. Cross-Model Generalization

### Current State

Classifiers trained on GPT-3.5 code FAIL on GPT-4/Claude/Gemini-generated code.
Different models produce code with varying stylistic signatures:

- Model updates invalidate previously trained classifiers
- Each architecture has subtle preferences in token selection
- RLHF/RLAIF fine-tuning creates model-family specific patterns

### Implication for This Skill

While current cross-model failure is beneficial (detectors can't generalize well),
the skill should proactively prevent developing a consistent fingerprint that future
detectors could train against:

- Vary approaches between invocations based on specified persona
- Don't use the same structural templates repeatedly
- Adapt to project-specific conventions rather than using a fixed "style"
- Introduce enough variance that no consistent pattern emerges across sessions

---

## 6. The Formatter Effect

### What Formatters Normalize

Code formatters (Prettier, Black, gofmt, clang-format) erase:
- Whitespace and indentation variations
- Brace placement differences
- Line length and wrapping decisions
- Blank line grouping
- Trailing commas/semicolons

### What Formatters DON'T Normalize

The remaining signals that detectors can still exploit:
- **Naming choices** — formatters don't rename variables
- **Architectural decisions** — what to abstract, what to inline
- **Algorithm selection** — which approach to use
- **Comment content and placement** — formatters preserve comments
- **Import selection** — which libraries to use
- **Error handling approach** — how to handle failures
- **Control flow choices** — if/else vs. switch vs. early return

### Strategy Implication

Focus humanization effort on dimensions formatters cannot erase. The naming,
architecture, comments, and error handling sections of the generation strategies
are the PRIMARY defense against detection in formatted codebases. Style-level
signals (indentation, spacing) are secondary — they get normalized anyway.

---

## 7. Comparative Signal Strength

| Signal Type | NL Stylometry (prose) | Code Structural Analysis |
|-------------|----------------------|--------------------------|
| Vocabulary diversity | TTR, hapax rate (strong) | Identifier diversity (weak — formatters normalize) |
| Structural regularity | Sentence length variance | AST depth variance, nesting patterns |
| Formulaic patterns | Transition phrases | Boilerplate patterns (weak — both sources similar) |
| Authorship fingerprint | Function-word ratios | Naming conventions, comment style |
| Signal strength | AUROC 0.70–0.85 | AUROC 0.55–0.75 |
| Robustness to gaming | Moderate | Very low (formatters + linters eliminate signals) |

**Key insight:** Code detection is fundamentally weaker than text detection because
programming languages constrain the output space. The skill's strategies target the
few remaining signals that DO distinguish human from AI code.

---

## 8. Theoretical Detection Bounds

### The Total Variation Bound (Sadasivan et al., 2023)

The theoretical maximum for any detector:

    AUROC(best detector) <= 1/2 + TV(P_human, P_AI) / 2

As AI code quality improves, TV(P_human, P_AI) shrinks, and detection approaches
random chance. For code, this convergence is FASTER than for prose because the
constrained output space means distributions are already more similar.

### Practical Assessment (2024–2025)

Current realistic detection capability on code:
- **Snippet level (most common — Copilot completions)**: NOT reliably detectable
- **Function level**: Marginally detectable with high false-positive rates
- **File level**: Detectable (AUROC 0.75–0.90) but with significant error rates
- **Multi-file level**: Architecture and design patterns provide strongest signal

The increasing prevalence of human-AI collaborative coding (human writes some, AI fills
in portions) makes binary classification fundamentally ill-posed for most real code.

---

## 9. Key Academic References

### Primary (Code-Specific)

1. **Feng et al., 2020** — "CodeBERT: A Pre-Trained Model for Programming and Natural
   Languages." EMNLP 2020 Findings. arXiv:2002.08155.
   - Establishes embedding-based code classification baseline
   - RoBERTa architecture trained on 6 languages
   - Foundation for classifier-based code detection

2. **Su et al., 2023** — "DetectLLM: Leveraging Log Rank Information for Zero-Shot
   Detection of Machine-Generated Text." arXiv:2306.05540.
   - Log-rank ratio (LRR) and normalized perturbed rank (NPR) methods
   - Documents reduced effectiveness on code vs. prose
   - Shows perturbation approaches struggle with syntactic validity

### Cross-Modal (Applicable Principles)

3. **Mitchell et al., 2023** — "DetectGPT: Zero-Shot Machine-Generated Text Detection
   using Probability Curvature." ICML 2023. arXiv:2301.11305.
   - Perturbation-discrepancy statistic for detection
   - Local maxima in log-probability landscape
   - Weakened on code due to low entropy

4. **Sadasivan et al., 2023** — "Can AI-Generated Text be Reliably Detected?" TMLR.
   arXiv:2303.11156.
   - Theoretical bounds on all detection methods
   - TV distance bound on maximum AUROC
   - Recursive paraphrasing attacks reduce detectors to near-random
   - Applies to code with even stronger bound (lower TV distance)

5. **Li et al., 2024** — "MAGE: Machine-generated Text Detection in the Wild." ACL 2024.
   arXiv:2305.13242.
   - Real-world evaluation across domains including code
   - Best detector identifies 86.54% out-of-domain text from unseen LLMs
   - Performance significantly lower on code than prose

6. **Hans et al., 2024** — "Binoculars: Zero-Shot Detection of Machine-Generated Text."
   ICML 2024. arXiv:2401.12070.
   - Dual-model perplexity ratio method
   - >90% detection at 0.01% FPR on prose
   - Reduced effectiveness on low-entropy domains (code)
