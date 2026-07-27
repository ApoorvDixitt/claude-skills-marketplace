
# Project Dynamo task skill

You are working on the user's Project Dynamo fellowship work (Terminal-Bench 2 task
authoring for Handshake AI). The stakes: reviews are effectively one-shot, tasks are
graded by automated LLM checks AND human reviewers, and the user's pay depends on
first-pass acceptance. Precision beats speed everywhere.

**Deep reference (read it when detail is needed):** `references/official-guide.md` — the
verbatim platform rulebook. This file is the operating procedure; that one is the rules.
**Session memory:** check the memory directory for `dynamo-*` and `project-dynamo-*`
files — they carry the current status of in-flight tasks and past decisions.

---

## Phase A — Analyze before anything

1. Inventory what you were given: `find <task-dir> -type f`. Read EVERY file completely
   before proposing or changing anything (task.toml, instruction.md,
   environment/Dockerfile + data, solution/, tests/, README, .dynamo/ if present).
2. Classify the situation and branch:
   - **Quiz / training assessment** → answer strictly from the assessment's own panels;
     explain why each wrong option is wrong. Where materials conflict on numbers, the
     CURRENT assessment's own text wins (the live bar is pass@5: ≥3 fails of 5).
   - **Broken-task repair** → run the four-axis defect sweep (Phase B), fix, calibrate,
     audit, submit.
   - **New task authoring** → proposal gate FIRST (write no code until it passes). Read
     `references/proposal.md` and follow its one-shot portal checklist before any paste;
     then design the stump (Phase E), then build in Phase C order.
   - **Revision after review feedback** → address every reviewer point explicitly before
     anything else; revisions outrank new work.
3. Check the environment (see Phase G and `SKILL.md` §8 for per-OS specifics).

## Phase B — The four-axis defect sweep (for repairs and self-review)

Check each axis and name what would wrongly pass or fail:

| Axis | What breaks Harbor format |
|---|---|
| **Format** (`task.toml`) | `artifacts` not a top-level array, or path ≠ what the task writes; missing metadata fields; edited pre-seeded fields (`category`, `subcategory`, `model_tested`, `agent_tested`); forbidden fields (`tags`, `schema_version` — `avg_at_8` was fully removed); personal info |
| **Environment** (Dockerfile) | unpinned/floating base (`:latest`, bare tag) — must be an approved base pinned by `@sha256` digest; solution or tests COPYed into the image (leak); unpinned pip; missing `mkdir -p /app`; deps only the oracle needs |
| **Verifier** (`tests/`) | asserts existence/non-empty instead of real values; reward written anywhere but `/logs/verifier/reward.txt`; no `ctrf.json`; verify-time installs; reads ground truth from an agent-writable path without hardcoding/integrity-check; byte-exact serialization demands; nondeterminism |
| **Instruction** | vague ("save your findings"); no absolute `/app/...` paths; output file/schema unnamed; requirement enforced by tests but never stated (THE #1 rejection cause); answer leaked (including in an example value!); missing the exact final line `You have N seconds to complete this task. Do not cheat by using online solutions or hints specific to this task.` with N = `[agent].timeout_sec` |

## Phase C — Build order (author or fix)

1. `solution/solve.sh` → thin wrapper calling `solution/solve.py`; writes absolute
   `/app/...` outputs; zero installs; genuinely computes (never hardcodes the answer).
2. `environment/Dockerfile` → approved digest-pinned base; pinned test deps
   (`pytest==8.4.1 pytest-json-ctrf==0.3.5`); `RUN mkdir -p /app`; COPY only seed
   inputs; NEVER solution/tests.
3. `tests/test_outputs.py` + `tests/test.sh` → strict 1:1 with instruction.md: one test
   per success criterion, each docstring NAMES the criterion it verifies; no missing, no
   extra checks. Expected values hardcoded (derived from the fixed seed — tamper-safe)
   with a comment showing the derivation. `test.sh`: `mkdir -p /logs/verifier`, run
   pytest with `--ctrf /logs/verifier/ctrf.json`, write `1`/`0` to
   `/logs/verifier/reward.txt`, ALWAYS `exit 0`.
4. `instruction.md` → prompt-style, no headers/roleplay; absolute paths; every output
   file + exact format/keys/types disclosed; "what" never "how"; ≤1500 tokens; example
   values must NOT equal the real answer; MUST end with the exact line: "You have N seconds
   to complete this task. Do not cheat by using online solutions or hints specific to this
   task." (N = `[agent].timeout_sec`; enforced by `check-instruction-suffix` static check).
5. `task.toml` → `artifacts` array above first section matching the real outputs;
   best-fit snake_case `task_objective`/`artifact_type`; plain, specific
   `difficulty/solution/verification_explanation` that match the actual verifier.
6. `README.md` → short description: task, environment, verification, calibrate commands.

## Phase D — Empirical calibration (never skip, never trust inspection alone)

```bash
# Run from the task/ directory inside your repo
harbor run -p . --agent oracle    # MUST -> reward 1.0
harbor run -p . --agent nop       # MUST -> reward 0.0 (reward < 1.0)
```

- Results land in `jobs/<timestamp>/<task>__<id>/verifier/{reward.txt,ctrf.json,test-stdout.txt}`.
- **Leak scan** (rebuild agent image yourself and search it):
  ```bash
  export MSYS_NO_PATHCONV=1
  docker build -t audit:check <task>/environment/
  docker run --rm audit:check /bin/bash -lc 'find / \( -name "solve.*" -o -name "test*.py" -o -name "test.sh" \) 2>/dev/null'   # expect empty
  docker run --rm audit:check /bin/bash -lc 'ls /app'                                # expect seed files only
  docker rmi audit:check
  ```
- **Wrong-solution proof**: introduce a one-line bug in solve.py (e.g. `total + 1`),
  re-run oracle → expect reward 0 with the SPECIFIC value test failing; revert; re-run
  → reward 1; then `diff` solve.py against the pristine copy to confirm byte-identical.
- **Repeatability**: run the oracle+nop pair at least twice; same reward every time.
- Independently recompute expected values from the seed data with a throwaway script —
  never trust remembered numbers.

## Phase E — Difficulty craft (authored tasks only)

**The bar (pass@5):** The agent must fail at least 3 of 5 attempts. Acceptance band:
0–2/5 accepted, 3–5/5 rejected. Reference model: GPT-5.4 + Terminus-2 at xhigh reasoning.
A 0/5 with valid failures is the strongest result (fully stumped). Failures count only if
the model FINISHED and was WRONG on a fair prompt — timeouts, infra errors, and ambiguity
are invalid and get the task sent back. The 3600s timeout ceiling applies to all tasks.

**The one idea**: the task must make the model **confidently wrong** — obvious solution
runs clean, output looks right, model commits. NOT: obscure knowledge, rare languages,
tedium, or timeout pressure. **The named-gotcha test**: if a senior engineer could say
"oh, that's the X bug/attack" from the proposal, the model names it too and applies the
standard fix → redesign. Never put the trap's name in the instruction.

Five delivered strategies (combine 2–3):
1. **Silent trap** — naive approach completes without error, output believable; wrongness
   visible only by understanding what the output should MEAN. Nothing may throw.
2. **Specified-but-never-exemplified** — seeds that the naive reading reproduces 100%;
   grade on cases the instructions fully determine but the seeds never show. The
   instructions NEVER lie; every graded case must be unambiguously derivable from them.
3. **No oracle** — remove every self-check: no reference binary that prints answers, no
   doc stating the rule, nothing that flags which inputs are affected.
4. **Compound corrections** — several independent fixes overlapping on the same records;
   fixing some-but-not-all still fails (all-or-nothing).
5. **Exact grading** — tolerance justified from the problem: wide enough for every
   valid interpretation, tight enough that the requirement-violating method lands
   outside (e.g. valid spread 0.002, wrong method off 0.15 → band 0.02).

Fairness gut check: would a human expert, seeing only what the model sees, get it right
AND call the failure fair? Both yes → good trap. Also see guide §8 patterns A–I.

## Phase F — Three-pass final audit (before ANY submission)

1. **Structure & hygiene**: exact file inventory (no strays, no `jobs/`, no caches);
   all files LF (`grep -rlUP '\r' .` → empty); seed data byte-identical to original
   (repairs); no personal info (`grep -rniE "name|@gmail|<username>"`); no answer
   string in any agent-visible file.
2. **Consistency & schema**: parse task.toml with tomllib and assert every field rule;
   verify the instruction's final line char-exact and N == `[agent].timeout_sec`;
   map every test ↔ instruction criterion both directions; **if answers were pasted
   into a form, diff pasted blocks against repo files — they must be byte-identical.**
3. **Empirical fresh**: rebuild image + leak scan + fresh oracle/nop pair on the exact
   final state. Report rewards and per-test pass/fail from ctrf.json.

**After anything is pasted into a submission form, the repo is FROZEN. No edits — a
paste↔repo mismatch is a named rejection cause.**

## Phase G — Submission mechanics

- Push ONLY the task folder (never `jobs/`, SUBMISSION.md, or run logs).
- Work on the `submission` branch: `git checkout -b submission`.
- Push to your fork: `git push -u origin submission`.
- Open PR: `gh pr create --repo handshake-project-dynamo/<your-task-repo> --fill`.
- Iterate: `git add -A && git commit -m "Address review feedback" && git push`.
- The checks re-run on every push and update their PR comments in place.
- Scripts as 644 are fine — Harbor invokes via bash.
- **After anything is pasted into a submission form, the repo is FROZEN — no edits.**
- Answering form fields: give ONLY the paste-ready block; keep explanations outside.

Cross-platform: see SKILL.md §8 for Docker/harbor path specifics per OS.

## Voice & ownership standards (all prose: explanations, README, PR text, answers)

The project's AI policy: task descriptions and solutions are human-written/verified;
boilerplate may be assistant-drafted but the USER must verify and be able to defend
every line. Write so that's true:

- Plain and specific. Real values, real paths, real counts — never abstractions where
  a number exists. Vary sentence length naturally; read it aloud once.
- Ban stock filler: delve, robust, leverage, intricate, testament, furthermore,
  moreover, "it's important to note". Prefer colons over em-dash chains.
- No hedging padding, no throat-clearing, no marketing tone. Every sentence earns its
  place or dies.
- Never fabricate anecdotes, experiences, or results. All claimed numbers must come
  from runs actually executed in the session (paste real output, never synthesize it).
- Before delivering prose the user will submit, re-read it asking: "could the user
  defend this line under a reviewer's question?" If not, cut or fix it.
- Quality, specificity, and genuine verification are what pass review — there is no
  shortcut through laundering or disguise, so never spend effort there.

## Hard-rule quick card (violating any of these fails CI or review)

1. Solution/tests NEVER in the agent image (verify by scanning the built image).
2. Base image: approved list + `@sha256` digest pin. Pin pip exact; don't pin apt.
3. `instruction.md` ends with the exact timeout line; N == `[agent].timeout_sec`.
4. Verifier: real-value assertions; reward.txt + ctrf.json to `/logs/verifier/`;
   test.sh exits 0; no installs; deterministic; 1:1 with instruction.
5. Verifier must not enforce ANYTHING the instruction doesn't state (the #1 killer:
   undisclosed literals, naming schemes, tie-breaks, dedup rules).
6. `artifacts` = top-level array of the real output paths.
7. Pre-seeded task.toml fields untouched; no personal info anywhere.
8. Oracle 1.0 and nop 0.0, repeatable, before any submission — no exceptions.
