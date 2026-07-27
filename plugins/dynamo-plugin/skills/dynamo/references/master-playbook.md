# Dynamo Master Playbook — land a task in ≤5 commits

> **Table of Contents:** §0 The one thesis · §1 Why commits dropped · §2 The winning mechanism ·
> §3 Decision tree · §4 Two mechanisms in detail · §5 What NEVER works · §6 Domain selection ·
> §7 Fairness invariant · §8 Build+prove sequence · §9 Proof stack · §10 Reusable code assets ·
> §11 Per-project ledger · §12 Gate mechanics · §13 The ≤5-commit checklist

The cross-project synthesis. Four tasks in, the commit count fell from ~20 to under 5.
This file is why, and how to repeat it. Read it first on any new Dynamo task, pick the
mechanism BEFORE building, then follow the build+prove sequence. Deep detail lives in the
sibling references (`hard-task-craft.md`, `ci-gate.md`, `bots.md`, `verifier-hardening.md`,
`task-build.md`); this is the top-level map that keeps you from re-exploring dead ends.

---

## 0. The one thesis (the whole game in a paragraph)

A frontier model is superhuman at **guess → check → correct**: give it any hidden rule it
can verify a partial guess against, and it recovers the rule, however exotic, usually in
minutes. Fairness FORCES the answer to be recoverable from data the agent holds — which is
exactly the model's strength — so "hide a weird rule" designs always get solved. The only
durable seam is to **take away the model's verification method**, two ways:
- **(A) Remove the gradient** — evidence the agent cannot decompose, so a wrong guess shows
  only as an aggregate mismatch with nothing isolating which dial is wrong.
- **(B) The garden path** — the naive reading self-verifies as *complete* on everything the
  agent can see, and is wrong only on held-out data pinned by an in-data anchor.
Both keep the answer uniquely determined (you prove that separately). Everything below is
how to choose between them, build to them, and prove it before spending a CI push.

---

## 1. Why the commit count dropped (the actual time-saver)

| Task | Mechanism | Commits to accept | What ate the commits |
|---|---|---|---|
| cost-basis-reconcile | (A) remove the gradient | ~11 versions / ~20 pushes | Ten rounds of "make the rule weirder" — all solved — before removing the gradient |
| restore-archive (color) | (B) silent decoy (toe curve) | long pivot chain | Explored color×2, glyph, debug, codec, finisher before the inversion |
| fix-transfer-pipeline (video) | (B) debug garden path | **~4 pushes, gate cleared on the last** | v1 curve solved, v2 chroma solved (reconstruction genre), then the garden path landed 0/5 |

The lesson is not "try harder." It is **move the iteration off CI and onto a local proof
stack.** In the slow projects, every CI push was a probe ("is it hard enough?"). In the fast
one, a local `prove.py` (12 gates) + an anti-cheat battery run *through the real harbor
verifier* (8/8) answered every question a push would have, so the push only CONFIRMED. CI is
slow (~2.5 h), slot-limited (~6/day), and cancels on re-push. Your laptop is free and
instant. **Anything you can learn locally, learn locally.** That single discipline is the
difference between 20 commits and 4.

Second saver: **pick the mechanism and the domain right the first time.** The category locks
when you claim, and reconstruction-from-a-report is a walled genre (section 5). Choosing the
garden path in an exact-math domain up front skips the entire "why did it solve again" loop.

---

## 2. The winning mechanism, stated precisely (default to this)

**The garden path (B).** Build a deterministic pipeline (or reconstruction) where:
1. The naive/obvious reading reproduces **100% of everything the agent can self-check** —
   every visible sample, every printed statistic, every reference frame — to the last bit.
   This is the *stop-and-ship lure*: the agent validates, sees green, and commits.
2. The true behavior differs from the naive one **only in a regime the visible data never
   enters**, and that difference is decided by an **in-data anchor** the agent could have
   read but had no reason to (a black leader frame; a SHA-256; a single above-knee highlight).
3. Grading happens on **held-out** data that DOES enter that regime, pixel/value-exact,
   all-or-nothing.

Result: a completed, confident, self-verified agent run is **wrong** — a clean valid failure,
the only outcome the gate rewards. Proven twice:
- **restore-archive:** naive pure-power decode reproduces every pooled statistic; the real
  wide-gamut toe curve differs only where content bends, caught only by the SHA-256.
