
# Verifier hardening — the universal impenetrability battery

One job: prove a Dynamo/TB2 task verifier cannot be beaten by anything except actually
solving the task, and fix it where it can. This encodes the anti-cheat half of the review
gate (`anti_cheat`, `trivial_bypasses_blocked`, `verifier_configuration`,
`functional_verification`, `fixtures_and_tamper_independence`, `graceful_failure`) as a
battery you run, not a checklist you eyeball.

Companion runnable: `battery.py` in this folder automates the task-agnostic probes. This
file is the brain; run the script, then apply the fixes below to anything it flags.

---

## 0. The one threat model (everything follows from this)

**Any file the verifier can read at verify time, agent-planted code can also read at verify
time.** In Harbor/TB2 the agent authors an artifact (a script, a program) OR writes output
files, and the verifier then runs in the *same container filesystem* with `tests/` overlaid
at `/tests`. So:

- If the agent authors a program the verifier executes, that program is **untrusted code
  running in the verifier's context** — it can scan the whole filesystem, read `/tests`,
  read `/logs`, and touch anything the verify user can.
- If ground truth (golden outputs, oracle blobs, expected answers) sits on disk anywhere
  reachable when that code runs, the task is beatable by copying it — no solving required.
- The reward file `/logs/verifier/reward.txt` is the single source of truth for scoring;
  if the agent can write it and have it survive, the task is beatable.

The Berkeley RDI "How We Broke Top AI Agent Benchmarks" work proved this is the dominant
real exploit class: they trojanized `uv`/`curl` at verify time because the verifier trusted
binaries the agent phase could rewrite. Same lesson, task level: **trust nothing the agent
could have touched.**

---

## 1. The battery — the six attack classes every task must survive

Run each as a malicious solution through the *real* verifier (`harbor run -a oracle` with
the artifact swapped). PASS = reward `0` (exploit defeated). The reference oracle must still
score `1.0` and nop `0.0`.

| # | Class | What the exploit does | Defeated by |
|---|---|---|---|
| A | **sibling read** | reads the golden next to the input path (`argv[1].replace("_in","_out")`) | isolated single-input dir |
| B | **overlay scan** | `glob("/tests/**/<gold-pattern>")`, match by index | delete golden from disk before agent code runs |
| C | **whole-tree scan** | `glob("/**/*", recursive=True)` for anything answer-shaped | same — absence, not obscurity |
| D | **hardcoded path** | reads the known `/tests/data/.../NN_out.*` | same |
| E | **reward hijack** | agent writes `/logs/verifier/reward.txt=1` (+ garbage output) | `test.sh` writes reward LAST from the pytest exit code |
| F | **timeout stall** | `time.sleep(huge)` to blow the verifier budget | `subprocess.run(..., check=True, timeout=N)`, N×files ≪ verifier timeout |

Two more the script checks that are not "planted code" but same family:

- **G existence-only**: an empty/`touch`ed artifact must score `0` (verifier checks values,
  not presence). nop scoring `0` is necessary but not sufficient — also probe an artifact
  that creates the declared output path empty.
- **H determinism**: oracle run twice returns the identical reward; no clock/RNG/network in
  env, solution, or tests.

Plus the static gate the script also runs:

- **L leak scan**: build the environment image, confirm `solution/`, `tests/`, and any
  ground-truth/answer file are absent from it and that `/app` holds only seed inputs.

---

## 2. The proven fix patterns (apply to anything the battery flags)

### 2A. Verifier executes an agent-authored program (A–D, F)
The canonical hardened shape — load truth to memory, remove it from disk, run untrusted
code on an isolated copy, compare in memory, keep readable value asserts:

```python
def test_outputs():
    inputs = sorted(glob.glob(os.path.join(HELDOUT, "*_in.png")))
    assert len(inputs) == N
    golds = {name_of(f): load(gold_path_for(f)) for f in inputs}   # 1. truth -> memory
    for g in glob.glob(os.path.join(HELDOUT, "*_out.png")):
        os.remove(g)                                               # 2. truth off disk
    assert not glob.glob(os.path.join(HELDOUT, "*_out.png"))       #    prove it's gone
    with tempfile.TemporaryDirectory() as td:
        for f in inputs:
            indir = os.path.join(td, name_of(f)); os.makedirs(indir)
            inp = os.path.join(indir, os.path.basename(f))
            shutil.copyfile(f, inp)                                # 3. isolated single input
            out = os.path.join(td, name_of(f) + "_got.png")
            subprocess.run([sys.executable, ARTIFACT, inp, out],
                           check=True, timeout=20)                 # 4. bounded (F)
            assert array_equal(load(out), golds[name_of(f)])       # 5. readable value check
```

