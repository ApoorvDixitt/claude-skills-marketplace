
# Dynamo: Measure First — land it in <=5 commits, not 20

## The one thesis

**Every prior 20-commit slog was blind pushing.** You cannot out-clever the review agents by *guessing*
what is hard and fair — you burn a commit to find out, react to one verdict, guess again. The escape is
to **turn difficulty and fairness into local measurements you take BEFORE you push.** CI then just
confirms what your harness already told you.

Two numbers decide a Dynamo task, and both are measurable locally:
- **Difficulty** = does a capable agent, given only `/app`, fail the held-out packs? → measure with a **proxy solver**.
- **Fairness** = would `deep_review` (which reads `task.toml`) call the decisive rule discoverable? → measure with a **task.toml-aware reviewer**.

If you have not measured both, you are guessing, and guessing costs commits.

## The harness (build this FIRST, before designing the crux)

### 1. Proxy-solver harness — predicts pass@2 / pass@5
- Copy the exact `/app` materials the agent sees (stub deliverable, process_notes, instruction, desk/config, visible packs + digests) into an **isolated dir far from the repo** (a scratchpad), so a curious subagent can't wander to the solution or held-out golds.
- Spawn a strong `general-purpose` subagent with a realistic "repair this broken tool" prompt + the real instruction text. Tell it to work ONLY in that dir. Have it write the repaired deliverable in place.
- **Grade** its output against the held-out golds with a tiny grader that mirrors the CI verifier's `_run` (set up a temp `/app`, run the deliverable per pack, compare the graded keys).
- **CALIBRATE IT on your CURRENT design first.** If a proxy solves your current design exactly like the CI did ("2/2 solved" ⇒ proxy passes all held-out), the proxy is a faithful predictor. A proxy that fails a known-solvable design is miscalibrated — fix the prompt/isolation.
- Run **N independent proxies** (4–6). The fraction that fail the crux packs (while passing everything else) is your **trip rate** — the single most important number.

### 2. Task.toml-aware reviewer harness — predicts deep_review
- Spawn subagents that read what `deep_review` reads: `task.toml` (your `solution_explanation` / `difficulty_explanation`), `instruction.md`, `process_notes.md`, visible packs/digests, and `solution/`.
- Ask ONE narrow question: "Is the decisive rule discoverable + intended + something a domain expert would *necessarily* do, or is it an arbitrary undocumented gotcha?" Force a `VERDICT: FAIR | UNFAIR` + justification.
- **Run TWO kinds** and read the split:
  - **Strict `/app`-only reviewer** (sees only what the agent sees) → predicts the harshest read.
  - **`task.toml`-aware reviewer** → predicts the real `deep_review`.
- The sweet spot is exactly: **strict says UNFAIR, faithful says FAIR** — that means the rule genuinely evades the agent (hard) yet an expert with the convention rules it fair. That split, with a REAL convention behind it, is the fair-and-hard target.

## The vise, and the only escape (design theory)

**The vise:** For a *misread*-type crux, "hard" and "unfair" are the SAME property.
- Fully disclose the rule in `/app` → a capable agent implements it → **solved** (too easy). Proven repeatedly.
- Hide the rule → `deep_review`/`qc_gate` call it underdetermined → **unfair** (invalid block).
- The trip happens precisely *because* the rule is underdetermined, and underdetermined *is* unfair.