- **fix-transfer-pipeline:** `LUMA_BLACK=16` (textbook) vs the unit's true `19`; on sub-knee
  sample content the bug is a uniform +4-code cast that an `OUT_TRIM=-4` patch cancels
  pixel-exact and self-verifies clean; it breaks only on held-out above-knee content where
  the tone curve is nonlinear. The black reel leaders (coded 19, rendered to 0) are the
  in-data anchor that pins the true fix.

**Why it beats reconstruction-from-a-report:** in reconstruction the agent KNOWS it must match
the report/SHA and keeps searching until it does — so any fair (derivable) crux gets found.
The garden path gives the agent a **clean, visible-perfect place to stop before it finds the
crux.** The trap is not a rule it can't derive; it's a reason to stop deriving.

---

## 3. Decision tree — choose BEFORE writing any code

```
Is the domain exact-math + deterministic + fast to evaluate?  (finance, imaging,
video, rendering, feature transforms, scientific numerics, codecs)
│
├─ NO  → wrong domain for this method. Refuse ML-training/distributed/tuning
│        (nondeterministic, compute-bound → timeouts = INVALID failures),
│        crypto (named-gotcha + unfair/brute), config/build (solves or ambiguous).
│
└─ YES → Can a NAIVE reading self-verify as COMPLETE on all visible data,
         while the TRUTH differs only on an unshown regime?
         │
         ├─ YES → MECHANISM B: garden path / silent decoy.  ← DEFAULT
         │        Framing: "fix this pipeline" (debug) or "reproduce this legacy
         │        engine's output." Hide the defect in a stage the agent thinks the
         │        spec SETTLED, not in a disclosed unknown.
         │
         └─ NO, but the evidence can be collapsed to a few AGGREGATES that still
            uniquely pin several coupled dials →
                  MECHANISM A: remove the gradient. Force whole-engine reconstruction
                  against aggregate-only evidence; several entangled dials; per-hypothesis
                  evaluation must be EXPENSIVE (else the agent brute-forces the joint
                  space cheaply — proven: cheap eval + aggregate-only = solved in seconds).
```

The "named-gotcha" veto (apply to any candidate): if a senior engineer could name your trap
from the proposal ("that's premultiplied-alpha", "that's NFC/NFKC", "biased-nonce ECDSA"),
the model names it too and applies the textbook fix. The trap must live in nameless
arithmetic the agent reconstructs, never in a catalog convention.

---

## 4. The two mechanisms in detail

### (A) Remove the feedback gradient — for reconstruction against aggregate evidence
- Collapse per-item evidence to a handful of aggregate totals that STILL uniquely pin every
  dial (prove uniqueness by cross-product, section 9). cost-basis went from 7 per-symbol
  statement lines to 4 account totals + 4 coupled dials → ~2,904-combination joint space with
  no per-dial feedback.
- **Only works when per-hypothesis evaluation is expensive.** cost-basis: each trial =
  reconstruct a 150-row financial engine (seconds × thousands = infeasible in budget). Image/
  video decode is microseconds → the same aggregate-only design is brute-forced in seconds
  (confirmed empirically). Do NOT use (A) in a fast-eval domain.

### (B) Garden path / silent decoy — the general default
- **The naive reading must run clean and look right** on everything self-checkable. Nothing
  throws. The agent's only tell would be data it doesn't have.
- **The crux lives in a "settled" stage.** Agents re-search disclosed unknowns forever; they
  do not re-question the stage they think the spec fixed. Put the defect there (the black
  level "everyone knows is 16"; the gamma label that "means" pure power).
