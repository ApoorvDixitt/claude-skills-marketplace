---
name: dynamo
description: >-
  Complete Project Dynamo / Terminal-Bench 2 (TB2) task authoring system for Handshake AI
  fellowship work. Use this skill whenever working on ANY Dynamo-related task — claiming tasks,
  writing portal proposals, designing difficulty mechanisms, building task repos (solve.sh,
  Dockerfile, tests, instruction.md, task.toml), calibrating with Harbor (oracle/nop), hardening
  verifiers against agent cheating, reading CI verdicts, triaging infrastructure failures,
  pushing PRs, or submitting for review. Also trigger when the user mentions: dynamo, terminal-bench,
  harbor, task.toml, instruction.md, pass@2, pass@5, oracle, nop, verifier, deep_review, Model A,
  proposal, STRENGTHENING, FREEZE, garden path, stump the model, difficulty gate, anti-cheat,
  battery, proxy solver, trip rate, fairness, or any Dynamo task slug. This is the SINGLE entry
  point for all Dynamo work — it routes to the correct phase-specific reference automatically.
---

# Project Dynamo — Master Skill

This is the unified operating system for all Project Dynamo / Terminal-Bench 2 work. It detects
which phase of the workflow you are in and loads the precise reference needed — nothing more.

**How it works:** This file (always in context) contains universal rules, the phase-detection
router, and explicit pointers to `references/` files. Read ONLY the reference file indicated by
the routing table below. Do not load all references at once.

---

## 0. Phase Detection Router

Detect the user's current phase from their message, the files present, or the task context.
Then read the indicated reference file for detailed instructions.

| Signal in user message or context | Phase | Reference to read |
|---|---|---|
| "proposal", "claim", "portal", "Check Proposal Quality", "STRENGTHENING", "FREEZE", "paste" | Proposal authoring | `references/proposal.md` |
| "build", "solve.sh", "Dockerfile", "tests/", "instruction.md", "task.toml", "Phase C", "Phase D" | Task building | `references/task-build.md` |
| "push", "CI", "red check", "verdict", "review job", "pipeline", "re-trigger", "infra" | CI gate navigation | `references/ci-gate.md` |
| "automated review", "PASS verdict", "FAIL verdict", "blocking issues", "advisory notes", "deep_review" | Automated Review | `references/ci-gate.md` |
| "AVA", "verifier audit", "false accept", "false reject", "Major finding" | Verifier hardening | `references/verifier-hardening.md` |
| "QC", "task soundness", "Per-Check", "soundness checks", "probes" | CI gate navigation | `references/ci-gate.md` |
| "cheat-pass", "adversarial cheat", "can tests be gamed" | Verifier hardening | `references/verifier-hardening.md` |
| "common errors", "rejected", "why rejected", "flagged", "self-check", "before submit" | Common errors & self-check | `references/common-errors.md` |
| "difficulty", "stump", "hard", "garden path", "remove the gradient", "mechanism A/B", "pass@2 solved" | Difficulty design | `references/hard-task-craft.md` |
| "stump", "stumping patterns", "patterns A-I", "amplifiers", "make it hard", "how to stump" | Difficulty patterns | `references/hard-task-craft.md` |
| "Model A", "GPT-5.4", "Terminus-2", "agent behavior", "trajectory", "how it solved" | Bot behavior analysis | `references/bots.md` |
| "verifier", "anti-cheat", "battery", "impenetrable", "hardening" | Verifier hardening | `references/verifier-hardening.md` |
| "revision", "sent back", "reviewer feedback", "R1", "R2", "holding-rejection" | Revision workflow | `references/ci-gate.md` |
| "measure", "proxy solver", "trip rate", "fairness reviewer", "task.toml-aware", "blind pushing" | Measure-first method | `references/measure-first.md` |
| Starting a NEW task from scratch, "new claim", "which mechanism", "how to start" | Strategic overview | `references/master-playbook.md` |
| "file structure", "Harbor commands", "install harbor", "task categories", "payment" | Official rules lookup | `references/official-guide.md` |

**When multiple phases apply:** read the MORE SPECIFIC reference first (e.g., if pushing after
building, read `ci-gate.md` not `task-build.md`). If truly starting fresh, read
`master-playbook.md` first — it is the strategic map that points to everything else.

**When in doubt:** ask the user which phase they're in rather than loading the wrong reference.

---

## 1. Universal Hard Rules (apply in ALL phases — never violate)

These ten rules override everything. A violation in any one fails CI or review:

1. **Solution/tests NEVER in the agent image.** Verify by scanning the built image — not by
   reading the Dockerfile.