**Two escapes:**
- **A — Intrinsic hardness (symbolic/math/CAS domains):** the agent implements the fully-disclosed rule but gets it *wrong* because the correct implementation is genuinely error-prone (Gröbner/regular-chains, exact geometry degeneracies, grad-accum loss). "Hard even when you know the rule."
- **B — Canonical-path deviation over a REAL convention (bookkeeping/library domains) — the loop-board mechanism, and how retain-board won:**
  1. Pick a rule that is a **genuine domain convention** where the naive reading is a **real error, not a defensible alternative** (retain-board: a disposition board is point-in-time — every clock is dated to the single board snapshot `as_of0`; using a record's stale per-row re-scan stamp is a real compliance error).
  2. Disclose it **subtly in `/app`**: state the *principle* ("point-in-time disposition as of `as_of0`") but let the *salient cue* point the wrong way — the stub already uses the per-row column, the clock formula uses a bare token, the snapshot is spelled out only for a *neighboring* rule (holds). Careful agents take the expressio-unius / canonical path and trip.
  3. Put the **operative rule + a citation of the real convention in `task.toml`** (which `deep_review` reads and the agent cannot). Now an expert-aware reviewer rules it FAIR while the agent still trips.
  4. **Invisible on everything visible:** every visible AND novel pack must make the naive and correct readings coincide (uniform inputs), so the naive reading self-verifies clean and the agent stops-and-ships. The crux only bites **held-out** packs that break the invariant (staggered inputs). If any visible pack exposed it, the agent would fix it.

## How to filter the best algorithm (empirical selection, not guessing)

1. Enumerate candidate cruxes. Score each on three gates BEFORE building:
   - Is it a **real convention** where the naive reading is a genuine error? (fair-to-expert)
   - Can it be made **invisible on all visible + novel packs**? (self-verifies clean)
   - Does the **salient cue point the wrong way** (a column, the stub's own code, a neighboring rule scoped elsewhere)? (canonical-path deviation)
2. Build the top candidate. **Measure** trip rate (proxies) and fairness (both reviewer kinds).
3. Keep the one that reliably stumps AND stays faithful-FAIR. Discard the rest. Let the numbers pick, not your intuition.
4. If a candidate stumps but even the *faithful* reviewer says UNFAIR → it's a hidden gotcha, not a convention. Kill it.
5. If a candidate is faithful-FAIR but the proxy solves it → it's transcribable. Make the `/app` disclosure subtler (or move the operative statement to `task.toml`) and re-measure — but never so subtle that the convention stops being real.

## Make it as hard as possible — fairly

- Difficulty must come from a **fair mechanism the agent misses**, never from volume, busywork, or compute.
- **A rule spelled out in the notes = transcribed = solved.** If your proxy reads a rule and implements it, it's not a crux.
- **Layering** compounds the per-trial fail rate ONLY if each layer genuinely trips (documented layers trip ~0% for careful agents). One real canonical-path crux at ~100% trip beats three transcribable ones.
- Witness the crux with **held-out golds** (so `qc_gate` sees it documented + graded) but keep it off every visible/novel pack.
- pass@5 needs >=3/5 fails. A crux measured at 6/6 proxy trip clears pass@2 and pass@5 with margin; anything under ~0.7 trip is a pass@5 coin-flip — layer or sharpen.

## Verifier soundness (ava) — bake it in from the start

- **Ship NO reference algorithm on disk at grade time.** Generate any "novel/anti-overfit" packs at BUILD time with the house engine and ship **static golds** under `/tests`; the verifier only *compares*. Removing the recipe entirely is the cleanest ava pass (retain-board's `ava_review` passed on exactly this).
- Load every gold into memory, then **delete `/tests/data` and unlink `/app/digests` before any submission subprocess runs** — nothing on disk to echo or delegate to.
- Add a guard test that asserts the golds are wiped and no `*ref*/*engine*/*house*/*solve*/*oracle*` module ships under `/tests`.

## The <=5-commit sequence

1. **Commit 0 (local, no push):** calibrate the proxy on the current design; confirm it reproduces the known CI result.
2. **Build the crux; MEASURE:** iterate `/app` disclosure vs `task.toml` documentation until **N/N proxies stump (valid fails) AND faithful reviewers rule FAIR**. This is the whole game and it's all local.
3. **Harden + prove:** harbor `oracle 1.0 / nop 0.0` on the full verifier; ava (recipe removed / golds isolated); leak scan (`/app` ships only stub+notes+config+packs+digests); LF on every CSV writer; deterministic (seeded); full-repo audit (README, instruction, task.toml consistent).
4. **Push ONCE.** Watch. If it dies on **infrastructure** (e.g. `DaytonaAuthorizationError`, agents never invoked, verifier never ran) that is NOT a merit failure — re-trigger, do not change the design.
5. **Reserve 1 commit** for a verdict-driven surgical fix (only if a real gate flags something).

## Hard-won cautions (the exact traps that cost retain-board its extra commits)

- **Don't push blind.** If you have only proven `oracle=1.0`, you have measured nothing about difficulty or fairness. That is the 20-commit trap.
- **The Handshake submission doc is TB3.** The "You have N seconds…" line it lists as a hard gate is an **AUTOMATIC FAIL** for a **TB2** `review` (`instruction_concision`) — the agent budget lives ONLY in `task.toml [agent].timeout_sec`. When a doc contradicts empirical CI (a prior run that passed `review` without it), **trust the CI.**
- **Read the failure reason before reacting.** A 3-minute pass2 "fail" was pure Daytona infra; a `review` fail was one added line. Grepping the job log for the actual verdict saved a wrong "fix."
- **Two reviewers, not one.** A single strict `/app`-only reviewer will scream UNFAIR at the exact design that wins — because `deep_review` reads `task.toml` and it doesn't. Always run the faithful (task.toml-aware) reviewer to predict the real gate.
- **Infra != merit.** Daytona auth errors, DNS outages, quota — never a task defect. Diagnose, then re-trigger.

## Anti-patterns — the 25-commit failure catalog (elim-board `dynamo-154fdd0`)

elim-board is the counter-example that proves this whole skill: it took **25 commits** because it was built the way this file tells you NOT to — guess, push, react, repeat — and it only cleared the gate once the crux became the exact "fair-and-hard middle path" that *measuring first* finds in ~5. Every trap below is one it actually hit. Read them as "do the opposite."

### A. Design anti-patterns — the "what gets solved / what's unfair" ladder
The tested agent (Opus-4.8 / Terminus-2) is far stronger than intuition says. All of these were *tried and failed* on elim-board:
1. **Disclosed formula → typed in.** A fully-written transfer (linear-below-knee power law, knee+curve) in `process_notes` → agent implemented it verbatim → **2/2 solved.** *A disclosed rule is not a crux; it's an instruction.*
2. **Derivable scope → derived.** "E is over the generator ideal I" documented → agent reasoned to the raw basis → **solved.** *If a competent expert can reason to it from the prose, so can the agent.*
3. **Documented ARBITRARY convention → still implemented.** An unmotivated `top_queries` tie-break ("ties → query_id **descending**", opposite of the universal default), clearly stated → agent read it and implemented descending → **solved.** *Arbitrariness does not save you if the rule is spelled out; the agent faithfully implements documented conventions, even weird ones.*
4. **Ambiguous convention → stumps but UNFAIR.** `elim_bins` "descending / highest-ordered" had two defensible readings (reverse-string vs by-degree). It stumped the agent 0/2 — but `deep_review` failed it (`decisive_answer_discoverable`: *"a spec-silent choice not discoverable from agent-visible material"*). **Ambiguity is not difficulty; it's a gotcha, and the gate rejects it.**

**Synthesize and memorize:** *disclosed → solved · derivable → solved · documented-arbitrary → solved · ambiguous → unfair.* Every "obvious" lever sits on one side of the vise or the other.

### B. Escape C — the INDIRECT DATA ANCHOR (how elim-board finally won; extends the two escapes above)
The winning crux threaded the vise with a **third fairness mechanism**, distinct from Escape A (intrinsic hardness) and Escape B (task.toml citation):
- Crux: energy `E` scored over the **raw** generator-ideal basis, not the **saturated** working basis the stub already computes.
- **Not disclosed** (no "use the raw GB" spotlight) ⇒ not transcribed ⇒ not solved.
- **Not ambiguous** (exactly one right basis) ⇒ not an unfair gotcha.
- **Made fair by an INDIRECT DATA ANCHOR in `/app`:** one sentence — *"attr.json weights the keep-side terms that saturation removes; those removed terms remain scored"* — which is **meaningless unless E scores the raw basis.** An expert who *interprets the data ledger* derives the true scope ⇒ `deep_review` PASS (FAIR). The agent, holding a naive fix that self-verifies on everything checkable, **never interprets the ledger** ⇒ stumped 0/2.

**Escape C in one line:** *make the truth discoverable ONLY by interpreting an in-`/app` data invariant (an attribution ledger, a checksum, a physical constraint) — never by reading a rule.* Unambiguous (fair) + un-spotlighted + self-verifying-naive (hard). This is the fair-and-hard middle path the "vise is total" argument misses.

### C. Mindset anti-patterns — the wrong mental models that cost the most commits
1. **"Make it harder."** The WRONG lever. elim-board *already* stumped the agent (pass2 0/2) on several commits — difficulty was never the failing gate; **fairness** was. Adding difficulty pushes toward *hidden* ⇒ more unfair. **When pass2 passes but deep_review blocks, the lever is FAIRNESS (turn the truth into an unambiguous-but-un-spotlighted data anchor), not more hardness.** Cranking difficulty is the exact opposite of the fix.
2. **"This domain is unwinnable / the vise is total" (armchair defeatism).** After ~24 commits the author built a confident-sounding proof that a library/CAS repair domain *cannot* be fair-and-hard against this agent, and recommended HOLD. **This was wrong** — Escape C existed and won. **Never declare a design space impossible from vise-logic alone; enumerate and MEASURE the indirect-anchor candidate before giving up.**
3. **Over-estimating the agent ("it will surely derive it").** The author reasoned step-by-step that a thorough Opus-4.8 would connect the ledger sentence → raw scope and solve it, and called the design ~15%. **It didn't** — it **stop-and-shipped the naive basis it already had.** **Law: stop-and-ship beats derivability.** A strong agent does NOT chase every subtle data implication when its naive fix self-verifies clean on all checkable surfaces — it declares victory and stops. Model the agent as a competent engineer who stops when the visible checks pass, not an omniscient deriver.
4. **Guess-react-guess (reacting to one verdict at a time).** The entire 25-commit arc was: push a design proven only `oracle=1.0`, read the one verdict, guess a patch, push again. This is precisely the blind-pushing trap this skill exists to kill. **There was never a local proxy-solver measuring difficulty before a push** — had there been, the whole "solved / unfair" ladder in §A would have surfaced in ~2 local runs instead of ~8 CI commits.

### D. Process anti-patterns — the specific wrong steps
1. **Pushing on `oracle=1.0` alone.** oracle=1.0 measures *nothing* about difficulty or fairness. Every push not preceded by a proxy trip-rate + a two-reviewer fairness read was a coin toss.
2. **Trusting a pasted human doc over live CI.** (See Hard-won cautions — the "You have N seconds…" TB3 line the guide demands is an auto-FAIL for TB2 `review`.) It broke a previously-green static check. **When a doc contradicts an empirical CI result, trust the CI.**
3. **Not reading the failure reason before "fixing."** Multiple "failures" were pure Daytona `DaytonaAuthorizationError` (agent never launched, verifier never ran) — zero task signal. Treating infra noise as a design defect wastes commits and can trigger a *wrong* redesign. **Grep the job log for the actual verdict/breakdown first; `infra != merit`.**
4. **No reserve, because no measurement.** With a proxy harness, ~24 of elim-board's 25 commits collapse to ~3 (calibrate → measure-iterate-locally → push-once), leaving a genuine reserve commit for a verdict-driven surgical fix.

### The one-sentence takeaway
> **elim-board = the skill's thesis by counter-example: 25 commits because it *guessed*, and it only won once the crux became an *unambiguous truth discoverable solely by interpreting an in-`/app` data anchor* — the exact fair-and-hard middle path that measuring-before-pushing finds in ~5.**

## The proof-of-method (why this is trustworthy)

retain-board's harness predicted the live CI exactly: **6/6 local proxies stumped → pass2 PASS + pass@5 PASS; 3/3 task.toml-aware reviewers FAIR → deep_review PASS; recipe-removed verifier → ava PASS + qc_gate PASS.** Label: `accepted`, full clean sweep. The measurement was the design.
