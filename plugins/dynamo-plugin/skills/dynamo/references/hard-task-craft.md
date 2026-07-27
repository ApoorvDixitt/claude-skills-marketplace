
# Hard-task craft — the complete, self-contained playbook

This single file holds the entire brain of the `cost-basis-reconcile` project:
the strategy, the two CI reviewers' patterns, the verification system, and — most
importantly for improving your own work — **a ledger of every mistake and what it
taught.** It folds in what used to live in two companion skills so you carry one
file, not three.

The result it encodes: a Dynamo task the reference agent solved **2 of 2, ten
rounds in a row**, and on the eleventh (v11) solved **0 of 2** — cleanly clearing
the difficulty gate. v11 was not luck. It was one correct diagnosis plus a proof
system that never let a guess ship.

**The sole goal of this file:** learn from what went wrong, learn exactly how the
reviewing agents work, and turn both into a repeatable method that makes the next
task better.

---

## 0. The one thesis (read this first; the rest is detail)

A frontier model is **superhuman at guess → check → correct**. Give it any hidden
rule it can *verify a partial guess against* — a labeled example, a per-item
oracle, a self-checkable invariant — and it recovers that rule, however exotic,
usually in under half an hour. Ten rounds proved it: every convention I hid (an
ordering, a Hamilton apportionment, a 42-day window, a classification, a
three-layer cascade) the model recovered by reasoning it out and checking it
against the evidence I handed it.

**Fairness requires the answer be recoverable from data the agent holds — but
"recoverable" is exactly the model's strength.** That paradox kills most hard-task
designs: make the rule weirder, the model just runs its guess-check loop harder and
still wins.

The escape is not a harder rule. It is **removing the feedback gradient**: build the
task so the agent *cannot verify a partial guess.* Force it to reconstruct the whole
mechanism and match only an aggregate signal, or make the guess-space too large to
search inside the time budget. The answer stays uniquely determined (you prove that
separately), but it is no longer *checkable piece by piece.* That is the one durable
seam against this class of model, and it is the only thing that worked.

---

## 1. Know your two judges — how the reviewing agents actually work

This is the "learn the reviewers' pattern" half. Two intelligent CI agents gate a
Dynamo PR. Design *against* the second; satisfy the first cleanly.

### 1A. The review / eval bot (the quality gate)

Runs as the `review`, `similarity`, `validation` jobs plus the "Static checks" and
"Dynamo eval" comments. Layers:

1. **Deterministic static checks** — file inventory, digest-pinned base image,
   pinned pip deps, `.dockerignore`, `artifacts` a top-level array matching real
   outputs, no strays, no personal info. It *greps docstrings/comments for tokens
   that look like undocumented outputs* — naming a solution file anywhere
   (even in a test docstring) fails it.