2. **Base image: approved list + `@sha256` digest pin.** Pin pip versions exact; do NOT pin apt.
3. **`instruction.md` format:** prompt-style, absolute `/app/` paths, every output file + schema
   disclosed, "what" never "how", ≤1500 o200k tokens. MUST end with the exact line: "You have N
   seconds to complete this task. Do not cheat by using online solutions or hints specific to
   this task." (N = `[agent].timeout_sec`). A static check (`check-instruction-suffix`) enforces
   this. Exception: only omit if your specific repo's `.dynamo/dynamo-rubric.toml` explicitly
   overrides this requirement.
4. **Verifier rules:** real-value assertions (never existence-only); reward to
   `/logs/verifier/reward.txt`; `ctrf.json` to `/logs/verifier/`; `test.sh` exits 0 always;
   no installs at verify time; deterministic; strict 1:1 with instruction (the #1 rejection cause:
   enforcing something the instruction never stated).
5. **`artifacts` = top-level array** in `task.toml` matching the real output paths.
6. **Pre-seeded `task.toml` fields untouched** (`category`, `subcategory`, `model_tested`,
   `agent_tested`). No personal info anywhere.
7. **Oracle 1.0 and nop 0.0, repeatable, before any submission.** No exceptions. Confirm
   `docker info` first (a down daemon makes harbor silently produce no jobs).
8. **A failure counts only if the model FINISHED and was WRONG on a fair prompt.** Timeouts,
   ambiguity, infra errors, and reward-hacking are all invalid. Design for "finished-and-wrong."
   Note: The "repo rubric outranks platform docs" principle was proven on one specific historical
   repo. For NEW tasks, always check your repo's `.dynamo/dynamo-rubric.toml` for the actual
   enforcement. The CURRENT platform default requires the timeout suffix line.
9. **Uniqueness is non-negotiable.** The visible evidence must pin exactly ONE answer. Prove with
   the cross-product rival probe (every plausible reading × every dial — exactly one match).
10. **Read before edit, always.** Never modify a file without reading it first. Never push while
    a CI run is live (cancels it, burns a slot).

---

## 2. The One Thesis (the strategic through-line)

A frontier model is superhuman at guess → check → correct. Give it any hidden rule it can verify
a partial guess against, and it recovers that rule. Fairness FORCES the answer to be recoverable
from agent-held data — which is the model's exact strength. So "hide a weird rule" NEVER works.

The only durable seams:
- **(A) Remove the gradient** — evidence the agent cannot decompose (aggregate-only).
- **(B) Garden path** — the naive reading self-verifies as COMPLETE on everything visible, and is
  wrong only on held-out data pinned by an in-data anchor.
- **(C) Indirect data anchor** — truth discoverable ONLY by interpreting an in-`/app` data
  invariant, not by reading any rule.

Default to mechanism B for new tasks. See `references/master-playbook.md` §3 for the decision tree.

---

## 3. Domain Selection (locks on claim — choose once)

**Best fit (garden-path-friendly):** imaging, video, rendering/graphics, finance/quant, feature
engineering (deterministic transforms), scientific numerics, custom codecs, security/VA
(authorization reachability boards).

**Refuse or avoid:** model training / distributed (nondeterministic, GPU, timeouts = invalid);
cryptanalysis (named-gotcha + unfair); build/release config (solves or ambiguous); pure file
search/rename (self-verifies against the visible tree).

---

## 4. The Named-Gotcha Veto

Apply to every candidate trap: if a senior engineer could NAME the trap from the proposal
("that's premultiplied-alpha", "that's NFC/NFKC", "biased-nonce ECDSA"), the model names it too
and applies the textbook fix. The trap must live in NAMELESS arithmetic the agent reconstructs,
never in a catalog convention it can enumerate.

---

## 5. Fairness Invariant

A failure is valid ONLY if you can point to something concrete — a sentence in the instruction,
a fact in the inputs — proving the agent's decision was wrong. Two gut-checks (both must be yes):
1. Would an expert seeing only what the model sees get it right?
2. Would that expert call the failure fair?

Either "no" → invalid → rejected. Design for the specific outcome "finished-and-wrong."

---

## 6. The ≤5-Commit Discipline

The difference between 20 commits and 4 is: **learn locally, push to confirm.**
- Anything you can learn locally (proof stack, proxy solver, anti-cheat battery), learn locally.
- CI is slow (~2.5h), slot-limited (~6/day), cancels on re-push. Your laptop is free and instant.
- Pick the mechanism and domain RIGHT THE FIRST TIME from the §3 decision tree.
- Run the ENTIRE proof stack before pushing (see `references/master-playbook.md` §9).
- Push once. Watch for infra vs merit. Expect the gate in ~2.5h.

---

## 7. Voice & Ownership Standards (all prose)

