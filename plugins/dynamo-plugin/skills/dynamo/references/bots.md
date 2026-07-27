
# The evaluation agents — bot behavior and counter-play

Every push to a task PR triggers a 10-stage pipeline with multiple intelligent gates.
This file covers the two PRIMARY agent-based gates you design against: the review/eval
bot (quality) and Model A (difficulty). For the full pipeline including AVA, Per-Check QC,
and Adversarial Cheat-Pass, see `ci-gate.md`. Everything below is observed behavior
(v1–v10 of cost-basis-reconcile + later projects, 2026-07), not speculation.

Note: The pipeline now also includes AVA (Adversarial Verifier Audit), Adversarial
Cheat-Pass (advisory), and Per-Check QC (Task Soundness) — all running between Pass@2
and Pass@5. See ci-gate.md §1D–1F for those gates.

## Bot 1 — the review/eval bot (quality gate)

Runs as the `review / review`, `similarity`, and `validation` jobs plus the
"Static checks" / "Dynamo eval" comments. Three layers:

1. **Deterministic static checks.** File inventory, digest-pinned base image,
   pinned pip deps, `.dockerignore` present, `artifacts` a top-level array
   matching real outputs, no `jobs/` or strays, no personal info. It greps
   docstrings/comments for tokens that look like undocumented outputs: v1 was
   blocked because a TEST docstring mentioned `solve.py` — it read that as an
   undisclosed artifact. Never name solution files anywhere agent-visible OR
   in tests.
2. **LLM rubric pass.** Checks instruction↔tests 1:1 both directions (the #1
   killer), explanation fields against the actual verifier, instruction
   clarity. CRITICAL precedent: it FAILED a push for containing the platform
   docs' mandated "You have N seconds…" suffix line — **this repo's rubric
   outranked the platform instructions for that specific repo.** When your repo's
   `.dynamo/dynamo-rubric.toml` and platform docs conflict, the repo rubric wins. But the
   CURRENT platform default requires the timeout suffix line — only omit if your specific
   repo's rubric explicitly forbids it. Always check `.dynamo/dynamo-rubric.toml`.
3. **Similarity/duplicate check** against the existing task corpus. Passing
   verdict: "UNIQUE".
4. **Validation job**: builds the image, runs oracle (expect 1.0) and nop
   (expect 0.0) itself. If local calibration passed, this passes.

**How to satisfy it:** one test per stated criterion, docstring naming the
criterion; explanations that describe the verifier you actually shipped
(it cross-reads them); no solution-filename tokens; oracle/nop calibrated
locally first; repo rubric over platform docs on any conflict.

## Bot 2 — "Model A", the pass@2/pass@5 difficulty agent

GPT-5.4 + Terminus-2 harness at xhigh reasoning, run on Daytona, budget =
`[agent].timeout_sec` (capped 3600s). The pipeline runs it twice (pass@2);
a task advances only if ≥1 run is a VALID failure (finished, wrong, fair).
Its per-run rubric: task_specification, reward_hacking, difficulty_crux,
near_miss, refusals, low_timeout, approach_validity — a failure only counts
if all of these PASS while the answer is wrong.

### Its invariant loop (observed in every trajectory)

1. Reads EVERY file in `/app` before acting (step 2 of every run).
2. Treats any provided reference output (statement, sample, log) as an
   **oracle to tie out against** — per line, per symbol, before submitting.
3. Implements the entire disclosed spec in one shot, typically flawlessly:
   `Decimal` arithmetic, clean general engine, handles every stated edge.
4. Where behavior is under-determined, it forms hypotheses BEFORE coding —
   in v9 both runs derived Hamilton largest-remainder apportionment
   *hypothesis-first* from a single statement figure ("identified the
   allocation convention in step 3 by explicit reasoning"), then verified.
5. On any mismatch it enumerates rival hypotheses from NAMED families
   (chronological/recency/size orderings, standard apportionment schemes,
   standard roundings) and iterates until the oracle ties out.
6. Finishes in 17–31 minutes of a 60-minute budget. It does not time out,
   does not refuse, does not reward-hack (rubric-confirmed every round).

### What it provably defeats (do NOT bet on these)

- Scale/tedium (writes generators, loops).
- Held-out generalization per se (its engines are genuinely general).
- ANY single latent convention that is a pick from a named family — it
  recovered "most-recent-first" (v5–v8) and "Hamilton, tie-to-earlier" (v9)
  from statement data, twice each, independently.
- Multi-mechanism composition of disclosed rules (v1–v4).
- Obscure-but-documented domain rules (it knows tax law cold — Treas. Reg.
  §1.1091-1 phrasing appeared in its reasoning).

### Where it is weakest — REVISED after v10 (2026-07-11)

v10 tested the "entangled unnamed conventions + misleading priors" bet at
full strength: an unnamed cascade allocator, a 42-day window against the
statutory-30 prior, a short-term RoC convention, one deliberately ambiguous
calibration symbol — all three recovered by BOTH runs in 24–28 minutes via
explicit first-principles reasoning. Conclusion, now proven across v1–v10:

**If a latent behavior is uniquely recoverable from data the agent holds —
which fairness REQUIRES — this model recovers it.** Its loop (implement →
tie out per line → hypothesize → verify) is exactly the task author's own
fairness-probe algorithm. In any deterministic, self-checkable domain where
a calibration artifact must exist, convention-recovery designs CANNOT stump
it, no matter how ad-hoc, entangled, or prior-defying the conventions are.
Complexity did not even slow it down (17–31 min across v5–v10).

The only seam with corpus-proven 5/5 failure remains **reconstruction with
no incremental feedback signal**: a search space too large to enumerate AND
no per-case tie-out to descend on (legacy-formatter-clone's custom checksum
— every hypothesis is all-or-nothing wrong with no gradient). That shape is
hard to reach fairly in a figures-reconciliation task (byte-exact output
demands are themselves a flagged verifier defect) — it generally requires a
different task architecture, not a harder convention.

**Operational consequence**: once a well-built task of this architecture is
blocked 2+ times at pass@2 with rubric-perfect solves, further hardening is
negative-EV. The correct move is the human escalation (below), not v11.

### Fairness constraints (or the failure won't count)

- Every latent behavior must be pinned uniquely by data the agent holds;
  build variant engines for every rival reading and prove each contradicts
  the calibration data AND fails the graded data (probe matrix).
- Extensionally equivalent readings must stay equivalent on ALL data
  (generator asserts), or the task grades a distinction that was never
  pinned → invalid failure.
- The instruction must flag that unstated conventions exist and where the
  evidence lives (umbrella clause), without naming the dials.
- No timeouts as difficulty; full 3600s budget; failures must be wrong
  answers.

### Process facts

- pass@2 runs on every push; each push cancels a running eval and consumes
  a slot (~6/day/fellow). Wait for a running pipeline before reacting.
- The reviewer guide treats pass@2 as a COST gate; 0–2/5 solves at pass@5
  is acceptable "regardless of pass@2" — if a well-built task keeps getting
  2/2-solved, the correct move is a human escalation in Slack
  (#project-dynamo), not infinite hardening.
- The pass@2 verdict comment contains a full per-trial trajectory analysis
  (approach, per-figure values, timing). ALWAYS mine it before redesigning:
  it tells you exactly which seam the agent used.