- **The docs must be SILENT on the deciding dimension — the decisive facts may exist
  ONLY in the data.** Proven the hard way on rebuild-ope-engine: v1 stated the crux as a
  rule → solved 2/2 in 16 min (the agent implements any disclosed rule flawlessly). v2
  reworded it *descriptively* but kept the facts co-located in one paragraph ("units count
  at their provisioned rate (default 50); calibration runs record the actual rate — at
  join and after service") → solved 2/2 in 11 min; the agents assembled the mechanism
  straight from the paragraph. **Descriptive vs prescriptive is irrelevant; co-located
  facts ARE an instruction.** What matches every actual win: video's LUMA 19 appeared in
  NO document (only in the black leaders); task 5's scope pin was a possessive in a field
  description. v3 shape: one minimal possessive sentence for fairness ("the engine
  converts at the unit's measured rate"), and the entire calibration history — who, when,
  what changed — lives only in the logs, where nothing prompts the enumeration that would
  reveal it. Corollaries: layer the traps so the winners of layer 1 die on layer 2 (their
  learned code shape, a worker→scale dict, cannot represent mid-window recalibrations);
  let the lure be DATA-taught (every pilot-era calibration reads exactly 50), because a
  value the agent derives itself is trusted more deeply than one a doc asserts.
- **Prior-defying, non-catalog, in the target domain.** The value the agent reflexively writes
  must be the wrong one, and the right one must not be a named option it enumerates. (Video
  curve and interlaced chroma were CATALOG for video → generated → solved. The ProPhoto toe
  was non-catalog for the "gamma 1.8" IMAGE label → not generated → shipped wrong.)
- **A nonlinear/regime boundary is the hiding place.** A tone-curve knee, a clip, a gamut
  edge, a saturation limit: linear below it (defect looks like a cancellable constant),
  nonlinear above it (the constant no longer cancels). Keep samples entirely on one side,
  held-out on the other.
- **An in-data anchor makes it FAIR.** There must be something the agent holds that pins the
  truth (the leader frame; the SHA; two exact renders). Fairness = a domain expert recovers it;
  difficulty = the agent has no reason to look before it stops.

---

## 5. What NEVER works — do not re-explore (each cost real commits)

- **Catalog conventions** — any named-family rule (orderings, standard matrices/curves,
  apportionments, roundings, alpha modes). The model recovers them hypothesis-first.
- **Reconstruction-from-a-report in a FAST-eval domain** — fair crux is derivable → the agent
  grid-searches + verifies against the report/SHA → solved. Walled for video (proven 2×) and
  any cheap-eval imaging.
- **Scale / tedium / long-horizon-for-its-own-sake** — makes the agent SLOW, not wrong.
  Timeouts are INVALID failures that bounce the task. The gate discounts timeouts; external
  benchmarks count them — do not confuse the two.
- **Held-out generalization alone** — the model's engines are genuinely general. (Keep
  held-out anyway; it defeats hardcoders for the anti-cheat gate.)
- **Obscure-but-documented knowledge, rare languages** — all defeated.
- **Obfuscation / "confusing English" / ambiguity as difficulty** — invalid failures +
  breaks the human-authorship attestation + rejection. Difficulty lives in arithmetic the
  agent reconstructs, never in prose it can misread. Refuse this however it is reworded.

---

## 6. Domain selection (the category locks on claim — choose for the method)

**Best fit (exact-math, deterministic, pixel/value-exact, fast, garden-path-friendly):**
imaging, video, rendering/graphics, finance/quant, feature engineering (as a deterministic
transform, NOT model training), scientific numerics, custom codecs.

**Refuse or avoid:** model training / distributed training / hyperparameter tuning
(nondeterministic, GPU, timeouts = invalid); cryptanalysis/security (named-gotcha, unfair or
brute); build/release config (solves or ambiguous); pure file search/rename (agent
self-verifies against the visible tree; the only hard cruxes are Unicode/collation named
gotchas or undisclosed tie-breaks = top rejection buckets).

Rank a new claim by: can I build an exact-math pipeline with a regime boundary + an in-data
anchor here? If yes, it's a garden-path candidate and my machinery ports.

---

## 7. The fairness invariant (or the failure doesn't count)

A failure counts ONLY if the model **FINISHED and was WRONG on a fair prompt.** The reviewer's
standard: a failure is valid only if you can point to something concrete — a sentence in the
instruction, a fact in the inputs — proving the agent's decision was wrong. If an expert could
DEFEND the agent's choice from what it saw, it's ambiguous → invalid → rejected.

The garden path passes this because the in-data anchor is concrete and agent-accessible (the
video verdict said so verbatim: the leader bytes + metadata + reference frames + the visible
tone curve were "a complete root-cause trail that was agent-accessible"). Two gut-checks, both
must be yes: would an expert seeing only what the model sees (a) get it right, and (b) call the
failure fair? Design for the specific outcome "finished-and-wrong," never "slow" or "confused."

---

## 8. The build+prove sequence that lands in ≤5 commits

Front-load everything the gate checks so push #1 is already green. Build order:
1. `solution/solve.sh` → thin wrapper; writes `/app/...`; genuinely computes; zero installs.
2. `environment/Dockerfile` → approved base pinned by `@sha256`; pinned pip
   (`pytest==8.4.1 pytest-json-ctrf==0.3.5` + task libs); `mkdir -p /app`; COPY seed inputs
   ONLY (never solution/ or tests/); `.dockerignore`.
3. `tests/test_outputs.py` + `test.sh` → one test per instruction criterion, docstring names
   it; expected values hardcoded from the fixed seed; goldens loaded to memory then DELETED
   from disk before any agent code runs; isolated single-input dir per run; bounded subprocess;
   reward written LAST from pytest exit; always `exit 0`.
4. `instruction.md` → prompt-style; absolute paths; every output file + schema; "what" not
   "how"; example values ≠ the answer; no trap name; ends with the required "You have N
   seconds..." line (N == `[agent].timeout_sec`, enforced by `check-instruction-suffix`).
5. `task.toml` → `artifacts` a top-level array of real outputs; pre-seeded
   category/subcategory/model/agent UNTOUCHED; `task_objective`/`artifact_type` best-fit;
   explanations that describe the verifier you actually shipped (the bot cross-reads them; put
   data provenance = synthetic + named practitioner audience in `difficulty_explanation`).
6. `README.md` (task + repo root) → describe the CURRENT task; audit the WHOLE repo for stale
   terms from earlier iterations before every push.

Then run the full proof stack (section 9) locally. Push only when all of it is green.

---

## 9. The proof stack — prove it, never guess (all green on the EXACT shipped state)

Compute every graded number ≥2 independent ways that must agree (hand / analytic generator /
reference engine). Then, in order:
1. **Uniqueness (cross-product):** build a variant for every plausible reading of every latent
   dial; take the full cross-product; EXACTLY ONE combination reproduces the visible evidence,
   AND every single-dial deviation also fails the graded data. Two matches → ambiguous → add a
   discriminator and re-probe. (This is the fairness proof.)
2. **Garden-path proof (mechanism B):** the naive fix reproduces every visible sample
   byte-exact (the lure), AND fails every held-out clip substantially; no OTHER single knob
   reaches sample-exact; the in-data anchor uniquely pins the truth; rounding margin ≫ FP noise
   so cross-version determinism holds.
3. **Wrong-solution proof:** inject the one-line naive bug → reward 0, failing held-out while
   visible still passes (proves the trap is graded and silent). Revert → byte-identical.
4. **Anti-cheat battery THROUGH the real harbor verifier** (copy the task, swap the delivered
   artifact, run oracle): reward-hijack, glob/overlay scan, sibling read, hardcoded-path,
   timeout stall, empty output — every one scores 0; oracle 1.0; leak scan of the BUILT image
   clean (`/app` seed-only, no solution/tests/golden).
5. **Calibrate:** `harbor run -a oracle` → 1.0, `--agent nop` → 0.0, repeatable, twice.
6. **Hygiene:** LF blobs (`git ls-files --eol`); task.toml parses + field rules; instruction↔
   tests 1:1 both ways; no answer or solution-filename token anywhere agent-visible; no personal
   info; full-repo audit (every tracked file, root README, PR title/body) vs the current task.

All green → you are not guessing. This is what collapses the CI iteration to one push.

---

## 10. Reusable code assets (port these, don't rewrite)

The `scratch-vt3/` stack is the template (kept outside the repo; never committed):
- `engine.py` — a TEMPLATE string that emits the shipped pipeline with tokens for the
  defect/decoy variants, PLUS an INDEPENDENT re-implementation (different code path) to
  crosscheck byte-for-byte. Parameterized so a "knob audit" can sweep every constant.
- `gen.py` — synthesizes samples + held-out with structural asserts (regime coverage, margins,
  anchor placement) and renders references through the ACTUAL shipped file.
- `prove.py` — the section-9 gates as a scorecard that must print ALL GREEN.
- `battery.py` — copies the task to a temp dir, swaps in each exploit as the delivered
  artifact, runs the REAL harbor verifier, asserts reward 0.
- `build_data.py` — emits final data into the repo and re-verifies the trap on repo paths.

Environment: harbor installed via `uv tool install harbor` (in `~/.local/bin` on macOS/Linux,
`C:/Users/<username>/.local/bin` on Windows). On Windows Git Bash: `export MSYS_NO_PATHCONV=1`
before any `docker run ... /bin/bash`. Confirm `docker info` first (a down daemon makes harbor
silently produce no jobs). Push to the FORK remote (origin is pull-only, 403). Never push while
an eval runs (cancels it, burns a slot).

---

## 11. Per-project ledger (what each one taught)

- **log-report (assessment):** format-repair only. Taught the file-format rules: `artifacts`
  array, digest-pinned base, no leaked solution in the image, reward to `/logs/verifier/`,
  real-value asserts, exact instruction schema.
- **cost-basis-reconcile (accepted):** convention-recovery cannot stump the model (10 straight
  2/2 solves across orderings, apportionments, windows, classifications). The win was
  MECHANISM A — remove the gradient — and it only worked because per-hypothesis reconstruction
  was expensive. Taught the cross-product uniqueness proof and double-derivation discipline.
- **restore-archive (accepted, pass@5 0/5):** the first garden path — MECHANISM B via the
  ProPhoto toe inversion. Taught: entangle the trap in a stage the agent thinks is settled;
  non-catalog for the label; the SHA as the fair in-data anchor. Also taught the deep_review
  lottery (harden the whole class, not the named instance) and the full-repo audit rule (a
  stale README cost a commit).
- **fix-transfer-pipeline (accepted, pass@5 0/5, one push):** reconstruction is walled for
  video (curve + chroma both catalog, solved 2×). The debug garden path landed immediately.
  Taught the sharpest lesson: **the naive fix must self-verify as COMPLETE on visible data**
  (a clean stop) — that is what reconstruction lacks and what makes the model ship wrong. Also
  proved the local-proof-stack discipline collapses CI to one push.
- **telemetry-feature-backfill (accepted, pass@5 1/5, three commits, gate cleared on the
  FIRST content push):** the garden path ported cleanly to feature engineering (rebuild a lost
  featurizer; pilot month certifies naive readings; per-channel sensor rail decided 3 integer
  features on held-out saturation regimes). NEW nuance: both eval agents FOUND the primary
  insight (rail from self-test data, not the 4095 ceiling — the operational definition in the
  spec made it discoverable, as fairness demands), and the task STILL failed 4/5 because a
  **scope sub-decision** stayed pilot-silent: failing agents computed one fleet-wide rail
  instead of per-device rails, and the all-zero-saturation pilot certified it. Lesson: the
  naive/true split need not be "textbook value vs measured value" — **"right mechanism, wrong
  aggregation scope" is a nameless crux** that passes the named-gotcha veto by construction.
  Gate-facing gotcha: the static checker greps Dockerfile COMMENTS for `tests/`/`solution`
  tokens (cost two comment-reword commits) — pre-push grep every checked file, comments
  included.

---

## 12. Gate mechanics quick-reference

Pipeline (sequential, AND-ed): Static → Rubric → Duplicate → Validation → Pass@2 →
Automated Review → AVA → Adversarial Cheat-Pass (advisory) → Per-Check QC → Pass@5 → gate.
All gating stages must pass; advisory stages post comments but never block. Each gates the next; every push re-runs all and cancels the in-flight run.
- **pass@2** (pre-check): passes iff ≥1 VALID failure (finished, wrong, fair).
- **pass@5** (real gate): passes when the agent fails at least 3 of 5 attempts. Acceptance
  band: 0–2/5 accepted, 3–5/5 rejected. A 0/5 of valid failures is the strongest result.
  Ceiling = 0/5 solved, avg@5 0.000 (hit by restore-archive and fix-transfer-pipeline).
- **Valid vs invalid:** valid = finished-and-wrong on a fair prompt. Invalid = timeout
  (in-progress or soft), ambiguity, reward-hack, refusal, verifier defect. Only valid advances.
- **Infra vs merit:** before touching content, check if the red job actually SCORED a verdict
  or died in setup / stayed in-progress / lost logs (INFRA → re-trigger identical, never
  redesign). Cross-check githubstatus.com and status.claude.com.
- **deep_review is a lottery** (one finding per run, re-draws) → the anti-cheat battery must
  leave nothing to find.

---

## 13. The ≤5-commit checklist

1. Claim a domain that fits the method (section 6). The category locks — choose once.
2. Pick the mechanism from the section-3 tree BEFORE coding. Default to the garden path (B).
3. Apply the named-gotcha veto and the fairness gut-check to the design on paper.
4. Build in the section-8 order.
5. Run the ENTIRE section-9 proof stack locally until every gate is green — this replaces CI
   iteration. Do not push to "see if it's hard"; know it is first.
6. Full-repo audit (section 9.6).
7. Push once. Watch for infra vs merit. Expect the gate in ~2.5 h.
8. If it reds on a real verdict: read the ONE diagnosed thing, harden the whole class,
   re-run the full local stack, push again. One clean diagnosis + the proof stack beats five
   hopeful pushes.
9. On `accepted`: freeze the repo at that commit, submit via the portal, do not edit.

The through-line across every project: **stop trying to out-clever the model on the rule
(it wins that); take away the method it uses to recover any rule, and prove you did it locally
before you spend a push.**