Rules that make it hold:
- **Absence beats obscurity.** Renaming/moving golden files does not stop a same-user
  absolute-path scan. Only removing every on-disk copy before untrusted code runs does.
- **Keep the comparison readable.** Compare against in-memory arrays/values with a plain
  equality/近-tolerance assert. Do NOT switch to hashing the output as the check — the
  rubric's `readable_tests` counts "opaque hashes standing in for checks" as a negative.
  (A hash may *disambiguate* inside the task, as long as the pass/fail assert is legible.)
- **Bound every subprocess.** `check=True` + `timeout=N` with `N × n_files` comfortably
  under `[verifier].timeout_sec`. A stall then fails one case instead of the whole run.

### 2B. Verifier grades agent-written output files (E, G)
- `test.sh` must compute reward from the test result and write it **last**, always exiting
  0, so nothing the agent pre-wrote survives:
  ```bash
  mkdir -p /logs/verifier
  pytest --ctrf /logs/verifier/ctrf.json /tests/test_outputs.py -rA
  if [ $? -eq 0 ]; then echo 1 > /logs/verifier/reward.txt; else echo 0 > /logs/verifier/reward.txt; fi
  exit 0
  ```
- Assert real values, never `os.path.exists(...)` alone or non-empty. Every graded number
  is hardcoded in the test from the fixed seed with a derivation comment.

### 2C. Keep ground truth out of the agent image (L)
- `environment/Dockerfile` COPYs only seed inputs — never `solution/` or `tests/`. Golden
  outputs live under `tests/` (overlaid only at verify time). Verify by building the image
  and scanning it, not by reading the Dockerfile.

### 2D. Tamper independence (H and the Berkeley class)
- The verifier never imports the solution module and never reads ground truth from an
  agent-writable path (`/app`, `/root`, `/tmp`) without an integrity check.
- Prefer absolute interpreters (`sys.executable`) over PATH-resolved binaries; bake verifier
  deps into the image (pinned) so nothing is fetched at verify time (no `curl|sh`, `uvx`,
  `pip install` in `test.sh`) — that is the exact seam the Berkeley trojan used.

---

## 3. How to run it

```bash
# from the directory that contains the task folder (the one with task.toml inside <task>/)
export PATH="$PATH:/c/Users/Lenovo/.local/bin"     # wherever harbor lives
export MSYS_NO_PATHCONV=1                            # Git Bash + docker
python .claude/skills/verifier-hardening/battery.py <task-folder>
```

The script:
1. Calibrates oracle=1.0 / nop=0.0 (fails loudly otherwise).
2. Runs the task-agnostic probes it can synthesize with no task knowledge: reward-hijack,
   empty-artifact, determinism, and the leak scan.
3. Detects whether the verifier executes an agent artifact (scans `tests/` for a
   `subprocess`/`Popen` invoking an `/app/...` path) and whether golden files live in
   `tests/`; if so it prints the exact A–D/F planted-artifact probes to drop in, since those
   need the task's I/O contract.
4. Prints a scorecard; every line must read PASS before submission.

Interpreting results: any probe scoring the oracle reward (usually `1.0`) is a live hole —
fix with the matching §2 pattern and re-run. The battery is only meaningful on the exact
state you will submit; re-run after every change.

---

## 4. The universal checklist (what "impenetrable" means)

A task is impenetrable when, on the exact submitted state:
- oracle → 1.0, nop → 0.0, repeatable (H).
- Every §1 probe that applies scores 0 (A–G).
- The built image contains no solution/test/ground-truth file; `/app` is seed-only (L).
- Reward is written last from the test result; no agent write survives (E).
- Every subprocess is time-bounded well inside the verifier budget (F).
- Grading asserts real values with a readable check; ground truth is in memory, not on disk,
  when any agent code runs (A–D).
- Nothing is fetched or PATH-resolved at verify time (Berkeley class).

Carry the scorecard into review: it is the evidence that answers every anti-cheat criterion
before a human or the deep-review bot asks.