- Plain and specific. Real values, real paths, real counts. Vary sentence length naturally.
- Ban: delve, robust, leverage, intricate, testament, furthermore, moreover, "it's important to note."
- No hedging, no throat-clearing, no marketing tone. Every sentence earns its place or dies.
- Never fabricate numbers — paste only output from runs actually executed.
- Before delivering prose: "could the user defend this line under a reviewer's question?" If not, cut.
- Quality, specificity, and genuine verification pass review — no shortcut through disguise.

---

## 8. Environment Quirks

### All platforms
- **Docker Desktop must be running** — confirm `docker info` first. A down daemon makes harbor
  silently produce no jobs (looks like a pass).
- Push to the **FORK** remote (origin is pull-only, 403). Never push while eval runs.
- After anything is pasted into a submission form, the repo is **FROZEN** — no edits.

### macOS
- harbor installed via `uv tool install harbor` — available at `~/.local/bin/harbor`.
- Python is `python3` (system) or managed by `uv`.
- No path conversion issues.

### Windows (Git Bash)
- **harbor** at `C:/Users/<username>/.local/bin` — add to PATH per shell.
- **`export MSYS_NO_PATHCONV=1`** before any `docker run ... /bin/bash` (Git Bash path mangling).
- Host python may be **`python`** not `python3`; use `python -m uv` if bare `uv` is missing.

### Linux
- harbor installed via `uv tool install harbor` — ensure `~/.local/bin` is in PATH.
- May need `sudo usermod -aG docker $USER && newgrp docker` for rootless Docker.

---

## 9. What NEVER Works (do not re-explore)

Each of these cost real commits and was proven ineffective:

- Catalog conventions (named-family rules: orderings, standard matrices/curves, apportionments)
- Reconstruction-from-a-report in fast-eval domains (agent grid-searches + verifies → solved)
- Scale/tedium/long-horizon (makes agent slow, not wrong; timeouts = INVALID)
- Held-out generalization alone (model's engines are genuinely general)
- Obscure-but-documented knowledge, rare languages (all defeated)
- Obfuscation / "confusing English" / ambiguity as difficulty (invalid + rejected)
- Disclosed formulas (transcribed = solved)
- Self-check oracles (zlib success, readable plaintext → easy solve path)

---

## 10. Reference File Index

Each reference is a self-contained deep-dive. Read the one matching your current phase:

| File | Contents | When to load |
|---|---|---|
| `references/master-playbook.md` | Strategic thesis, two mechanisms, decision tree, proof stack, per-project ledger, ≤5-commit sequence | Starting a new task; strategic decisions |
| `references/ci-gate.md` | 10-stage pipeline map, Automated Review walkthrough, AVA/QC/Cheat-Pass gates, gate arithmetic, verdict reading, infra-vs-merit triage, failure catalog, re-trigger protocol, revision workflow | About to push; red check; reading verdicts; revision feedback |
| `references/common-errors.md` | Five rejection reasons, self-check checklist, fairness gut-check, red flags | Before submit; after rejection; self-review |
| `references/bots.md` | Review bot layers, Model A behavior/loop/strengths/weaknesses, fairness constraints | Designing difficulty; understanding why something solved |
| `references/measure-first.md` | Proxy-solver harness, task.toml-aware reviewer, the vise + escapes, anti-patterns, ≤5-commit sequence | Before first push; stopping blind iteration |
| `references/proposal.md` | Pre-paste funnel, paste skeleton, STRENGTHENING triage, failure ledger, ACCEPT journey, checklist | Writing/revising portal proposals |
| `references/task-build.md` | Phases A–G, four-axis defect sweep, build order, calibration, difficulty strategies, three-pass audit, submission | Building the actual task repo |
| `references/hard-task-craft.md` | Design principles, v1→v11 case history, certainty system, mistakes ledger, diagnostic loop, reusable playbook | Designing the stump; after a 2/2 solve |
| `references/verifier-hardening.md` | Threat model, six attack classes, fix patterns, battery procedure, impenetrability checklist, AVA pre-emption | Near submission; AVA/deep_review findings; anti-cheat |
| `references/official-guide.md` | Official rules (file structure, Harbor CLI, schemas, submission checklist, payment) | Rules lookup; format questions |

---

## 11. Operational Workflow (the default sequence for a new task)

1. **Claim** → read `references/master-playbook.md` for mechanism selection
2. **Proposal** → read `references/proposal.md` for portal one-shot
3. **After ACCEPT** → read `references/task-build.md` for build order
4. **Difficulty design** → read `references/hard-task-craft.md` + `references/bots.md`
5. **Local measurement** → read `references/measure-first.md` for proxy harness
6. **Verifier hardening** → read `references/verifier-hardening.md` for battery
7. **Pre-push** → read `references/ci-gate.md` for pre-push playbook
8. **After verdict** → read `references/ci-gate.md` §3 for diagnostic loop
9. **Submit** → freeze repo; no edits after paste

This is the golden path. Jump to any step based on where you actually are.
