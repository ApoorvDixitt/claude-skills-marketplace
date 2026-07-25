# Code Detection Science — Technical Reference

This file provides deeper context on why AI-generated code is detectable and the specific
mechanisms detectors use. Read this when you need to understand the technical basis for
the generation strategies in SKILL.md.

## Token-Level Perplexity in Code

Code has inherently lower entropy than natural language due to syntactic constraints.
At many token positions, both humans and AI must produce the same tokens (braces,
semicolons, keywords). This compresses the perplexity gap:

- **Prose**: AI perplexity 35–85, human 100–180 (ratio ~2x)
- **Code**: AI perplexity gap only 1.1x–1.4x vs. human code

The signal exists but is weak. Detection AUROC for token-perplexity methods on code:
0.60–0.75 (vs. 0.90+ for prose). Short snippets (<50 tokens) are undetectable.

**Source:** Su et al., "DetectLLM: Leveraging Log Rank Information for Zero-Shot
Detection of Machine-Generated Text," 2023 (arXiv:2306.05540)

## Why Short Code Is Undetectable

Statistical detection requires sufficient tokens to accumulate signal. For code:
- <50 tokens: AUROC ~0.50–0.55 (random chance)
- 50–200 tokens: AUROC ~0.60–0.70
- Full files (500+ tokens): AUROC ~0.75–0.90

This means individual functions and small utilities are safe; detection becomes
a concern at the file level and above.

## CodeBERT Embedding Classifiers

Fine-tuned CodeBERT (RoBERTa architecture, 125M params, trained on code-NL pairs
across 6 languages) can distinguish AI/human code via embedding space patterns.

What classifiers detect:
- Uniformity in token selection patterns across a file
- Lack of idiosyncratic developer fingerprints in naming
- Over-consistency in structural patterns (AST depth, nesting)
- Homogeneous comment density and style

**Performance:**
- In-distribution (known model): AUROC 0.70–0.85
- Cross-model (unseen generator): AUROC 0.55–0.70
- Short snippets: effectively random

**Source:** Feng et al., "CodeBERT: A Pre-Trained Model for Programming and Natural
Languages," EMNLP 2020 (arXiv:2002.08155)

## AST-Based Detection Signals

Beyond token statistics, structural analysis reveals:
- **Nesting depth uniformity**: AI produces more uniform AST depth distributions
- **Subtree repetition**: AI code reuses similar structural patterns more frequently
- **Control-flow regularity**: More uniform cyclomatic complexity across functions
- **Node-type distributions**: AI shows different ratios of if/else, loops, calls

Human code evolves organically — functions added at different times, by different
people, with different immediate goals. This creates natural structural irregularity.

## The Formatter Problem

Code formatters (Prettier, Black, gofmt, clang-format) normalize many potential
detection signals in whitespace and formatting. This helps AI code because it removes
one axis of detection — but it also means the remaining signals (naming, structure,
comments, error handling) become relatively more important for both detection and
evasion.

## Why Full Files Are More Detectable

Detection power increases with text length because:
1. More tokens = more statistical signal accumulates
2. File-level patterns emerge (import choices, overall architecture)
3. Consistency itself becomes a signal — real files have natural inconsistency
   from being written/modified across multiple sessions

The generation strategies in SKILL.md specifically target file-level signals by
introducing realistic inconsistency and evolution artifacts.

## Key Academic References

1. Su et al., 2023 — DetectLLM (arXiv:2306.05540): Zero-shot code detection via
   log-rank statistics
2. Feng et al., 2020 — CodeBERT (arXiv:2002.08155): Embedding-based classifiers
3. Sadasivan et al., 2023 — Detection limits (arXiv:2303.11156): Theoretical bounds
   on all detection methods, including code
4. Mitchell et al., 2023 — DetectGPT (arXiv:2301.11305): Perturbation-based detection
   and why code's low entropy weakens it
