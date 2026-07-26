
# Dynamo CI gate — the complete field manual

Everything about getting a Dynamo PR to green: the pipeline, the three judges, the exact
gate math, verdict-reading, infra-vs-merit triage, the failure catalog from every commit of
two projects, and the playbook that clears it in one or two pushes. Companions:
`hard-task-craft` (design a stumping task), `verifier-hardening` (make the verifier
impenetrable), `dynamo-bots` (the agents' behavior), `dynamo-task` (build procedure). This
file is the one to open when you are **at the gate**, not designing.

---

## 0. The pipeline map — what runs, in what order, what gates what

On every push to the PR branch, one GitHub Actions workflow (`Dynamo Review`, triggered on
`pull_request_target` types opened/synchronize/reopened/ready_for_review — **not** on edits
to the PR title/body) runs these jobs **strictly in sequence**, each gating the next:

```
review  ->  similarity  ->  validation  ->  ratelimit  ->  pass2  ->  deep_review  ->  trials  ->  gate
(static+rubric) (dup)      (oracle/nop)   (slot)      (pass@2)   (LLM audit)    (pass@5)   (verdict)
```

Load-bearing facts about the order:
- **Each stage runs only if the previous passed.** A red `pass2` skips `deep_review`,
  `trials`, and reds `gate`. A red `deep_review` skips `trials`. So you never even reach the
  expensive pass@5 until difficulty (pass2) AND quality/anti-cheat (deep_review) are green.
- **The cheap filters run first.** Static + rubric + validation + a 2-trial difficulty
  pre-check + an LLM audit all gate before the 5×1-hour `trials`. Budget your pushes knowing
  a defect caught at `deep_review` costs ~1.5 h, not the full ~2.5 h.
- **`gate` is pure boolean AND.** Its script (observed verbatim):
  `if review=success AND similarity=success AND validation=success AND pass2=success AND
  deep_review=success AND trials=success -> label "accepted", else "needs-revision".`
  There is no partial credit and no human in this loop; the label is applied automatically.
- **Every push re-runs the whole thing from scratch** and cancels any in-flight run for the
  PR (`concurrency: cancel-in-progress`). NEVER push while a run you care about is live — you
  throw away its progress and a rate-limit slot.

Full pipeline wall-clock, healthy: ~2h15m–2h40m. Breakpoints: pass2 ~60–70m, deep_review
~4–5m, trials ~50–70m.

---

## 1. The three judges

### 1A. The static-checks bot (deterministic, `review` job, `<!-- dynamo-static -->` comment)
A fixed checklist — no LLM. It greps files and parses `task.toml`. What it enforces (all
must be green, they are cheap and non-negotiable):
- `task.toml`: all required metadata present, no placeholders, taxonomy labels valid, task
  slug <=3 tokens, `artifacts` a TOP-LEVEL array of the real output paths, timeouts within
  cap, gpu names canonical.
- `instruction.md`: absolute paths, <=1500 o200k tokens, output files documented.
- Dockerfile: approved base, no `COPY solution/`/`tests/`, `.dockerignore` present, pip
  pinned, apt hygiene (update + cleanup, no version pins), not CPU-pinned, no bare `nproc`.
- Verifier: `tests/` has `test_outputs.py` and `test.sh` runs it; reward written to
  `/logs/verifier/reward.txt` (not pre-created); nothing installed at verify time.
Failing it is always a mechanical fix; it never blocks on judgment. Fix and move on.

### 1B. The rubric + deep-review bot (LLM, `review` then `deep_review` jobs)
Two LLM passes, both from the SAME shipped rubric file (`references/dynamo-rubric.toml` in
the repo — read it; it is the exact 361-line checklist). The early `review` pass writes the
`<!-- dynamo-eval -->` verdict; the later `deep_review` writes `## Automated Review`
(`<!-- ...automated-review -->`) with a **Verdict: PASS/FAIL**, a **Blocking Issues** list
(each bullet ends with the concrete fix), and **Advisory Notes** (never block).
- It reads instruction<->tests 1:1 both ways (the historical #1 killer), the explanation
  fields against the actual verifier, similarity/uniqueness, and the full anti-cheat surface.
- **It is a per-run lottery.** It surfaces ~one blocking finding at a time and does not
  re-find what it missed last run. On restore-archive it passed anti-cheat twice, then on a
  later run flagged a golden-file-readable hole it had previously waved through. Corollary:
  fixing the finding it named does NOT guarantee the next run is clean — harden the WHOLE
  class, not the one instance (see `verifier-hardening`).
- **Human reviewers are stricter than this bot** (it says so itself). Passing it is
  necessary, not sufficient; write explanations a human can defend.

### 1C. Model A — the difficulty agent (`pass2` then `trials`, GPT-5.4 + Terminus-2)
The agent that actually attempts your task, on Daytona, at xhigh reasoning, budget =
`[agent].timeout_sec` (capped 3600s). `pass2` runs it **twice** (the difficulty pre-check);
`trials` runs it **five** times (pass@5, the real difficulty gate). Its invariant behavior,
seen in every trajectory across both projects:
1. Reads every file in `/app` before acting.
2. Treats any reference artifact (a statement, a digest, a sample) as an oracle to tie out
   against before submitting.
3. Implements the whole disclosed spec in one shot, usually flawlessly.
4. Forms hypotheses before coding where behavior is under-determined; recovers any
   named-family convention (orderings, standard matrices, standard curves) by guess-check.
5. On mismatch, enumerates rivals from named families and iterates until the oracle ties out.
6. Never reward-hacks, never refuses on a fair prompt; either finishes or times out.
What this means for you is the whole of section 4.

---

## 2. The gate arithmetic — the exact accept/reject math

### pass@2 (the `pass2` pre-check; must clear to proceed to deep_review/trials)
- Verdict comment: `## Pre-check (pass@2)` with a breakdown line:
  `X solved · Y valid-fail · Z task/verifier-issue · W in-progress-timeout · V infra-timeout · U unanalyzed`.
- **Passes iff >=1 VALID failure** ("plausibly hard, proceeding"). It explicitly tolerates a
  solve as long as one run is a valid fail (833f0dc had 1 solved + 1 unanalyzed and was
  "Blocked — rerun", but 22fc7da/6b38a55 had 0 solved + valid fails and passed).
- `Rerun Recommended: YES` means the result was inconclusive (an unanalyzed/errored trial),
  not that your task is wrong — re-trigger identical content.

### pass@5 (the `trials` job; the real gate)
- Verdict comment: `## Agent Trial Results`, breakdown:
  `X solved · Y good-valid-fail · Z soft-timeout-fail · ... · avg@5=N`.
- **Passes iff >=3 total fails AND >=1 GOOD valid fail** (stated verbatim in the gate step
  name: "Difficulty gate (>=3 fails total, >=1 valid fail)"). Timeouts COUNT toward the 3;
  only the one anchor must be a genuine finished-and-wrong (or stuck-with-valid-approach).
- Acceptance target: <=2 of 5 solves with an anchor. The accepted restore-archive scored
  **0/5 solved, 5 good-valid-fails, avg@5=0.000** — the ceiling.

### Valid vs invalid failure — the single most important distinction
Per-trajectory rubric rows (each PASS/FAIL): `task_specification, reward_hacking,
difficulty_crux, near_miss, refusals, low_timeout, approach_validity`.
- **VALID (counts, can anchor):** the agent FINISHED and was WRONG on a fair prompt — or was
  stuck on a wrong approach at timeout with `approach_validity` PASS. This is the only thing
  that advances a task.
- **INVALID (does not anchor, bounces the task):** `in-progress-timeout` (agent was
  progressing toward a solve, just slow — `low_timeout` FAIL), ambiguity (`task_specification`
  FAIL), reward-hacking, refusal, or a task/verifier defect (`approach_validity` FAIL).
- The trap this creates: a fair, fully-specified, tractable task gets SOLVED (invalid for
  us); make it merely bigger and it becomes an in-progress-timeout (also invalid). Neither
  advances. See section 4 for the escape.

---

## 3. How to read a verdict (the diagnostic loop — do this before changing one line)

The verdict comment is the richest signal in the loop; mine it every time.
```bash
# all sticky verdicts, newest content:
gh api repos/<org>/<repo>/issues/<pr>/comments --paginate \
  --jq '.[] | select(.body|test("Pre-check|Agent Trial Results|Automated Review|dynamo-static|dynamo-eval")) | .updated_at + "\n" + .body'
# job outcomes + timing for a run:
gh api "repos/<org>/<repo>/actions/runs/<run>/jobs" --jq '.jobs[] | .name+" | "+(.conclusion//.status)+" | "+((.completed_at//"-"))'
# pull the pass@ artifacts (per-trajectory trace, best-candidate values, manifest):
gh api "repos/<org>/<repo>/actions/runs/<run>/artifacts" --jq '.artifacts[] | (.id|tostring)+" "+.name'
# then download the zip, read trial.log / trajectory.json / result.json / exception.txt
```
What to extract, in order:
1. **Job table:** which stage reddened, and did later stages `skip` (dependency) vs `fail`.
2. **The breakdown line:** solved / valid / invalid split — this classifies the outcome.
3. **The per-trajectory rubric + Fail Reasons:** exactly how the agent beat (or missed) it —
   the approach it took, the values it reached, where it stopped. On restore-archive this told
   us every agent fixed the naive decode in its first steps and swept the wrong space.
4. **Golden-vs-agent value table:** how close the best wrong candidate was (e.g. matched the
   extreme_count exactly, off by 0.02 on means) — tells you if the trap fired as designed.
5. **For deep_review:** the single Blocking Issue and its prescribed fix, verbatim.

---

## 4. The difficulty wall — why fair tasks get solved, and the two ways through

This is the hardest and most important learning, proven across ~20 difficulty evaluations on
two projects. **Convention-recovery cannot stump this model.** Fairness forces the hidden
behavior to be recoverable from data the agent holds, and recovering rules from evidence by
guess-check is exactly what the model is superhuman at. Every "hide a weird convention"
design was solved, however exotic the rule.

The bimodal wall, stated crisply (7+ data points): the rubric bot and the solver read the
SAME spec. Making the crux clear enough to pass the rubric's UNAMBIGUOUS/fairness criteria
makes it clear enough for the solver to read and implement.
- fair + explicit + small  -> solved in 4–32 min (invalid for us).
- fair + explicit + big     -> in-progress-timeout (invalid for us).
- underivable               -> rubric-unfair (rejected).

**The two proven escapes — the only shapes that produced valid failures:**

### 4A. Remove the feedback gradient (cost-basis-reconcile)
Give the agent an evidence artifact it cannot decompose. Collapse per-item evidence to a few
AGGREGATE totals (v11: seven per-symbol lines -> four account-level totals). The answer stays
uniquely determined (prove it separately), but a wrong dial now shows up only as "the
aggregate numbers are off," with nothing isolating WHICH dial. With several entangled dials,
the agent must reconstruct the whole mechanism and match all aggregates at once — the
guess-check loop has nothing to descend on. Ten straight 2/2 solves flipped to 0/2.

### 4B. The engineered inversion / silent decoy (restore-archive)
Make the naive-but-natural reading reproduce EVERYTHING the agent can self-check, and fail
only on one hidden discriminator. restore-archive's winning move — the INVERSION: the true
decode is the wide-gamut film format's REAL piecewise "gamma 1.8" toe curve; the naive pure-
power reading (which every one of 7 trajectories locked in during its first steps) reproduces
every printed statistic — pooled means, std devs, the exact extreme count — and fails only the
SHA-256 of the raw bytes. So a completed search of the disclosed dials under the naive decode
ends at a statistics-perfect WRONG pipeline: the agent finishes confident and wrong = a clean
valid anchor. Result: 0/5 solved, 5/5 good-valid-fails.
- Why it is fair: the spec's "gamma 1.8" IS that format's customary label for the toe curve;
  the SHA is fully specified and decisively selects the truth; an expert disambiguates with
  two exact renders. The literal reader never meets the tie; only the SHA breaks it.
- The general principle: entangle the trap in a stage the agent believes the spec SETTLED,
  not in a disclosed unknown — it will re-search the unknowns forever while the bug sits in
  the "known" stage.

### What NEVER works (do not spend effort here)
Catalog conventions (any named-family rule), scale/tedium, obscure-but-documented knowledge,
rare languages, held-out generalization alone (its engines are genuinely general — keep
held-out data anyway, it defeats hardcoders for the anti-cheat gate), obfuscation/"confusing
English" (an invalid failure that bounces the task AND breaks the human-authorship
attestation), and ambiguity-as-difficulty (invalid failure -> rejection). Difficulty lives in
ARITHMETIC the agent must reconstruct, never in prose it can misread.

---

## 5. The failure catalog — every way both projects went red, and the fix

Classified so you can triage instantly: **INFRA** (not your fault — re-trigger), **MERIT**
(the task really failed — redesign), **QUALITY/ANTI-CHEAT** (deep_review finding — harden),
**PACKAGING** (static/rubric — mechanical fix).

| Symptom | Class | Root cause | Fix |
|---|---|---|---|
| `trials` fail ~49m; "Run agent trials" stuck in_progress; later steps never ran; logs BlobNotFound; sticky still shows the running placeholder | INFRA | Daytona/Azure runner lost mid-run | Re-trigger identical content; if no push budget, ask platform to "Re-run failed jobs" on the same commit |
| `pass2` fail with `Set up job \| failure`; "Failed to resolve action download info. Service Unavailable" | INFRA | GitHub-side outage before checkout | Check githubstatus.com; wait; re-trigger identical |
| `review` fail at "Stage 2 rubric review"; `<!-- dynamo-eval -->` = "could not complete... transient error or API budget issue. Push a new commit to re-run." | INFRA | The bot runs on Claude and the Claude API was degraded | Check status.claude.com (redirect target of status.anthropic.com; use `curl -L`); wait for "All Systems Operational"; re-trigger |
| `pass2` = "1 unanalyzed"; "Blocked — analysis incomplete. Rerun Recommended: YES" | INFRA | The analyzer crashed on one trajectory (tenacity/timeout), not a task defect | Re-trigger identical |
| pass@2 both `in-progress-timeout` (0 solved, 0 valid) | MERIT | Truth lived INSIDE the agent's search space; it was progressing, just slow | Redesign so a COMPLETED search ends wrong (4B), or remove the gradient (4A) |
| pass@2/5 SOLVED | MERIT | Fair + explicit + tractable | Apply 4A or 4B; no amount of "make it weirder" helps |
| deep_review FAIL: stale README describes a different task | QUALITY | Root README left over from a previous task iteration | Full-repo audit after every change (not just `task/`); rewrite to the current task |
| deep_review FAIL: golden render readable beside the input the agent's program is handed | ANTI-CHEAT | Verifier ran the artifact on the original path with the gold as a sibling | Isolate input to its own dir |
| (self-found) agent artifact can `glob('/tests/**/*_out.*')` at verify time | ANTI-CHEAT | Untrusted code runs in the verifier's context with `/tests` mounted | Load golds to memory, DELETE from disk before running the artifact, compare in RAM (`verifier-hardening` 2A) |
| static fail: instruction<->tests not 1:1 | PACKAGING | A tested requirement isn't stated, or a stated one isn't tested | One test per criterion, docstring names it; no extra checks |
| static fail: `artifacts` nested / wrong path / not top-level | PACKAGING | task.toml shape | Top-level `artifacts = [...]` of the real output paths |
| static fail: solution-file name appears in a test docstring | PACKAGING | Static greps docstrings for undocumented-output tokens | Never name solution files anywhere agent-visible or in tests |
| static fail: `allow_internet is true` / `environment.allow_internet=false; this benchmark requires internet access` | PACKAGING | This Dynamo/TB2 track **requires** `allow_internet = true` | Set `allow_internet = true` in `task.toml` — never "optimize" to false |
| rubric fail: shipped the platform "You have N seconds..." timeout line | PACKAGING | This repo's rubric FORBIDS it (repo rubric outranks platform docs) | Remove the line; repo rubric wins on any conflict |

---

## 6. Infra vs merit — the triage that saves commits (and your sanity)

When a check goes red, **diagnose the class BEFORE reacting.** The costliest mistake is
"fixing" a task that a dead runner failed. Decision procedure:
1. Pull the job table. Did the red job actually SCORE, or die in setup / stay in_progress /
   never upload logs? A job that never produced a verdict is INFRA.
2. Read the sticky. "could not complete", "Service Unavailable", "analysis incomplete /
   rerun", a still-present running placeholder -> INFRA.
3. Cross-check the status pages: githubstatus.com and status.claude.com (`curl -L`). A
   correlated incident window nails it.
4. Only if the job SCORED a real verdict (a breakdown line, a Blocking Issue) is it MERIT /
   QUALITY — then and only then change files.

**The re-trigger protocol (for INFRA):** do not touch content. Push an empty commit
(`git commit --allow-empty -m "Re-trigger CI: <the infra reason, honestly stated>"`) whose
message documents the outage, or ask the platform to "Re-run failed jobs" on the same commit
if you're out of push budget and have pull-only repo access. Then watch with an early
health-check: if the run concludes in <25 min it died in infra again; if it survives past the
point prior deaths occurred, the agents are really running. `validation` re-runs oracle=1.0
every push, so a container-specific problem fails SAFE there, before the expensive trials.

**Never** push to fix while a run is live (cancels it, burns a slot). **Never** make a task
harder in response to an infra death — content changes re-roll every already-won verdict.

---

## 7. The new-project playbook — clear the gate in one or two pushes

The whole point: front-load everything the gate checks so the first push is already green.

**Before the first push (all local):**
1. Design for a valid failure with 4A or 4B from the start — not "make it hard," but "make a
   completed agent search end wrong." If a senior engineer could name your trap from the
   proposal, the model names it too; the trap must live in reconstructable arithmetic.
2. Build in `dynamo-task` order (solve.sh -> Dockerfile -> tests -> instruction -> task.toml
   -> README).
3. **Prove uniqueness:** the intended answer is the ONLY one reproducing the visible evidence
   (full cross-product probe). If two combinations match, the task is ambiguous (invalid-fail
   trap) — add a discriminator and re-probe.
4. **Calibrate:** harbor oracle -> 1.0, nop -> 0.0, twice, repeatable.
5. **Run the impenetrability battery** (`verifier-hardening/battery.py`): every anti-cheat
   probe scores 0, oracle 1.0, leak scan clean. This pre-empts the deep_review lottery — the
   single biggest source of wasted commits.
6. **Full-repo audit** (`git ls-files`, not just `task/`): no file, PR title, or README from a
   previous iteration; stale-term grep clean; LF endings; task.toml parses; instruction<->
   tests 1:1; no answer or solution-filename token anywhere agent-visible; no personal info;
   no forbidden timeout line.
7. Confirm the built image is clean (leak scan) and `/app` is seed-only.

**Push, then watch — do not touch anything while it runs.** Expect the order in section 0;
the verdict lands in ~2.5 h. Watch for infra deaths (section 6) vs a real verdict.

**If it reds on a real verdict:** run the section-3 diagnostic loop, classify with the
section-5 catalog, apply the matching fix, re-run the FULL local battery on the exact new
state, then push. One clean diagnosis + the proof stack beats five hopeful pushes.

**The freeze rule:** once anything is pasted into a submission form, the repo is FROZEN — no
edits; a paste<->repo mismatch is a named rejection cause. Keep the branch at the accepted
commit.

---

## 8. The distilled cross-project lessons (the ten that mattered most)

1. **Take away the method, not the secret.** The model recovers any rule it can check a guess
   against; the only durable seam is removing the check (aggregate-only evidence) or making a
   completed search end wrong (the silent decoy). — both projects.
2. **The gate is sequential and AND-ed.** Clear the cheap filters and pass2 and deep_review
   before you ever spend a pass@5. Design so all three are green on push one.
3. **Only finished-and-wrong counts.** Solves and in-progress-timeouts both bounce a task;
   engineer the failure to be valid, don't just make the task big.
4. **deep_review is a lottery — harden the whole class.** It finds one thing per run and
   re-draws; fixing the named instance is not enough. Run the full anti-cheat battery so
   there is nothing left to draw.
5. **Any file the verifier can read, agent-planted code can read at verify time.** Ground
   truth must be absent from disk (deleted after load), not merely in a "separate" folder.
6. **Audit the WHOLE repo after every change**, root README and PR metadata included — a
   stale file from a prior iteration cost a whole commit.
7. **Triage infra vs merit before touching content.** Most red checks in a bad stretch are
   GitHub/Daytona/Claude outages; re-trigger identical, never redesign, never push mid-run.
8. **Prove, never guess.** Uniqueness cross-product + oracle/nop + wrong-solution proof +
   anti-cheat battery on the EXACT shipped state converts "I think it's right" into "I know."
9. **Repo rubric outranks platform docs** on any conflict (the forbidden timeout line is the
   canonical example).
10. **Persistence is the method.** cost-basis took eleven versions (ten straight 2/2 solves)
    to reach 0/2; restore-archive took a long chain of infra deaths and lottery findings to
    reach 0/5. Both ACCEPTED. Read every verdict, fix one diagnosed thing, re-prove, push
    again. The wall yields to diagnosis plus a proof stack, not to cleverness or luck.