2. **LLM rubric pass** — checks instruction↔tests 1:1 both ways (the #1 killer),
   the explanation fields against the actual verifier, instruction clarity.
   **Precedent: this repo's rubric OUTRANKS the platform docs.** It once failed a
   push for including the platform-mandated "You have N seconds…" suffix line. When
   rubric and platform docs conflict, rubric wins.
3. **Similarity / duplicate** check against the task corpus (verdict "UNIQUE").
4. **Validation** — it builds the image and runs oracle (expect 1.0) and nop
   (expect 0.0) itself. Passes if you calibrated locally first.

Satisfy it with: one test per stated criterion (docstring naming the criterion),
explanations that describe the verifier you actually shipped, no solution-filename
tokens, oracle/nop calibrated first, and repo-rubric-over-platform-docs on any
conflict. It is not the hard part — but it **writes the verdict comment you mine**
(§2).

### 1B. "Model A" — the pass@2 / pass@5 difficulty agent (the judge you design against)

GPT-5.4 + Terminus-2 harness at xhigh reasoning, on Daytona, budget = the task's
`timeout_sec` (capped 3600 s = 1 hr). Run **twice** for pass@2; the task advances
only if **≥1 run is a VALID failure** (the model FINISHED and was WRONG on a fair
prompt). Timeouts, wedges, infra errors, and ambiguity are *invalid* and bounce the
task. Clear pass@2 → pass@5 runs automatically → accepted at **0–2 of 5 solves.**

**Its invariant loop (seen in every trajectory):**
1. Reads every file in `/app` before acting.
2. Treats any provided reference output (a statement, a sample) as an **oracle to
   tie out against**, per line, before submitting.
3. Implements the whole disclosed spec in one shot, usually flawlessly (`Decimal`
   money, clean general engine, every stated edge handled).
4. Where behavior is under-determined, it forms hypotheses **before coding** — it
   derived Hamilton apportionment *hypothesis-first from one figure.*
5. On mismatch it enumerates rivals from **named families** (orderings, standard
   apportionments, standard roundings) and iterates until the oracle ties out.
6. Finishes in 17–31 minutes of a 60-minute budget. It does not time out, refuse,
   or reward-hack — rubric-confirmed every round.

**What it provably defeats — do NOT bet here:** scale/tedium; held-out
generalization by itself (its engines are genuinely general); ANY latent
convention that is a pick from a named family; multi-mechanism composition of
disclosed rules; obscure-but-documented domain knowledge (it knows the tax code).

**Where it is weakest — bet here (revised and confirmed by v11):**
Fairness forces the hidden behavior to be uniquely recoverable from data the agent
holds, and recoverability is what this model is superhuman at. So *convention-
recovery designs cannot stump it* — no matter how ad-hoc or prior-defying the
convention. The **one** corpus-proven 5/5-fail shape is **reconstruction with no
incremental feedback**: the guess-space is too large to enumerate AND there is no
per-case tie-out to descend on, so every hypothesis is all-or-nothing wrong with no
gradient. v11 reached that shape by making the evidence aggregate-only.

**Process facts:** each push runs pass@2 and *cancels any running eval and consumes
a slot* (~6/day) — never push while one is in flight. The verdict comment carries a
full per-trajectory analysis (approach, per-figure values, timing) — always mine it
before redesigning; it is the richest signal in the loop.

---

## 2. The diagnostic loop (where the real intelligence is)

**The verdict comment is the single most valuable artifact in the whole loop.** It
tells you *exactly how the model beat your task.* Read it before changing one line.
It beat every external "how to stump LLMs" essay ten times over — essays give
generic advice; the verdict tells you what happened to *your* task.

Every round:
1. **Read the trajectory.** What did the agent do, step by step? On v10 it literally
   reasoned *"if April 12 is 42 days after a certain point, the wash window needs to
   be at least 42 days wide."* That one line was the whole diagnosis.
2. **Find the feedback source.** What did it check its guesses against? A labeled
   per-symbol statement let it isolate one convention at a time. *That handhold is
   the thing to remove.*
3. **Named-gotcha test.** If a senior engineer could name your trap ("that's a
   wash-sale ordering thing"), the model names it too and applies the textbook fix.
   The trap's power must live in something nameless (a custom accumulator, an
   aggregate-only constraint).
4. **Diagnose, then build to the diagnosis** — "what makes the agent's own method
   stop working?" — not "make it weirder."

---

## 3. The design principles that work

Ranked by proven power. Combine two or three; each alone is usually recoverable.

1. **Remove the feedback gradient (decisive).** Give an evidence artifact the agent
   cannot decompose. v11: the surviving statement went from *seven per-symbol lines*
   to *four account-level totals.* Same uniqueness (proven separately), but a wrong
   dial now shows up only as "four aggregate numbers off," with nothing isolating
   which dial. The agent must reconstruct the whole engine and match four numbers at
   once — the 5/5-fail shape. This flipped ten 2/2 solves into a 0/2.
2. **Entangle several latent dials.** One dial is a small search; jointly the
   mismatch signals confound and the space multiplies. v11 had four coupled dials
   (before-window width, after-window width, allocation scheme, excess
   classification) → a 2,904-combination space with no per-dial feedback.
3. **Make the textbook prior wrong.** Pick a domain where the competent answer is
   *not* what the engine did: a 35/42 asymmetric window vs the statutory 30; a
   short-term classification of an amount the law calls long. The model's strongest
   instinct becomes its trap, correctable only by the data.
4. **Defeat per-case algebra with designed ambiguity.** Make ≥1 calibration case
   admit more than one solution (v11's three-loss symbol had two valid share vectors
   with identical totals), so case-by-case solving is impossible and only
   reconstructing the general scheme works — then carry the difference into the
   graded data so the wrong pick costs.
5. **The silent trap.** The wrong reading must *run clean and look right* on
   everything the agent can self-check. v11's 30-day-window rival reproduces every
   visible figure and fails only the held-out books — no error, no tell.

Mechanism of the v11 win, plainly: no gradient → the agent must brute-force the
joint space → the brute force (a 3,456-combination grid search, one trial started
it) is too expensive for the budget → no output, valid failure. Removing the
handhold and blowing the budget are the same move.

---

## 4. What does NOT work — and what you must refuse

Hard-won negatives; do not spend effort here:
- **Catalog conventions** — any named-family rule (orderings, Hamilton, by-shares,
  standard roundings) is in the model's prior; it recovers them hypothesis-first.
- **Scale, tedium, obscure-but-documented knowledge, rare languages** — all defeated.
- **Held-out generalization alone** — its engines are general (still keep held-out
  books; they defeat *hardcoders* for the anti-cheat gate).

Two things to **refuse outright** — they get the task rejected and are dishonest:
- **Obfuscation / "confusing high English" / attention-overload code.** It aims to
  make a *reviewer* miss something — wrong target: the pass@2 agent never reads your
  solution, it writes its own from the instruction. And a solver that fails from
  confusion is an *invalid* failure (rubric scores `near_miss`, `approach_validity`,
  ambiguity) that bounces the task. It also breaks the human-authorship attestation.
  It cannot help; it can only hurt. Refuse however it is reworded.
- **Ambiguity as difficulty.** Unclear prompt → invalid failure → rejection.
  Trickiness lives in *arithmetic the agent must reconstruct*, never in prose it can
  misread. The instruction is unambiguous; the *engine's conventions* are what's
  hidden, honestly flagged as inferable from the artifact.

---

## 5. The certainty system — prove it, never guess

This is what makes "give me the result with surety" real. v11 was not a lucky pass;
every claim it made was proven by an independent check before shipping.

**Rule zero: never trust one derivation.** Compute every graded number ≥2 ways that
must agree:
- **Hand derivation** — worked out by hand/spec, written in the test docstring.
- **Analytic generator** — each data cluster emits its contribution from a
  closed-form formula in exact integer cents, *independent of the reference engine*
  (`Fraction`, asserts every structural constraint).
- **The reference engine** — the actual `reconcile.py`.
Hand == analytic == engine for every symbol and book → the number is real. Any two
disagree → a bug; fix before CI sees it.

**The proof stack, in order:**
1. **Per-symbol isolation sweep** — run the engine on each symbol alone; every line
   matches its hand value and the lines sum to the graded totals. Verify ground
   truth this way — *never by delta arithmetic from a previous version.*
2. **Analytic-vs-engine crosscheck** — every held-out symbol in isolation and every
   book's totals: formula == engine, to the cent. Must print ALL OK.
3. **The rival-probe matrix (the uniqueness proof — the centerpiece).** Build a
   variant engine for every plausible reading of every latent dial (substitute just
   that dial's code block), then take the **full cross-product.** v11: 11 × 11 × 12
   × 2 = **2,904 variant engines**, each run on the visible account. Required
   result: **exactly one combination reproduces the surviving artifact**, AND every
   single-dial deviation *also* fails the graded data. If two combinations match the
   artifact, the task is *ambiguous* (an invalid-failure trap) — add a discriminating
   case and re-probe until exactly one survives.
4. **The wrong-solution proof** — inject a one-line bug (flip the window to 30);
   confirm it scores **0**, ideally failing the *held-out books while the visible
   figures still pass* (proves the trap is graded and silent). Revert; confirm
   byte-identical.
5. **Calibration** — `harbor run --agent oracle` → **1.0**, `--agent nop` → **0.0**,
   twice, repeatable. (Docker down? Replicate the verifier's assertions in plain
   Python — run the delivered program on the visible data and each book, check every
   value within tolerance = the oracle=1.0 equivalent; nop=0.0 is guaranteed when
   nothing writes the output.)
6. **Hygiene gates** — leak-scan the *built* image (only seed files in `/app`); all
   files LF; `task.toml` parses and every field rule holds; instruction↔tests 1:1;
   no answer string agent-visible; no personal info; instruction ends with the required
   "You have N seconds..." line, N == `[agent].timeout_sec`.

All six green on the exact shipped state → you are not guessing. You know.

---

## 6. The mistakes ledger — learn from what went wrong

The heart of "learn from your mistakes." Every one of these actually happened in
this project; each line is a rule earned the hard way.

| What went wrong | Why it was wrong | The rule it taught |
|---|---|---|
| Predicted the new ground truth by **delta arithmetic** off a previous version | Used one symbol's quad as another's baseline → GT off by hundreds | Verify GT by a **per-symbol engine sweep**, never by subtracting versions. |
| First v11 build put S22D's buys **27–34 days before** the loss sale | Under the 42-day *after*-window logic they got consumed by the before-arm; the symbol's totals shifted | Check **both** window arms on **every** date bracket; assert each gap is in/out on the intended side. |
| A README edit **silently no-op'd** (a `python .replace` didn't match) | Shipped a stale paragraph describing an old design | Use exact-match Edit; **verify the edit landed** (Edit errors loudly — prefer it over blind string replace). |
| A sell row was **dropped during a data rebuild** (date collision) | A symbol's totals were quietly wrong | Assert **within-symbol date uniqueness**; the crosscheck catches the rest. |
| Partial resales of **same-acquisition-date sub-lots** | Their outcome would hinge on an **unstated FIFO tie-break** → an invalid-failure trap | Never grade on a tie-break the instruction doesn't fix; redesign resales as **full-consumption single sales** (order-independent). |
| Engine counted **2022** losses in `wash_sale_loss_disallowed` | The report covers 2023 only | Guard every reported figure by the **reported tax year.** |
| v5 hid a "custom broker tax convention" for matching order | **Treas. Reg. §1.1091-1 pins earliest-first** → the convention was a legal contradiction, making failures unfair | **Websearch the domain** before hiding a convention; if the law fixes it, reframe as **"reproduce the legacy engine"** (nothing in data is wrong, it is just what the engine did). |
| A test **docstring named `solve.py`** | The static bot read it as an undocumented artifact → fail | **Never name solution files** anywhere agent-visible OR in tests. |
| Included the platform-mandated **timeout suffix line** on a repo whose rubric forbade it | That specific repo's rubric (`dynamo-rubric.toml`) had a stricter rule | Check your specific repo's `.dynamo/dynamo-rubric.toml` — the CURRENT platform default REQUIRES the timeout line. Only omit if your repo's rubric explicitly overrides. |
| Ran calibration with **Docker daemon down** | Harbor silently produced no jobs; looked like a pass that wasn't | Confirm `docker info` succeeds first; if down, start Docker Desktop or use the plain-Python verifier replica. |
| Tried to `git push origin` | The account is **pull-only on origin (403)**; the PR is served from the **fork** | Push to the **fork** remote (`git push fork <branch>`); origin is read-only. |
| Considered "confusing high English" to trip the agent | Ambiguity = invalid failure = rejection | Difficulty goes in **arithmetic to reconstruct**, never in prose to misread. |

Meta-lesson across all of them: **the proof stack (§5) caught most of these before
CI did.** That is its whole purpose — it converts "I think this is right" into "I
have shown it," which is the difference between guessing and knowing.

---

## 7. The v1 → v11 arc (the case history)

The evolution is the map for escalating the *next* task — from guesswork toward
proof.

| Ver | Hypothesis (what I bet was hard) | Verdict | Lesson |
|----|----|----|----|
| v1–v4 | Compound the disclosed mechanisms; grade held-out books | 2/2 solved | Composition of *stated* rules isn't hard; it implements a full spec flawlessly. |
| v5–v6 | Hide the multi-loss allocation *order* as a broker convention | 2/2 solved | The tax reg pins earliest-first → **reframed as legacy-engine reimplementation.** Fair framing unlocked; still solved. |
| v7–v8 | Statement necessary-but-not-sufficient; hybrid ordering | 2/2 solved | Still two *catalog* picks; the agent enumerates orderings and ties out. Catalog = recoverable. |
| v9 | Allocation as a reconstructable **algorithm**, pinned by a 3-loss symbol | 2/2 solved | Both agents derived Hamilton *hypothesis-first, before coding.* Any **named** scheme is in the prior. |
| v10 | THREE entangled conventions + misleading statutory prior | 2/2 in 24–28 min | It recovered all three and reasoned the window out loud. Complexity didn't slow it. **Recoverability = solvability; the per-symbol statement was the handhold.** |
| **v11** | **Remove the handhold: totals-only statement + asymmetric window** | **0/2 — GATE CLEARED** | No per-symbol gradient → brute-force the 2,904-space and match four aggregate numbers → grid search ran out of budget. The seam was never the conventions; it was the feedback. |

Through-line: stop trying to out-*clever* the model on the rule (it always wins
that); take away the *method* it uses to recover any rule. "Harder secret" →
"no gradient to descend."

---

## 8. The build procedure (condensed operating order)

Build/repair in this order (each step's detail lives in the sections above):

1. **`solution/solve.sh`** → thin wrapper calling the real program; writes absolute
   `/app/...` outputs; zero installs; genuinely computes (never hardcodes).
2. **`environment/Dockerfile`** → approved base pinned by `@sha256`; pinned test deps
   (`pytest==8.4.1 pytest-json-ctrf==0.3.5`); `RUN mkdir -p /app`; COPY only seed
   inputs; **never** the solution or tests; add `.dockerignore`.
3. **`tests/test_outputs.py` + `tests/test.sh`** → strict 1:1 with the instruction;
   one test per criterion, docstring names it; expected values hardcoded from the
   fixed seed with a derivation comment. `test.sh`: `mkdir -p /logs/verifier`, run
   pytest with `--ctrf /logs/verifier/ctrf.json`, write `1`/`0` to
   `/logs/verifier/reward.txt`, always `exit 0`.
4. **`instruction.md`** → prompt-style, absolute paths, every output file + exact
   keys/types disclosed, "what" not "how", example values ≠ the real answer, no trap
   name, ends with the required "You have N seconds..." line (N == `[agent].timeout_sec`).
5. **`task.toml`** → `artifacts` a top-level array of the real outputs; pre-seeded
   fields (`category`, `subcategory`, `model_tested`, `agent_tested`) untouched;
   plain explanations that match the actual verifier.
6. **`README.md`** → short reviewer note: task, environment, verification, calibrate
   commands.

Then run the full proof stack (§5). Never skip calibration for inspection.

---

## 9. The four-axis defect sweep (what breaks the format)

For any build or self-review, check each axis and name what would wrongly pass/fail:

| Axis | What breaks it |
|---|---|
| **Format (`task.toml`)** | `artifacts` not a top-level array, or path ≠ what the task writes; missing/edited pre-seeded fields; forbidden fields (`tags`, `schema_version` — `avg_at_8` was fully removed); personal info |
| **Environment (Dockerfile)** | unpinned/floating base (must be approved + `@sha256`); solution or tests COPYed in (leak); unpinned pip; missing `mkdir -p /app`; deps only the oracle needs |
| **Verifier (`tests/`)** | asserts existence/non-empty instead of real values; reward written anywhere but `/logs/verifier/reward.txt`; no `ctrf.json`; verify-time installs; nondeterminism; enforcing anything the instruction never states (undisclosed literals, tie-breaks, dedup) — **the #1 rejection cause** |
| **Instruction** | vague; no absolute paths; output file/schema unnamed; a requirement the tests enforce but the prose never states; the answer leaked (including in an example value) |

---

## 10. Hard-rule quick card (violating any one fails CI or review)

1. Solution/tests **never** in the agent image (verify by scanning the built image).
2. Base image: approved list + `@sha256` pin. Pin pip exact; don't pin apt.
3. Verifier: real-value assertions; `reward.txt` + `ctrf.json` to `/logs/verifier/`;
   `test.sh` exits 0; no installs; deterministic; **1:1 with the instruction.**
4. Verifier must not enforce anything the instruction doesn't state.
5. `artifacts` = top-level array of the real output paths.
6. Pre-seeded `task.toml` fields untouched; no personal info anywhere.
7. Instruction ends with the required "You have N seconds..." line, N == `[agent].timeout_sec`
   (unless your repo's `.dynamo/dynamo-rubric.toml` explicitly overrides).
8. **Oracle 1.0 and nop 0.0, repeatable, before any submission — no exceptions.**
9. A failure counts only if the model **FINISHED and was WRONG on a fair prompt.**
10. Uniqueness is non-negotiable: the artifact must pin exactly one answer (probe it).

---

## 11. Environment & submission caveats

- **harbor** installed via `uv tool install harbor` — lives in `~/.local/bin` (macOS/Linux)
  or `C:/Users/<username>/.local/bin` (Windows). Ensure it's in PATH.
- On Windows Git Bash: **`export MSYS_NO_PATHCONV=1`** before any `docker run ... /bin/bash`.
- **Docker Desktop must be running** — confirm `docker info` first.
- Push to the **FORK** remote (origin is pull-only, 403). Never push while eval runs.
- After anything is pasted into a submission form, **the repo is FROZEN** — no edits.


---

## 12. The reusable playbook (run this on a new task)

1. **Frame for latent conventions** — pick a domain where "reproduce a legacy
   system's surviving output" is the natural, fair job; that earns the right to hide
   engine conventions, honestly flagged as inferable from the artifact.
2. **List the dials** — every behavior the stated rules leave open (ordering, width,
   rounding, classification, apportionment).
3. **Make each dial non-catalog and prior-defying**; entangle three or four.
4. **Choose the artifact's granularity — the key lever.** Per-item detail gives a
   gradient; aggregate-only forces reconstruction. Default to the **coarsest
   artifact that still uniquely pins every dial.**
5. **Prove uniqueness with the cross-product probe (§5.3) BEFORE building anything
   else.** Exactly one combination reproduces the artifact, or add a discriminating
   case and re-probe.
6. **Build held-out books** from analytic cluster templates; crosscheck
   analytic-vs-engine per symbol and per book.
7. **Run the whole proof stack** (§5.4–6).
8. **Write prose a human could defend line by line** — plain, specific, real numbers,
   no filler, no answer leak, no trap name.
9. **Ship one version, read the verdict, repeat the diagnostic loop (§2).**

---

## 13. Fairness gut-check & voice standards

- **A failure only counts if the model FINISHED and was WRONG on a fair prompt.**
  Design for that specific outcome.
- **Fairness gut-check (both must be yes):** would a human expert, seeing only what
  the model sees, (a) get it right and (b) call the failure fair? Either "no" → the
  trap is invalid.
- **Voice:** plain and specific; real values/paths/counts; ban stock filler (delve,
  robust, leverage, intricate, "it's important to note"); vary sentence length; every
  sentence earns its place. Never fabricate a number — paste only output from a run
  you actually executed. Could you defend each line under a reviewer's question? If
  not, cut or fix it. **Quality, specificity, and genuine verification are what pass
  review — there is no shortcut through disguise.**

---

## 14. Generalizing beyond Dynamo

The method is domain-independent. For any setting where you must make a task
genuinely hard for a strong model and be *certain* it is:

- **Find the model's feedback source** — the thing it checks partial guesses against
  — and take it away while keeping the answer uniquely determined.
- **Prefer aggregate evidence over itemized evidence** when you want reconstruction,
  not lookup.
- **Prove uniqueness by exhaustive rival enumeration**, not by inspection.
- **Compute every ground-truth number two independent ways** and never ship a
  disagreement.
- **Read the model's actual trajectory** — its reasoning, output, and timing —
  before theorizing about why it did or didn't fail. The real signal is in what it
  did, not in what an essay says models do.

The task changes; the seam (remove the gradient), the proof (cross-product
uniqueness + double derivation), and the discipline (never ship a guess) do not.
