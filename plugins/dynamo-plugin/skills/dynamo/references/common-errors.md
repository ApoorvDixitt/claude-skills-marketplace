# Common errors and the self-check — why tasks get rejected

Extracted from the Project Dynamo platform (June 2026 update). The full worked examples
with code excerpts are in `official-guide.md` §"Common errors and examples". This file is
the quick-reference for self-review before pushing.

---

## The five rejection reasons (about half of all rejections are #1)

| # | Reason | What it is | How to avoid |
|---|---|---|---|
| 1 | **Grading on a rule you never told the agent** | Verifier checks a format, ordering, tie-break, or convention that `instruction.md` never mentions. | Write down EVERY rule the verifier checks. If only your exact choice passes and you never stated it, disclose it. |
| 2 | **Task files contradict your instructions** | A data file, config, or reference solution follows a different rule than the instruction states. | Make shipped data and solution obey the instruction exactly. Regenerate fixtures if they drift. |
| 3 | **Instructions that read two ways** | A term has two defensible readings; verifier silently accepts only one. | Name the single canonical rule. Then check: once it's unambiguous, is the task still hard? |
| 4 | **The only hard part is a mistake** | The single failing element is one unstated or broken rule. Fix it honestly and the task is trivial. | Build difficulty into genuine reasoning that survives full disclosure. |
| 5 | **Decoys with no way out** | Task points at the wrong answer with nothing the agent can use to correct it. | Misdirection is allowed ONLY if the task itself can set the record straight. |

**The test:** If writing the deciding rule down plainly makes the task easy, the difficulty
was fake. A good task stays hard even when every rule is clearly stated.

---

## Before you submit: 5-item self-check

1. **Every rule the verifier checks is stated in the instruction** — no undisclosed conventions.
2. **Your task files don't contradict your instructions** — regenerate if they drifted.
3. **The instruction reads only one way** — name the canonical interpretation if ambiguous.
4. **The task stays hard once every rule is explicit** — if not, you need a real difficulty source.
5. **Any misdirection has a correction path** — something concrete leads to the right answer.

---

## Where pass@2 flags these now

The pass@2 analysis in GitHub Actions calls out when failures look unfair. The flag shows up
in your PR comments. Read it before pushing further.

**Red flags in your own testing:**
- Failing tests are about file existence or output formatting → usually undisclosed convention
- The oracle passes but a slightly different valid implementation fails → too strict / undisclosed
- Every failing agent makes the same "mistake" → check if the instruction led them there

---

## The fairness gut-check (use on every trap)

Would a human expert, seeing only what the model sees:
1. Get it right? (YES required)
2. Call the failure fair? (YES required)

Both yes = legitimate stump. Either no = cut or fix.

---

## Full worked examples

See `official-guide.md` §"Common errors and examples" for the worked case studies with code
excerpts. Its subsections, in order: "Common pitfalls, grouped by requirement area",
"Flags & Fixes", "Pass AVA", "Before you submit", "Audit the requirements", "Don't expose the
answer", "Your docs must be true of the data", and "The rules were wrong, and the checker was
blind".
