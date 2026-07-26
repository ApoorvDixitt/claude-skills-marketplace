# Project Dynamo — Complete Reference

> Personal offline archive of the Project Dynamo fellow documentation.
>
> - **Source:** <https://project-dynamo.learn.joinhandshake.com/> (authenticated)
> - **Captured:** 2026-07-26
> - **Pages:** 52 of 52
> - **Content:** ~259,173 characters
>
> Collapsed navigation groups and in-page accordions were expanded before
> capture, so answers/panels hidden behind toggles are included.

---

## Table of Contents

- [Project Dynamo](#project-dynamo)
- [Introduction](#introduction)
  - [Getting started](#getting-started)
  - [Overview of the task](#overview-of-the-task)
  - [Roles & Progression](#roles-progression)
  - [Task categories](#task-categories)
  - [Updates](#updates)
- [Task file structure](#task-file-structure)
- [Getting started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Install harbor](#install-harbor)
  - [Harbor commands](#harbor-commands)
  - [Calibration loop](#calibration-loop)
- [Creating a task](#creating-a-task)
  - [1 · Claim a task](#1-claim-a-task)
  - [2 · Write the proposal](#2-write-the-proposal)
  - [3 · Fork & Set up the repo](#3-fork-set-up-the-repo)
  - [4 · Author solve.sh](#4-author-solvesh)
  - [5 · Write the tests](#5-write-the-tests)
  - [6 · Build the dockerfile](#6-build-the-dockerfile)
  - [7 · Write instruction.md and task.toml](#7-write-instructionmd-and-tasktoml)
  - [Validate & Submit](#validate-submit)
- [Task workflow videos](#task-workflow-videos)
- [Submitting the pr](#submitting-the-pr)
  - [Understanding pass@ & Timeouts](#understanding-pass-timeouts)
  - [Final checklist](#final-checklist)
  - [Open your pr](#open-your-pr)
  - [Submit on the platform](#submit-on-the-platform)
- [How to stump the model](#how-to-stump-the-model)
  - [Why tasks get rejected](#why-tasks-get-rejected)
  - [Amplifiers & Fairness](#amplifiers-fairness)
  - [Live examples](#live-examples)
  - [Update log](#update-log)
- [Reviewer guide](#reviewer-guide)
  - [Reviewer guide](#reviewer-guide)
  - [Judgment areas, valid failures, and the verdict](#judgment-areas-valid-failures-and-the-verdict)
  - [Scoring — Checkboxes and the 1–5 Score](#scoring-checkboxes-and-the-15-score)
  - [Recording your review in hai](#recording-your-review-in-hai)
- [Common errors and examples](#common-errors-and-examples)
  - [Flags & Fixes](#flags-fixes)
  - [Pass AVA](#pass-ava)
  - [Before you submit](#before-you-submit)
  - [Audit the requirements](#audit-the-requirements)
  - [Don't expose the answer](#dont-expose-the-answer)
  - [Your docs must be true of the data](#your-docs-must-be-true-of-the-data)
  - [The rules were wrong, and the checker was blind](#the-rules-were-wrong-and-the-checker-was-blind)
- [FAQ](#faq)
  - [First task quick start guide](#first-task-quick-start-guide)
  - [The essentials](#the-essentials)
  - [Task access](#task-access)
  - [Time tracking for payment](#time-tracking-for-payment)
  - [Getting paid](#getting-paid)

---

---

## Project Dynamo

<sub>`/` · nav label: *Welcome* · [source](https://project-dynamo.learn.joinhandshake.com/)</sub>

Project Dynamo is how fellows build tasks for **Terminal-Bench 2 (TB2)** - the second-generation benchmark for evaluating coding agents in real terminal environments. This site is the end-to-end reference for writing a task: the file structure every task repo needs, how to set up the tooling, and every step from scaffolding through a passing pull request.

Keep it open alongside your task repo as you work.

### What you can earn

You get paid two ways: an hourly base rate for the time you put in, received when you submit a task plus a bonus every time a task reaches Ready-to-Deliver (RTD). The bonus stacks on top of your hourly pay — so the faster you land approved tasks, the higher your effective hourly climbs.

United States

$10 / hr base

+ $120 per task at RTD

UK · AUS · CANADA

$8 / hr base

+ $100 per task at RTD

India

$5 / hr base

+ $80 per task at RTD

LATAM

$5 / hr base

+ $80 per task at RTD

How the bonus stacks

Every task that reaches RTD adds its bonus on top of the hours you logged. For example, a US fellow who delivers a task in 10 hours earns **$100 base + a $120 RTD bonus = $220 for that task** — an effective **$22/hr**. Hours are illustrative and vary by task; the point is that each delivered task pulls your effective rate well above the base.

Before you get started

This project requires experience using both GitHub and the Terminal.

If you do not have experience with these tools, you're still welcome to attempt the assessment. Because this project is paid per approved task, your earnings will depend on both the quality of your work and the number of tasks that are approved.

If you do not feel comfortable completing the assessment or participating in the project, select **Support** in the upper right corner of your Handshake AI dashboard to request removal.

### The task pipeline

1

##### Task attempt

You author the task end-to-end on a `submission` branch of your forked task repo.

2

##### R1 - First human review

A reviewer does one of three things: **accepts** the task (on to R2), sends it back for ***revision**, or — if it's irreparable — drops it to **Holding-Rejection**, in which case you start a new task.

3

##### R2 - Second human review

A second reviewer confirms the task, or sends it back.

4

##### Bonus - Ready to deliver

The task is accepted and the bonus stacks on your base rate.

Expect a 36–72 hour1 turnaround to hear whether your task has reached Ready to Deliver (RTD)2.

1.Measured from when you submit — plan around days, not minutes.

2.RTD = accepted and bonus-eligible. The finish line for a task.

Tasks may be sent from R1 or R2 back to the author for edits before they can be accepted. The task bonus stacks on the base rate, so the faster you land valid tasks, the higher your hourly rate climbs.

Why the rate changed

We increased the time allotted per task to account for the time it takes to run the pass@ evaluations and the other GitHub checks. With that larger time budget, the hourly rate has come down from its previous level to offset the longer time budget — and the acceptance bonus is unchanged.

*Revise sent-back tasks before starting new ones

If R1 or R2 sent tasks back to you for edits, revise those before picking up a new task. A task that has already cleared part of review is much closer to acceptance — and the bonus — than a brand-new one, so revisions are the higher-probability path to approval.

### The revision pipeline

Approved at any review along the way? The task continues to Ready to deliver — the path below is only what happens if revisions run out.

1

##### Sent back — R1 or R2

The reviewer returns your task with feedback on what to fix.

2

##### Revision 1

You revise and it goes back for re-review.

3

##### Revision 2

One more revision and re-review — this is your last attempt.

4

##### Holding-Rejection

If it's still not approved after the second revision, the task is dropped and you start a new one.

When a task goes to Holding-Rejection

A task is moved to **Holding-Rejection** — stop working on it and start a new one — in either of the following situations:

1. A reviewer determines the task is not salvageable during the initial review.
2. The task is still not approved after two revisions, which is the maximum number of revisions allowed per task.

If your task reaches the two-revision limit, it means both the R1 and R2 reviewers determined it is not salvageable. At that point, the estimated effort required to fix it exceeds 10 hours. Rather than continuing to invest time in that task, we recommend reviewing the instructions document, applying what you've learned, and picking a new task.

---

## Introduction

<sub>`/introduction` · nav label: *Get oriented* · [source](https://project-dynamo.learn.joinhandshake.com/introduction)</sub>

### What a task is

A task is a self-contained challenge that runs inside a Docker container. You author a few things, and together they let the benchmark score any agent deterministically:

- **`instruction.md`** - the only thing the agent sees at runtime. It states the problem, pins absolute paths, and lists success criteria the agent can verify on its own.
- **`solution/solve.sh`** - the golden reference solution. Keep the real logic in a helper (e.g. `solution/solve.py`) that `solve.sh` calls; write outputs to absolute `/app` paths.
- **`tests/`** - `test.sh` plus `test_outputs.py` (pytest), which run after the agent finishes and score its output. pytest and its plugins are baked (pinned) into the single `environment/Dockerfile`; `test.sh` installs nothing. `tests/` is added only at verify time and is not present during the agent run.
- **`environment/Dockerfile`** - the task's single image, built once and reused for both the agent run and the verifier run. It never contains the solution or the tests.
- **`task.toml`** - the machine-readable manifest: identity, environment limits, verifier mode, metadata.

### Harbor

**Harbor** is the CLI you'll use throughout. It builds the single task image, runs it, and writes the reward. Point it at a task path: `harbor run -p . --agent oracle` (run from the `task/` directory).

### How a task is scored

The agent works in `/app` with only `instruction.md` and the seed files. When it stops, the verifier runs `tests/test.sh`, which runs pytest and writes `reward.txt` (`1` or `0`) and `ctrf.json` to `/logs/verifier/`. Two rules make that score trustworthy:

- **The agent never sees the golden solution or the tests.** They live in the repo for development and review, but baking them into the agent image invalidates the task.
- **Success is measured from observable artifacts** - files on disk, exit codes. Anything that lives only in stdout or vanishes when the run ends cannot be scored.

### From fork to pr

The work is a loop, not a hand-off:

1. **Set up** your environment: Docker, `uv`, Harbor, and fork your assigned task repo from `handshake-project-dynamo`. See [Setup](/setup).
2. **Build** the task on the `submission` branch through the [workflow](/workflow) — author `solve.sh`, write the tests, build the Dockerfile, write `instruction.md` and `task.toml`.
3. **Calibrate locally** with Harbor from the `task/` directory. Both checks must pass: `harbor run -p . --agent oracle` scores **reward 1.0**, and `harbor run -p . --agent nop` scores **reward < 1.0**. Clear this bar before opening a PR.
4. **Open a pull request** from your fork back to `handshake-project-dynamo/<your-task-repo>` and iterate on the automated feedback. See [Submitting the PR](/submit).

### Who this guide is for

Fellows working to create Terminal-Bench-style tasks. Read it end-to-end before writing any code, and use it as a reference between steps.

### Getting started

<sub>`/getting-started` · section: **Get oriented** · [source](https://project-dynamo.learn.joinhandshake.com/getting-started)</sub>

Complete these three steps before you claim a task.

#### 1. Join the slack channels

You'll receive an email invite to the Handshake AI Fellowship Slack workspace. Join and bookmark both channels:

- **dynamo-tasking** — a collaborative space to ask questions and engage with the community of fellows.
- **dynamo-announcements** — for announcements from the project team.

#### 2. Join project dynamo on the annotations platform

You'll receive an email to join Project Dynamo. Click **View Project**, create a Handshake account if needed, then follow the steps to set up a Stripe account for payouts.

Off-platform work

The project runs mostly off-platform, but you need to join to link everything in the system.

[Open Annotations Platform](https://ai.joinhandshake.com/fellow/projects)

#### 3. Complete the project assessments

Before starting, you'll complete:

- A 60–90 minute software engineering assessment that you must pass.

#### 4. Time tracking

All time is tracked through the Handshake platform. Open your claimed task **before** you start working — this begins tracking. Don't leave it running while idle. The 8-hour cap per task covers all time on a task, including revisions. If your first pass is approaching 7 hours, flag it to the team.

### Overview of the task

<sub>`/overview` · section: **Get oriented** · nav label: *Overview* · [source](https://project-dynamo.learn.joinhandshake.com/overview)</sub>

At a high level, authoring a task is a fork → branch → implement → push → PR loop against the upstream template repo. The commands below are the full shape of that loop - each step in this guide fills in the `... implement the task ...` middle.

```
gh repo fork handshake-project-dynamo/dynamo-<repo_id>-<domain> --clone
cd dynamo-<repo_id>-<domain>/task
git checkout -b submission
#  ... implement the task (see below) ...
git add -A && git commit -m "Task submission"
git push -u origin submission
gh pr create --repo handshake-project-dynamo/dynamo-<repo_id>-<domain> --fill
```

#### What each command does

- **`gh repo fork ... --clone`** - forks the template repo to your GitHub account and clones your fork locally. You always work from a fork, never directly on the upstream repo.
- **`cd dynamo-<repo_id>-<domain>/task`** - moves into the `task/` directory inside the freshly cloned repo so the rest of the commands run in the right place.
- **`git checkout -b submission`** - creates a new branch named `submission` off the default branch. All your task work lives here; `main` stays clean.
- **Implement the task** - this is the bulk of the work covered by the rest of this guide: scaffold the repo, write `solve.sh`, the tests, the Dockerfile, `instruction.md`, and `task.toml`, then calibrate locally.
- **`git add -A && git commit ...`** - stages every file you touched and records the work as a commit on the `submission` branch.
- **`git push -u origin submission`** - pushes the branch to your fork on GitHub and sets it as the upstream so future `git push` calls just work.
- **`gh pr create --repo ... --fill`** - opens a pull request from your fork's `submission` branch into the upstream template repo, using your commit messages to fill the title and body.

#### Task walkthrough

Task walkthrough

### Roles & Progression

<sub>`/roles` · section: **Get oriented** · nav label: *Roles* · [source](https://project-dynamo.learn.joinhandshake.com/roles)</sub>

Everyone starts as an Attempter writing tasks. Consistently strong work can promote you up a reviewer ladder; a drop in quality can move you back down. Here's how the roles fit together. (Pay, work limits, and internal ops aren't covered here.)

Here's the progression — from where everyone starts, up to the top of the ladder:

1

###### Attempter — Attempt

You author tasks. Quality tiers within this role: Under Review → Attempter → Unthrottled Attempter. If your quality drops, you move down to Under Review Attempter.

2

###### R1 Reviewer — Review 1

First review of submitted tasks, in two tiers (Onboarding R1 → Unthrottled R1). Consistently strong, R2-aligned reviewing promotes you up. An Onboarding R1 reviewer whose quality slips can move back down to an Attempter role.

3

###### R2 Reviewer — Review 2

Final review of tasks that R1 accepted — the top of the ladder.

How a reviewer routes a task — accept, send back for revision, or reject to Holding-Rejection — is shown on the [task pipeline](/).

### Task categories

<sub>`/task-categories` · section: **Get oriented** · [source](https://project-dynamo.learn.joinhandshake.com/task-categories)</sub>

Every task is tagged with values from four controlled vocabularies: **Category**, **Subcategory**, **Task Objective**, and **Artifact Type**. The canonical labels live in **`.dynamo/diversity-taxonomy.toml`** in your task repo — that file is the source of truth, and every label is lowercase `snake_case` (e.g. `implement`, `debug`, `codebase`, `configuration_file`). The lists on this page are a browseable reference, not a separate vocabulary.

Who sets what

- **Category** and **Subcategory** are **pre-seeded by the Dynamo team** when your task repo is created — you do not set or edit them.
- **Task Objective** and **Artifact Type** are the two fields you fill in. Both are arrays of one or more lowercase snake_case labels from `.dynamo/diversity-taxonomy.toml`; assign every label that genuinely applies. Tag the task's *end goal* and *central artifacts* — not the incidental tools, helper scripts, or files used along the way.
- Always pick the **best-fit** label(s). If nothing fits, ask in `#project-dynamo` before inventing a label. The free-form `tags` field has been removed.

#### Category and subcategory (Pre-seeded — For reference only)

The 16 top-level categories and their named subcategories. The Dynamo team assigns one category and one subcategory to your task when the repo is created; you do not pick these.

| # | Category | Subcategories |
| --- | --- | --- |
| 1 | **Software Engineering** | Feature implementation; Refactoring and code modernization; Testing and quality engineering; Compilers, interpreters, and programming languages; Porting and migration; Scripting and automation; Web, API, and networking software; Version control and repository operations |
| 2 | **Debugging and Repair** | Runtime bug repair; Test failure repair; Build failure repair; Configuration repair; Performance debugging; Concurrency and synchronization debugging; Pipeline and orchestration debugging |
| 3 | **Build, Dependency, and Release Management** | Build system configuration; Dependency and lockfile resolution; CI/CD pipelines; Container builds; Cross-compilation and platform targeting; Package publishing; Release artifacts |
| 4 | **Systems, Infrastructure, and Operations** | OS, process, and service management; Users, permissions, and access control; Shell and environment configuration; Networking configuration; Containers and orchestration; Storage and filesystem administration; Scheduling and automation infrastructure; Logging, monitoring, and observability; Virtualization and emulation |
| 5 | **Data Processing and ETL** | ETL pipelines; File format parsing and serialization; Tabular transformation; Text processing; Data validation; Streaming data processing; Geospatial data processing; Media data processing |
| 6 | **Data Querying and Databases** | SQL querying; Analytical queries; Query optimization; Database administration; NoSQL and document stores; Graph and semantic queries |
| 7 | **Data Science and Reporting** | Exploratory data analysis; Statistical analysis and inference; Time-series analysis; Experiment and metrics analysis; Data visualization; Notebook and report generation; Dataset preparation for analysis |
| 8 | **Machine Learning and AI** | Model inference and prediction; Model evaluation and benchmarking; Feature engineering; NLP and language models; Computer vision; ML serving and deployment; Interpretability and model inspection; Unsupervised and representation learning |
| 9 | **Model Training and ML Infrastructure** | Training loops; Fine-tuning; Reinforcement learning; Hyperparameter tuning; Data loading and training pipelines; Checkpointing and resumption; Distributed training; Evaluation infrastructure |
| 10 | **Security** | Cryptography; Cryptanalysis; Authentication and authorization; Vulnerability analysis; Exploit and CTF tasks; Reverse engineering; Digital forensics; Network forensics; Security hardening |
| 11 | **Scientific Computing and Domain Science** | Numerical methods; Differential equations and simulation; Physics and mechanics; Chemistry and materials workflows; Biology and bioinformatics; Signal processing; Statistical modeling; Optimization and operations research |
| 12 | **Mathematics and Formal Reasoning** | Symbolic computation; Number theory and exact arithmetic; Computational linear algebra; Combinatorics and enumeration; Computational geometry; Algorithms and optimization theory; Formal verification |
| 13 | **Hardware, Embedded, and Low-Level Systems** | GPU kernels and accelerators; Embedded and firmware; RTL and digital design; DSP and signal hardware; CAD and mechanical workflows; Low-level runtime and performance |
| 14 | **File and Media Operations** | File search and filtering; Batch rename and organization; Archiving and compression; File format conversion; Text editing and manipulation; File permissions and metadata; Recovery and repair; Video processing; Audio and music processing; Image and design processing |
| 15 | **Games, Puzzles, and Interactive Simulation** | Board and card games; Puzzle solving; Game AI and strategy; World simulation; Interactive text games; Rendering and graphics |
| 16 | **Regulated Knowledge Work and Business Operations** | Finance and quantitative workflows; Business operations; Legal and compliance; Medical and clinical workflows; Personal-assistant productivity |

#### Task objective (18)

Set `task_objective` in `task.toml` to an array of the labels that best describe the task's end goal. Multiple labels are allowed. Use the exact lowercase `snake_case` form as listed in **`.dynamo/diversity-taxonomy.toml`** (the source of truth).

implement
fix
configure
analyze
transform
validate
optimize
migrate
refactor
test
debug
build_or_package
deploy_or_operate
recover_or_repair_artifact
generate
compare_or_select
secure_or_harden
automate_workflow

#### Artifact type (22)

Set `artifact_type` in `task.toml` to an array of the labels that best describe the central artifacts. Multiple labels are allowed. Use the exact lowercase `snake_case` form as listed in **`.dynamo/diversity-taxonomy.toml`** (the source of truth).

codebase
single_script_or_program
test_suite_or_benchmark
build_system_or_package_metadata
configuration_file
shell_environment
service_or_daemon
container_or_virtual_environment
database_or_structured_store
dataset_or_tabular_file
text_or_log_file
document_or_report
archive_or_compressed_artifact
binary_executable_or_library
media_artifact
model_or_checkpoint
hardware_or_firmware_artifact
network_endpoint_or_protocol_artifact
repository_history_or_version_control_state
security_artifact
mathematical_or_scientific_model
generated_output_artifact

### Updates

<sub>`/updates` · section: **Get oriented** · [source](https://project-dynamo.learn.joinhandshake.com/updates)</sub>

What changed recently that affects how you build and submit a task.

##### June 30, 2026

##### Difficulty metric moved from pass@8 to pass@5

- The difficulty bar is now **pass@5**: the reference agent runs **5 times** (instead of 8) and the task must produce **at least 3 valid failures of 5**.
- Acceptance bands: **0–2/5 accepted** on valid failures (a clean **0/5** is the strongest result — fully stumped, oracle still solves it); **3–5/5 rejected** as too easy.
- "Valid failure" rules are unchanged: timeouts and agent/verifier errors don't count.
- Reference model/agent (**GPT-5.4** + **Terminus-2**), Pass@2 behavior, the 3600s timeout ceiling, and all other guidance are unchanged.

##### June 24, 2026

##### task.toml structure

- The reference `task.toml` is now a single canonical block, identical on the "Write instruction.md and task.toml" step and the "task.toml reference" page: top-level `artifacts`, `[task]`, `[metadata]` (grouped into pre-seeded / fixed-dataset / fellow-set fields), `[verifier]`, `[agent]`, and `[environment]` (including `mcp_servers`).
- `avg_at_8` was removed as a `task.toml` field everywhere. The pass@8 acceptance bar is covered under "Difficulty bar and evaluation pipeline" below.

##### Difficulty bar and evaluation pipeline

- The bar was raised: a task must produce at least **4 valid failures out of 8 trials**, measured with **GPT-5.4 at extra-high reasoning effort**.
- Only genuine failures count — timeouts, infrastructure errors, and misaligned instructions/verifiers do not. Any failure due to misalignment is **blocking** and must be fixed first.
- Stage 1 — **pass@2**: two trials check for at least one valid failure, with an LLM analysis of the runs.
- Stage 2 — **pass@8**: after pass@2 succeeds, eight new trials run; you need at least 4 valid failures here.
- Submission is blocked until all checks are cleared.

##### Verifier model

- `[verifier].environment_mode` is left unset. The verifier runs inside the task's single `environment/Dockerfile` image (canonical TB2), and Harbor overlays `tests/` at verify time — there is no separate `tests/Dockerfile`.

##### Taxonomy: pre-seeded vs fellow-set

- `category` and `subcategory` are pre-seeded by the Dynamo team — you don't touch them. You set only `task_objective` and `artifact_type`, using lowercase snake_case values from `.dynamo/diversity-taxonomy.toml`.

##### Instruction length and structured output

- `instruction.md` now has a 1,500-token cap.
- Document any structured-output schema in the prompt itself or a referenced spec file (the separate structured-output line was removed).

##### Common errors and self-check (Pitfalls page)

- New "Common errors and examples" subsection with four worked failure cases (Problem / code excerpts / how to avoid it).
- New "Before you submit: quick self-check" — a five-item checklist distilling those examples.

##### Proposal guidance

- A fourth justification question (with an accompanying callout) was added to the proposal step.

---

## Task file structure

<sub>`/structure` · nav label: *Task files* · [source](https://project-dynamo.learn.joinhandshake.com/structure)</sub>

The task scaffold lives in the **`/task`** folder in the repo. Your task is a single Harbor task under that `task/` directory — not at the repo root, and not in a `tasks/<id>/` subfolder. The scaffold already contains every file. You fill in the task files; you leave the provided infrastructure alone.

```
task/
├── task.toml               # manifest — you fill metadata + timeouts
├── instruction.md          # the prompt the agent receives ("You have N seconds…" line at the end)
├── solution/
│   └── solve.sh            # reference solution (+ helpers like solve.py); never copied into the agent image
├── environment/
│   ├── Dockerfile          # the task's single image (agent + verifier)
│   └── data/               # optional input files, COPYed into the image
├── tests/
│   ├── test.sh             # runs pytest; writes the reward (1/0) to /logs/verifier/reward.txt
│   └── test_outputs.py     # pytest assertions — 1:1 with instruction.md
├── .dynamo/                # PROVIDED — automated checks, rubric, eval prompt (do not edit)
├── .github/                # PROVIDED — CI workflows (do not edit)
├── .harbor/                # PROVIDED — Harbor run defaults (do not edit)
└── README.md               # replace with a short description of your task before final submit
```

### The files you fill in

| File | What it is |
| --- | --- |
| `task.toml` | The manifest — metadata and resource/timeout config. See the [task.toml reference](/workflow/step-7). |
| `instruction.md` | The prompt handed verbatim to the agent — the only thing it sees. Absolute paths (`/app/...`), every output file named, the "what" not the "how". Capped at **1,500 tokens**. Write it as a human; end with the timeout line. |
| `solution/solve.sh` | Your reference (Oracle) solution; proves the task is solvable. Keep real logic in helpers (e.g. `solution/solve.py`) it calls. Never copied into the agent image. |
| `environment/Dockerfile` | The task's single image (agent + verifier) — install every dependency here, including pinned test deps (e.g. `pytest`, `pytest-json-ctrf`). Put input data in `environment/data/` and COPY it in. Never COPY `solution/` or `tests/`. |
| `environment/data/` | Optional input files for the agent, COPYed into the image at build time. |
| `tests/test.sh` + `tests/test_outputs.py` | The verifier — checks the agent's real outputs, 1:1 with `instruction.md`, with a docstring per test. `tests/test.sh` writes `reward.txt` (1/0) and `ctrf.json` to `/logs/verifier/` and must always exit 0. `tests/` is added only at verify time (after the agent finishes) and is not present during the agent run. |

Don't touch the provided infrastructure

`.dynamo/`, `.github/`, and `.harbor/` ship in the scaffold and run the automated review — leave them as-is. The exact criteria your task is graded on live in `.dynamo/dynamo-rubric.toml`; read it to see what "good" looks like.

### What never goes in the image

Never bake solve.sh or tests/ into the Docker image

`environment/Dockerfile` defines the starting state the agent sees - nothing more. The golden solution and the test harness live in the repo for development and review, but must NOT be copied into the image. CI enforces this; a task with `solve.sh` or `tests/` inside the agent image is rejected.

Verify this after every build:

```
docker run --rm <repo-name>:dev /bin/bash -lc \
  'find / \( -name solve.sh -o -name test.sh \) 2>/dev/null'
# expect: no output
```

What does belong in the image: a pinned base, the runtimes and libraries the agent needs, and the seed files from `environment/`. Test dependencies (`pytest`, `pytest-json-ctrf`, etc.) are pinned and baked into `environment/Dockerfile`. The single image is reused for the verifier run, and `tests/test.sh` installs nothing at runtime.

---

## Getting started

<sub>`/setup` · nav label: *Set up* · [source](https://project-dynamo.learn.joinhandshake.com/setup)</sub>

Three things before you build: install the prerequisites, install Harbor, and fork your assigned task repo.

### Prerequisites

- **Docker** installed and running
- **uv** installed — <https://astral.sh/uv>
- **Python 3.11+**
- **GitHub CLI** (`gh`) — <https://cli.github.com/>, then `gh auth login`

### Install harbor

```
uv tool install harbor
harbor --version
```

### Fork your task repo

You were assigned a task repo under `handshake-project-dynamo`. Fork it, clone your fork, and make a working branch. You don't have write access to the base — you propose changes via a pull request.

```
gh repo fork handshake-project-dynamo/<your-task-repo> --clone
cd <your-task-repo>/task
git checkout -b submission
```

See [Workflow Step 3](/workflow/step-3) for the full fork-and-scaffold sequence, including the expected directory layout.

### Core Harbor commands (run from the `task/` directory)

```
harbor run -p . --agent oracle  →  run your solution against the verifier (expect reward 1.0)
harbor run -p . --agent nop     →  run the no-op agent; doing nothing must score reward < 1.0
```

You don't need to run these yet
body: These commands come up later, during the workflow steps — after you've authored `solve.sh`, written tests, and built the Dockerfile. They're listed here so you know what Harbor will ask of you, not as something to run right now.

No model API key is needed to scaffold, run the oracle, or calibrate locally.

### Prerequisites

<sub>`/setup/prereqs` · section: **Set up** · nav label: *Install prerequisites* · [source](https://project-dynamo.learn.joinhandshake.com/setup/prereqs)</sub>

A one-time setup. Install all three before installing Harbor.

- **Docker** - Harbor uses Docker to build and run your task locally. See the install steps below.
- **uv** - Astral's Python package manager. `curl -LsSf https://astral.sh/uv/install.sh | sh`, then `uv --version`. See <https://astral.sh/uv>.
- **Python 3.11+** - `python3 --version`. `uv` will manage Python toolchains if you need a newer interpreter.

#### Install docker

Pick the install path for your OS, start Docker, and confirm it's running.

**macOS** - download Docker Desktop from <https://www.docker.com/products/docker-desktop/> (choose the Apple Silicon or Intel build to match your machine), open the `.dmg`, and drag Docker to Applications. Launch Docker Desktop once so it finishes setup.

**Windows** - download Docker Desktop from <https://www.docker.com/products/docker-desktop/> and run the installer. It will enable WSL 2 if it isn't already; reboot when prompted, then launch Docker Desktop.

**Linux** - install Docker Engine using the official convenience script, then add your user to the `docker` group so you can run it without `sudo`:

```
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
newgrp docker
```

Full per-distro instructions: <https://docs.docker.com/engine/install/>.

##### Verify

```
docker --version
docker ps
```

`docker ps` should print an empty table (no error). If you see "Cannot connect to the Docker daemon," start Docker Desktop (macOS/Windows) or `sudo systemctl start docker` (Linux) and try again.

No API key needed for local work

You do not need a model API key to scaffold a task, run the oracle agent, or calibrate locally. API keys come in only when you run a real evaluation against a hosted model.

### Install harbor

<sub>`/setup/install-harbor` · section: **Set up** · nav label: *Install Harbor* · [source](https://project-dynamo.learn.joinhandshake.com/setup/install-harbor)</sub>

Harbor builds and runs your task locally in Docker. Install it once as a global tool:

```
uv tool install harbor
harbor --version
```

⚠️ Install `harbor`, not `harbor-cli`

The package you need is `harbor` — not `harbor-cli`. Both are technically CLIs, but `harbor-cli` is a completely different application and will not work for Dynamo tasks. Double-check the name before installing.

You point Harbor at your task by running it from the `task/` directory (`harbor run -p . --agent oracle`) and it builds the single task image, runs it, and writes the reward to `/logs/verifier/`. (You do not need to clone terminal-bench-2 — your task lives in your own forked repo.)

### Harbor commands

<sub>`/setup/verify-oracle` · section: **Set up** · nav label: *Run Harbor commands* · [source](https://project-dynamo.learn.joinhandshake.com/setup/verify-oracle)</sub>

Run these from the **root of your task repo**.

| Command | What it does |
| --- | --- |
| `harbor run -p . --agent oracle` | Build the images and run the **oracle agent** (your `solution/solve.sh`) against the verifier. Expect **reward 1.0**. |
| `harbor run -p . --agent nop` | Run the **nop agent** (does nothing). It must **fail** — expect **reward < 1.0**. If it passes, your verifier is too weak. |

The loop you repeat: edit task files, then `harbor run -p . --agent oracle`. Oracle must score 1.0 and nop must score < 1.0 before you open a PR.

You don't need to run these yet

These commands come up later, during the workflow steps — after you've authored `solve.sh`, written tests, and built the Dockerfile. They're listed here so you know what Harbor will ask of you, not as something to run right now.

### Calibration loop

<sub>`/setup/single-task` · section: **Set up** · nav label: *Design calibration loop* · [source](https://project-dynamo.learn.joinhandshake.com/setup/single-task)</sub>

The harness is correct if and only if it **fails a wrong solution and passes the golden one**. You'll run this loop after writing the tests in Step 5, and again after building the Dockerfile in Step 6.

#### Wrong solution must fail (Reward < 1.0)

Replace `solve.sh` with something trivially wrong - an empty script, a stub that writes nothing. Run Harbor from the `task/` directory.

```
echo '#!/bin/bash' > solution/solve.sh
harbor run -p . --agent oracle
cat /logs/verifier/reward.txt
# expect: reward < 1.0
```

#### Golden solve.sh must pass (Reward 1.0)

Restore the real solution and re-run.

```
git checkout solution/solve.sh
harbor run -p . --agent oracle
cat /logs/verifier/reward.txt
# expect: 1.0
```

Treat **reward 1.0 for golden, reward < 1.0 for stub** as the bar for moving to the next step. If `harbor run -p . --agent nop` passes, the verifier is too weak and is scoring a pass without the work being done - tighten the assertions until doing nothing fails.

---

## Creating a task

<sub>`/workflow` · nav label: *Build a task* · [source](https://project-dynamo.learn.joinhandshake.com/workflow)</sub>

Note down your Category and Sub-category when claiming

When you claim a task, write down the **Category** and **Sub-category** you picked — you'll need to enter them in the proposal stage.

You build one Harbor task at the root of your forked task repo. The steps below depend on each other, so it's easiest to work them in order, but there's no required commit structure — commit however you like and iterate freely. Test locally with the oracle before you open a PR.

Before you start, skim [Examples & Strategies](/examples) — reading a good repo end-to-end is the fastest way to get a feel for what a strong task looks like.

**The whole journey at a glance** — build a tricky-but-fair challenge for a smart AI model:

![The Dynamo Quest map — 1. Welcome, 2. Open the box (task file structure), 3. Get your tools (set up locally), 4. the main quest (Claim, Propose, Fork repo, Answer key, Grader, Package it, Write question), 5. Hand it in (PR, auto-checks, 5 model attempts), and the Golden Rule: no peeking at the answer key, and the grader must check the real answer.](/assets/dynamo-workflow-puzzle.png)

1. **Claim a task** — pick your favored category, then filter for the appropriate subcategory and claim the task.
2. **Write the proposal** — define the idea and pass the automated proposal review before you build anything.
3. **Fork & set up the repo** — fork your task repo, `git checkout -b submission`, and review the files already in place (see [Task File Structure](/structure)).
4. **Author `solve.sh`** — your reference solution. Keep real logic in helpers (e.g. `solution/solve.py`) it calls; write outputs to the absolute paths `instruction.md` names.
5. **Write the tests** — `tests/test_outputs.py` (one assertion per criterion, each with a docstring) and `tests/test.sh` (runs pytest, writes the reward to `/logs/verifier/reward.txt`). Bake test dependencies into the single `environment/Dockerfile`.
6. **Build the Dockerfile** — `environment/Dockerfile` defines the task's single image (agent + verifier); put inputs in `environment/data/` and COPY them in. Never COPY `solution/` or `tests/`.
7. **Write `instruction.md` and `task.toml`** — the prompt the agent reads (end with the "You have N seconds…" line) and the manifest (its full field reference is on the [same page](/workflow/step-7)).
8. Then [validate the task locally and submit](/wrap-up) — the oracle must pass and nop must fail — and open your PR.

Difficulty comes from reasoning

Make the task hard for a person, not for the computer. Difficulty should come from reasoning — not from cranking up CPU, memory, or wall-clock time. The agent has open internet, so the answer must not be findable online.

### 1 · Claim a task

<sub>`/workflow/step-1` · section: **Build a task** · nav label: *1. Claim* · [source](https://project-dynamo.learn.joinhandshake.com/workflow/step-1)</sub>

Note down your Category and Sub-category when claiming

When you claim a task, write down the **Category** and **Sub-category** you picked — you'll need to enter them in the proposal stage.

Claim a task on the platform and read through the Intro page. The Intro lays out everything you need to know about the task before you start building — scope, expected outputs, and constraints.

Claiming locks the task

Only claim a task you fully intend to work on. If after opening it you decide it's not a good fit, release it through the platform so someone else can pick it up — don't sit on it.

#### How to claim

1

###### Open the task queue on the platform

Sign in to the annotation platform and open the Dynamo task list. Filter by category and subcategory and choose one you're confident you can contribute to.

2

###### Claim the task

Hit **Claim** on the row. The task now belongs to you and is hidden from the rest of the queue. The platform records the claim timestamp, which starts your working window.

3

###### Release if it's not a fit

If the task isn't right for you after reading it, use the platform's **Release** (or **Abandon**) action so someone else can pick it up. Don't leave it claimed.
last: true

#### Accept the repo invite

After you claim a task, you'll receive an invite link to access its repo. Accept the invite — once you do, the task's repo link becomes visible on the platform and you can start working.

One active claim at a time

Keep your queue clean — finish or release the task you've claimed before picking up another. Parallel claims slow the whole pipeline down.

### 2 · Write the proposal

<sub>`/workflow/step-2` · section: **Build a task** · nav label: *2. Write proposal* · [source](https://project-dynamo.learn.joinhandshake.com/workflow/step-2)</sub>

Before you build anything, you write a short **proposal** describing the task you want to create. An automated reviewer reads it and returns **passed** or **failed** with specific feedback. You revise and resubmit until it passes — then you scaffold the repo. The proposal is a cheap gate: it catches ideas that are too easy, un-gradable, or impossible *before* you spend hours on a solution and tests.

A proposal is judged on the **idea**, not on polished prose. There is no solution or test code yet — don't write any. Four things must be in it.

The four things every proposal must include

1. **The difficulty** — what the task is and *why it's genuinely hard for an expert*. Name the specific reasoning, domain knowledge, or multi-step problem-solving involved; who in the real world does this work; and where any data comes from (synthetic or real, and whether it's realistically challenging). Not "this is hard."
2. **The intended approach** — a high-level strategy and the key insight for how it would be solved. Enough that another expert sees how they'd do it. This proves you actually hold a solution, not just a hope that one exists. Include a best-case expert-time estimate (focused hours for a senior practitioner who already knows the approach).
3. **How it will be verified** — what output the agent must produce and how a program would deterministically check it's correct. If you'll accept a range or tolerance instead of an exact answer, say what the band brackets and why it admits valid variation but rejects wrong methods.
4. **Category & sub-category justification** — a brief justification for why this task belongs to the category and sub-category you chose. Ground it in the task's actual reasoning and domain, not generic labels.

Do not edit Category or Sub-category

The **Category** and **Sub-category** input fields are pre-filled and must not be edited. Leave them exactly as they appear — your justification in answer 4 is where you explain the fit.

Answering these four questions now means you've de-risked the task before building it — they're the same questions you'll need to satisfy when you write `task.toml` and the verifier.

Pass the platform-gated check before moving on

Don't start scaffolding, writing tests, or building a solution until your proposal clears the platform's automated review. Submit, then read the comments on the right — they show pass/fail per criterion and actionable feedback on exactly what to fix. Revise and resubmit until it passes. Every hour spent building on top of a proposal that hasn't passed is an hour you may have to throw away.

#### What makes a proposal pass

The reviewer holds your idea to a high bar. A strong proposal clears all of these:

Work through each item.

##### Checklist

0 of 6 complete

Hard for a competent domain expert — not solvable by an average undergrad in a few days, and not just tedious or high-volume.Requires real multi-step terminal work — exploration, running code, debugging, iterating. Not solvable on paper or in one shot.Not a textbook or well-known problem a model could reproduce from memory.A solution plausibly exists and is bounded — you can sketch the approach, not just assert it's possible.Deterministically checkable, and the answer can't be looked up online, shortcut, or hardcoded.Graded on the result (what is produced), never on the method. No mandated tools or step-by-step procedure.

Why proposals fail

The most common rejections: difficulty stated vaguely ("requires expertise"); an approach that only claims a solution exists without conveying the key insight; tolerances/ranges with no justification; no expert-time estimate; a task that's actually solvable by reasoning alone; a standard problem with a well-known solution; or grading that depends on *how* the agent solves it. Each is fixable by editing the proposal — the reviewer's feedback tells you exactly what to add.

Worked example — a proposal that passes

**Task:** Implement a concurrent C++ larger-than-memory key-value store that *beats Microsoft FASTER* on the YCSB-A benchmark, in one shot, inside a 4-CPU / 2 GB container.

**Difficulty:** The ~3 GB dataset exceeds the 2 GB container, so a naive approach thrashes or runs out of memory — a real larger-than-memory architecture (compact in-memory index + on-disk value log) is mandatory just to load. Beating a 7-year-optimized production system is genuine storage-systems R&D, the day-job of engineers who build databases and caches.

**Approach (key insight):** Specialization beats generality. Exploit the fixed, known workload — fixed-size values, integer keys, a small hot key-set, fixed core count — to shed the overhead FASTER pays for being general-purpose (variable-length records, full recovery, general garbage collection). A senior systems engineer who holds this design could implement it in ~2–3 focused days.

**Verification:** Deterministic gates — correctness/anti-cheat tests, proof that values are actually on disk, and a throughput comparison run in the same harness as FASTER (median of 5 runs, run-phase only, identical traces). The pass bar allows a small margin to absorb measured run-to-run jitter while still rejecting a genuinely slower solution.

Once your proposal passes, move on to **3 · Fork & set up the repo**.

### 3 · Fork & Set up the repo

<sub>`/workflow/step-3` · section: **Build a task** · nav label: *3. Fork and set up* · [source](https://project-dynamo.learn.joinhandshake.com/workflow/step-3)</sub>

You were assigned a task repo under `handshake-project-dynamo`. Fork it, clone your fork, and make a working branch — you propose changes back via a pull request.

```
gh repo fork handshake-project-dynamo/<your-task-repo> --clone
cd <your-task-repo>/task
git checkout -b submission
```

The task scaffold lives in the **`/task`** folder in the repo. The repo is already scaffolded, with the task under that `task/` directory. Confirm the layout (don't rename or move top-level files):

```
task/
├── task.toml
├── instruction.md
├── solution/solve.sh
├── environment/Dockerfile
├── tests/{test.sh, test_outputs.py}
├── .dynamo/  .github/  .harbor/   # provided — do not edit
└── README.md
```

If your task needs input files, put them under `environment/data/`; the Dockerfile copies them into the agent's container.

Work through each item.

##### Checklist

0 of 3 complete

Forked and cloned your task repo; on the `submission` branchLayout confirmed — task lives under task/, top-level files intactInput/seed files (if any) placed under environment/data/

### 4 · Author solve.sh

<sub>`/workflow/step-4` · section: **Build a task** · nav label: *4. Write solve.sh* · [source](https://project-dynamo.learn.joinhandshake.com/workflow/step-4)</sub>

`solution/solve.sh` is your reference (Oracle) solution — it must complete the task correctly, which proves the task is solvable. Harbor mounts `solution/` at `/solution/` and runs `solve.sh`. Keep the real logic in a helper (e.g. `solution/solve.py`) that `solve.sh` calls, and write outputs to the absolute `/app/...` paths named in `instruction.md`.

```
#!/bin/bash

# Real logic lives in a helper; write outputs to the /app paths in instruction.md.
python3 /solution/solve.py
```

Rules for solve.sh

- Don't install packages here (`apt-get`/`pip install`) — the agent's `environment/Dockerfile` handles all setup.
- Write outputs to absolute `/app/...` paths. Put non-trivial logic in helper files under `solution/` rather than one giant heredoc.

Then prove it works locally — the oracle must score reward 1.0:

```
harbor run -p . --agent oracle
# expect: reward 1.0
```

Look at what the solution actually produced and write a numbered list of **observable success criteria** (file existence, schema, ordering, arithmetic relationships). That list drives the tests (Step 5) and becomes the spec in `instruction.md` (Step 7).

Work through each item.

##### Checklist

0 of 5 complete

solve.sh calls helper logic (e.g. solution/solve.py)Writes outputs to the absolute /app paths named in instruction.mdNo package installs inside solve.shharbor run -p . --agent oracle scores reward 1.0 locallyNumbered list of observable success criteria captured

### 5 · Write the tests

<sub>`/workflow/step-5` · section: **Build a task** · nav label: *5. Write tests* · [source](https://project-dynamo.learn.joinhandshake.com/workflow/step-5)</sub>

The verifier runs after the agent finishes, in a fresh container from the task's **single image** (`environment/Dockerfile` — the [single-Dockerfile rule and allowlist live on Step 6](/workflow/step-6)); `tests/` is added only at verify time and is not present during the agent run. The verifier can read only: the output files the agent wrote at the `/app/...` paths your `instruction.md` declares, anything baked into the single image, and sidecars from `environment/docker-compose.yaml`. Keep ground-truth/oracle data inside `tests/` (added at verify time) — never in `environment/`, where the agent could read it.

`tests/test.sh` just runs your tests and writes the reward — it must **not** install or download anything (verify-time setup is rejected by the static checks; bake deps into `environment/Dockerfile` instead).

```
#!/bin/bash
pytest --ctrf /logs/verifier/ctrf.json /tests/test_outputs.py -rA

if [ $? -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
```

`tests/test_outputs.py` — one function per success criterion, each with a docstring, asserting on observable artifacts at the `/app` paths the instruction names. Check real outputs; never string-match source or reference `solve.sh`. And harden it against a verifier that reads its own answer key back — see [Don't symlink the answer](/practice/symlinking-errors).

Reviewer will check this closely

Tests are the single biggest reason PRs get rejected. Cross-check yours against [What only a human can judge](/reviewing/judgment) — especially that each test maps to a stated criterion, asserts on real artifacts, and isn't gameable by a nop agent.

```
import json
from pathlib import Path

def test_output_exists():
    """The agent must write /app/output.json."""
    assert Path("/app/output.json").exists()

def test_output_schema():
    """output.json contains the required keys."""
    data = json.loads(Path("/app/output.json").read_text())
    assert {"input_rows", "output_rows", "duplicates_removed"} <= data.keys()
```

Then calibrate — the golden solution passes and doing nothing fails:

```
harbor run -p . --agent oracle   # expect reward 1.0
harbor run -p . --agent nop      # expect reward < 1.0
```

Work through each item.

##### Checklist

0 of 7 complete

One test function per success criterion, each with a docstringAsserts on observable /app artifacts — not stdout or source matchingtest.sh installs/downloads nothing; deps are baked into environment/DockerfileReward written to /logs/verifier/reward.txt (1/0)Oracle scores reward 1.0 and nop scores reward < 1.0No reward.txt ships in the environment. test.sh always writes 0 or 1, even on missing prerequisites or a no-op, and never exits without writing the reward.Tests use fixed seeds and inputs. No unseeded randomness, live-generated data, or wall-clock/date dependence.

### 6 · Build the dockerfile

<sub>`/workflow/step-6` · section: **Build a task** · nav label: *6. Build Dockerfile* · [source](https://project-dynamo.learn.joinhandshake.com/workflow/step-6)</sub>

`environment/Dockerfile` defines the task's **single image** — built once and reused for both the agent run and the verifier run. The agent has **open internet by default** (`allow_internet = true` in `task.toml`), but you should still bake in everything the task needs for reproducibility — including the pinned test dependencies — and design so the answer can't simply be fetched online.

Base images: allowlist + digest-pinned

Every `FROM` must use a base image from the **pre-approved allowlist** (use one unless none support your task's dependencies) and must be **pinned by digest** (`@sha256:…`), never by tag alone. `:latest` is never allowed, and a floating tag like `python:3.13-slim-bookworm` without a digest is also rejected.

Use **one** of these pre-approved base images. Only reach for something else if none of them can support your task's dependencies — and document why. Always pin by the digest shown (`@sha256:…`); never use a bare tag or `:latest`.

| Language / runtime | Allowed versions & variants | Approved base image (pin by this digest) |
| --- | --- | --- |
| **Go** | 1.21–1.26 majors + alpine/bullseye/bookworm | `public.ecr.aws/docker/library/golang:1.24-bookworm@sha256:1a6d4452c65dea36aac2e2d606b01b4a029ec90cc1ae53890540ce6173ea77ac` |
| **Python** | 3.10 / 3.11 / 3.12 / 3.13 majors + patch + slim/non-slim | `public.ecr.aws/docker/library/python:3.13-slim-bookworm@sha256:01f42367a0a94ad4bc17111776fd66e3500c1d87c15bbd6055b7371d39c124fb` |
| **Debian** | bookworm / bullseye / 12.x slim variants | `public.ecr.aws/docker/library/debian:bookworm-slim@sha256:4724b8cc51e33e398f0e2e15e18d5ec2851ff0c2280647e1310bc1642182655d` |
| **Rust** | 1.75–1.95 + slim/non-slim + bullseye | `public.ecr.aws/docker/library/rust:1.85-slim@sha256:9f841bbe9e7d8e37ceb96ed907265a3a0df7f44e3737d0b100e7907a679acb36` |
| **Node** | 18 / 20 / 22 / 24 majors + slim/non-slim | `public.ecr.aws/docker/library/node:22-bookworm-slim@sha256:f3a68cf41a855d227d1b0ab832bed9749469ef38cf4f58182fb8c893bc462383` |
| **Ubuntu** | 22.04 / 24.04 / jammy variants | `public.ecr.aws/docker/library/ubuntu:24.04@sha256:0d39fcc8335d6d74d5502f6df2d30119ff4790ebbb60b364818d5112d9e3e932` |
| **Java** | 17 / 21 jdk-jammy/noble variants | `public.ecr.aws/docker/library/eclipse-temurin:21-jdk-jammy@sha256:25d1276565738d3c805e632a4542c3a7598866ef967f4def6544c15de3a74b14` |
| **Ruby** | 3.2 / 3.3 / 3.4 + slim/non-slim | `public.ecr.aws/docker/library/ruby:3.3-slim-bookworm@sha256:e76733e94b3a5893e4a141024ef3a583dc10781dc24becebf74f9c9f9a33e3df` |
| **Maven** | + temurin-17/21 variants | `public.ecr.aws/docker/library/maven:3.9.9-eclipse-temurin-21@sha256:3a4ab3276a087bf276f79cae96b1af04f53731bec53fb2e651aca79e4b10211e` |
| **GCC** | 12 / 13 / 14 / 15 variants | `public.ecr.aws/docker/library/gcc:13-bookworm@sha256:930f2ebe239275fa67226654cb79273ea34eee672ae61c8a39f689c37fb7ac5c` |

Pinning to a different version in the same family

The digests above pin one specific image per family. You may target another allowed version in the same family (e.g. a different Python patch or a slim/non-slim variant) — but you must pin it to that image's own `@sha256:…` digest. A tag without a digest is rejected.

```
FROM public.ecr.aws/docker/library/python:3.13-slim-bookworm@sha256:<digest-from-allowlist>

# Don't pin apt versions; update before install; clean lists in the same layer.
RUN apt-get update && apt-get install -y --no-install-recommends <packages> \
    && rm -rf /var/lib/apt/lists/*

# Pin pip/npm versions. Bake test dependencies into the single image (pinned).
RUN pip install --no-cache-dir pytest==8.4.1 pytest-json-ctrf==0.3.5

# Put inputs in environment/data/ and copy them in.
COPY data /app/data

# Pre-create the parent dir of every output path the agent writes, or artifact upload fails.
RUN mkdir -p /app

WORKDIR /app
```

Dockerfile rules

- Pinned base image from the allowlist, **pinned by digest** (`@sha256:…`); no `:latest`, no bare tags. Pin pip/npm to exact versions; do NOT pin apt packages.
- Never COPY `solution/` or `tests/` such that they're readable during the agent run — CI enforces this. (`tests/` is added only at verify time.)
- Put input data in `environment/data/` and COPY it to `/app/...`. Never put solution or ground-truth data here.
- Bake every test dependency (pinned) into this single Dockerfile — `tests/test.sh` installs nothing at verify time.
- Use a multi-stage build for any compiled artifact (cargo/go/mvn/npm build) so the toolchain and build cache don't survive into the runtime image.
- Add a .dockerignore and scope COPY narrowly. Never copy .git, caches, or unrelated files.
- Order layers least- to most-volatile; consolidate apt installs into one RUN and clean lists in the same layer; never apt-get upgrade.
- Put source and fixtures on disk and COPY them. No `RUN cat <<EOF` heredocs; extract .tar.gz fixtures at build so files appear as layer entries.
- chmod only the specific files that need it. Never chmod -R a whole tree.

Validate end to end with Harbor (the oracle passes, doing nothing fails):

```
harbor run -p . --agent oracle   # expect reward 1.0
harbor run -p . --agent nop      # expect reward < 1.0
```

Work through each item.

##### Checklist

0 of 10 complete

The Dockerfile uses an allowlisted base image pinned by digest (@sha256:…) — no :latest, no bare tagspip/npm pinned to exact versions; apt not pinnedenvironment/Dockerfile does NOT COPY solution/ or tests/Input data lives in environment/data/ and is COPYed to /appTest dependencies (e.g. pytest, pytest-json-ctrf) are baked pinned into the single environment/Dockerfile, and RUN mkdir -p /app is presentOracle scores reward 1.0 and nop scores reward < 1.0No unnecessary files in the image (logs, caches, venvs, editor metadata, large unused assets).The agent image doesn't include dependencies only the oracle needs — they would hint the solution path.Any service the task needs starts reliably, exposes the expected ports, and has a health check.Text files use LF (Unix) line endings.

### 7 · Write instruction.md and task.toml

<sub>`/workflow/step-7` · section: **Build a task** · nav label: *7. Write instruction.md and task.toml* · [source](https://project-dynamo.learn.joinhandshake.com/workflow/step-7)</sub>

`instruction.md` is the prompt handed verbatim to the agent — the only thing it sees. Write it yourself, as a domain expert (no LLM-generated text). It's a prompt, not a document: no title, no section headers, no roleplay, no fluff. Use absolute `/app/...` paths, name every expected output file and its exact format, and don't reveal your solution. Keep it under **1,500 tokens**, and end with the required timeout line.

```
Deduplicate the order records in /app/orders.csv and write /app/output.json with the
keys "input_rows", "output_rows", and "duplicates_removed". Two records are duplicates
when they share the same (order_id, customer_id). Do not modify /app/orders.csv.

You have 120 seconds to complete this task. Do not cheat by using online solutions or hints specific to this task.
```

The final line is enforced

`instruction.md` must end with exactly: "You have N seconds to complete this task. Do not cheat by using online solutions or hints specific to this task." — where N is `[agent].timeout_sec` in `task.toml`. A static check (check-instruction-suffix) fails the PR otherwise. Update both numbers together.

`task.toml` is the manifest. Fill the metadata and tune the timeouts/resources; the full field-by-field reference is below. `category` and `subcategory` are **pre-seeded by the Dynamo team** — you only set `task_objective` and `artifact_type`, picking lowercase snake_case labels from `.dynamo/diversity-taxonomy.toml` (browse them on the [Task categories](/task-categories) page). Carry the difficulty/approach/verification answers from your [proposal](/workflow/step-2) into `difficulty_explanation`, `solution_explanation`, and `verification_explanation`.

```
*artifacts = []  # output paths the verifier reads (above first [section])

[task]
*name = "dynamo/your-task-name"  # org/name; name lowercase kebab-case, <=3 words
*description = ""                 # one-line task summary

[metadata]
# --- Pre-seeded — DO NOT EDIT ---
category = ""                      # assigned by the Dynamo team
subcategory = ""                   # assigned by the Dynamo team

# --- Fixed for this dataset — leave as-is ---
model_tested = "GPT-5.4"           # benchmarking model
agent_tested = "Terminus-2"        # benchmarking agent

# --- You fill these in ---
# task_objective / artifact_type: from .dynamo/diversity-taxonomy.toml (snake_case)
task_objective = []                # e.g. ["implement", "debug"]
artifact_type = []                 # e.g. ["codebase", "configuration_file"]
expert_time_estimate_hours = 0     # expert best-case hours
*difficulty_explanation = ""        # why it's hard
*solution_explanation = ""          # approach + key insights
*verification_explanation = ""      # how tests verify

[verifier]
timeout_sec = 120.0                # raise for slow test suites
# environment_mode left unset (TB2 shared model; Harbor overlays tests/ at verify time)

[agent]
timeout_sec = 120.0                # raise for hard tasks

[environment]
build_timeout_sec = 600.0          # max Docker build seconds
cpus = 1                           # raise for compute-heavy work
memory_mb = 2048                   # raise for large/in-memory data
storage_mb = 10240                 # raise for large files/artifacts
gpus = 0                           # max 1 (H100)
allow_internet = true              # agent has open internet
*mcp_servers = []                   # optional MCP servers
```

** — additional fields we are adding.*

instruction.md is capped at 1,500 tokens

`instruction.md` must not exceed **1,500 tokens**. If you need to specify a structured output schema, document it in `instruction.md` or in a referenced spec file (and reference that file from the prompt). Subjective goals like "make this better" are not allowed — every requirement must come with an **objective acceptance criterion** the verifier can assert on.

Reviewer will check your metadata

Metadata labels and the instruction prompt are scored items on the [Reviewer guideline](/reviewing). Before moving on, confirm your `task_objective` and `artifact_type` are best-fit (not just valid) per [Recording your verdict](/reviewing/scoring), and that `instruction.md` reads cleanly to a domain expert who has never seen your solution.

Work through each item.

##### Checklist

0 of 7 complete

instruction.md is human-written and prompt-style — no title, headers, roleplay, or fluffAbsolute /app paths; every output file and its format named; solution not revealedEnds with the exact "You have N seconds…" line (N = agent timeout)instruction.md is under 1,500 tokenstask.toml metadata filled — task_objective and artifact_type chosen from .dynamo/diversity-taxonomy.toml (lowercase snake_case), expert_time_estimate_hours, difficulty_explanation, solution_explanation, verification_explanation (category, subcategory, model_tested, agent_tested are pre-seeded and left as-is)agent/verifier timeouts setDon't claim a tool, service, or dataset exists unless it's actually present in the environment.

#### `task.toml` field reference

| Block | Field | Notes |
| --- | --- | --- |
| (top-level) | `artifacts` | Array of absolute paths the verifier reads from the agent (e.g. `["/app/output.json"]`). Must appear **above** the first `[section]` header. |
| `[task]` | `name` | Required format `org/name` (Harbor needs the slash). The `name` part is lowercase kebab-case, ≤3 words (e.g. `dynamo/dedupe-orders`). |
| `[task]` | `description` | One-line summary of the task. |
| `[metadata]` | `category` / `subcategory` | **Pre-seeded by the Dynamo team** when your task repo is created — do not edit. |
| `[metadata]` | `model_tested` / `agent_tested` | Fixed for this dataset: leave as **`"GPT-5.4"`** and **`"Terminus-2"`** (the difficulty-benchmarking model and agent, run via Harbor). Cheaper models can pre-filter while you iterate, but the recorded pass@5 number must come from this reference pair. |
| `[metadata]` | `task_objective` | Array of lowercase snake_case labels (e.g. `["implement", "debug"]`) chosen from `.dynamo/diversity-taxonomy.toml`. |
| `[metadata]` | `artifact_type` | Array of lowercase snake_case labels (e.g. `["codebase", "configuration_file"]`) chosen from `.dynamo/diversity-taxonomy.toml`. |
| `[metadata]` | `expert_time_estimate_hours` | Best-case hours for a focused domain expert who already holds the intended insight. Non-zero, consistent with the difficulty. |
| `[metadata]` | `difficulty_explanation` | Why this task is hard for agents and humans — the same difficulty argument from your [proposal](/workflow/step-2). |
| `[metadata]` | `solution_explanation` | High-level approach and key insights — the same intended-approach answer from your [proposal](/workflow/step-2). |
| `[metadata]` | `verification_explanation` | How the tests verify correctness — the same verification answer from your [proposal](/workflow/step-2). |
| `[verifier]` | `timeout_sec` | Seconds for the verifier; raise based on your test suite's runtime demands. |
| `[verifier]` | `environment_mode` | **Leave unset.** Canonical TB2 uses the shared model: the verifier runs in the task's environment image (`environment/Dockerfile`), and Harbor overlays `tests/` at verify time. There is no separately-built verifier container. |
| `[agent]` | `timeout_sec` | Seconds the agent gets. Raise for hard tasks (agents may run for many minutes or hours), and keep `instruction.md`'s final timeout line in sync with this number. |
| `[environment]` | `build_timeout_sec` | Max seconds for the Docker build. |
| `[environment]` | `cpus` / `memory_mb` / `storage_mb` | Resource caps. Raise only as the task genuinely needs — difficulty should come from reasoning, not compute. |
| `[environment]` | `gpus` | 0 by default; max 1 (expect an H100) if the task truly needs it. |
| `[environment]` | `allow_internet` | **`true` by default — open internet is available to the agent.** The answer must still not be retrievable online (see anti-cheat). If a task genuinely needs a specific external host, justify it and keep the access minimal and documented; if it needs no network, set `false`. |
| `[environment]` | `mcp_servers` | Optional MCP servers to expose to the agent. Leave as `[]` unless the task genuinely needs one. |

No author info

Do not put your name, email, or other personal information in `task.toml`. Identity is recorded outside the manifest.

### Validate & Submit

<sub>`/wrap-up` · section: **Build a task** · nav label: *8. Wrap up* · [source](https://project-dynamo.learn.joinhandshake.com/wrap-up)</sub>

This is the **required validation before you open a PR**. The PR reviewer reads your files but **never builds or runs them** — so you are responsible for proving the finished task actually builds, is solvable, and is graded correctly. Run the full oracle end-to-end on the *completed* task, then work the checklist below.

You need Docker running and Harbor installed — see [Prerequisites](/setup/prereqs) and [Install Harbor](/setup/install-harbor). No model API key is required for an oracle run; the commands live in [Harbor commands](/setup/verify-oracle). Run them from the `task/` directory.

#### Validate the task locally

##### Oracle must pass (reward 1.0)

Builds the single task image, runs your `solution/solve.sh`, then runs the verifier from that same image.

```
harbor run -p . --agent oracle
# expect: reward 1.0
```

Anything less than 1.0 means the task isn't solvable/verifiable as packaged — fix and re-run before going further.

##### Nop must fail (reward < 1.0)

The nop agent does nothing. It must fail — if it passes, the verifier is too weak and is scoring a pass without the work being done.

```
harbor run -p . --agent nop
# expect: reward < 1.0
```

##### Confirm the image is clean

The golden solution and tests must never be baked into the agent image.

```
docker run --rm <repo-name>:dev /bin/bash -lc \
  'find / \( -name solve.sh -o -name test.sh \) 2>/dev/null'
# expect: no output
```

##### Confirm it's repeatable

Re-run the oracle and the nop a second time from a clean checkout. The oracle must score reward 1.0 both times and the nop < 1.0 both times, and the verifier must produce the same reward for the same final state. If results vary, something is nondeterministic — fix seeds/inputs before submitting.

Self-review with the reviewer guideline

Your PR will be graded against the [Reviewer guideline](/reviewing) — the same checklist a reviewer uses. Skim [What only a human can judge](/reviewing/judgment) and [Recording your verdict](/reviewing/scoring) and self-review first. Most rejections are caught by the author in 10 minutes of reading these pages.

#### Final checklist

Each item is pass / fail — if any fails, the task isn't ready.

##### 1 · Scaffold complete

Work through each item.

##### Checklist

0 of 2 complete

Task lives under task/ — task.toml, instruction.md, solution/solve.sh, environment/Dockerfile, tests/test.sh, tests/test_outputs.py all present and filled in.The provided .dynamo/, .github/, and .harbor/ folders are unmodified.

##### 2 · Instruction is Harbor-clean

Work through each item.

##### Checklist

0 of 4 complete

instruction.md is human-written (not LLM-generated), uses absolute /app/... paths, and names every output file explicitly.It describes WHAT to achieve, not HOW — no step-by-step procedure, no mandated tools (except constraints that exist purely to prevent cheating).It does not reveal the solution, and ends with "You have N seconds to complete this task. Do not cheat by using online solutions or hints specific to this task." (N = [agent].timeout_sec).instruction.md is under 1,500 tokens (hard cap).

##### 3 · task.toml complete

The full field-by-field schema and allowed values are on the [task.toml reference](/workflow/step-9) — this checklist only confirms the fellow-set fields are filled. The single-Dockerfile contract these tests run against lives on [Build the Dockerfile](/workflow/step-6).

Work through each item.

##### Checklist

0 of 2 complete

task_objective, artifact_type (lowercase snake_case, from .dynamo/diversity-taxonomy.toml), expert_time_estimate_hours, difficulty_explanation, solution_explanation, and verification_explanation are all filled; category, subcategory, model_tested, and agent_tested are left at their pre-seeded values."[agent].timeout_sec matches the timeout line in instruction.md; environment_mode is left unset — the verifier runs in the environment image and Harbor overlays tests/ at verify time."

##### 4 · Agent image is clean

Work through each item.

##### Checklist

0 of 3 complete

environment/Dockerfile does NOT COPY solution/ or tests/.Input data lives in environment/data/ and is COPYed in; pip dependencies are pinned (apt packages need not be).No answer, ground-truth, or oracle data is reachable anywhere the agent can read.

##### 5 · Outputs ↔ verifier wired

Work through each item.

##### Checklist

0 of 3 complete

The output paths in instruction.md match the paths tests/test_outputs.py reads.Ground-truth / expected answers live in tests/ (added only at verify time, not present during the agent run) — or are recomputed at grade time from inputs the agent can't write. Never derived from an agent-writable path, and never in environment/.One test function per success criterion, each with a docstring; nothing graded that the instruction never states.

##### 6 · Verifier runs correctly

Work through each item.

##### Checklist

0 of 2 complete

tests/test.sh writes the reward to /logs/verifier/reward.txt (1/0, or a fractional score if the task grades partial credit — matching what the instruction promises); tests check the agent's real outputs, not source-code string matching.All verifier dependencies are baked (pinned) into the single environment/Dockerfile; the parent dir of each artifact is pre-created (e.g. RUN mkdir -p /app).

##### 7 · Solvable, novel, and deterministic

Work through each item.

##### Checklist

0 of 3 complete

The task is genuinely solvable and the solution computes the answer (no hardcoded results); solution/ is human-written.The task is novel — not a reworded or reskinned Terminal-Bench 2 or 3 task.Results are deterministic and don't depend on a mutable live service. Open internet is available to the agent, so the answer must not be retrievable online.

The bar for submitting

Treat **oracle 1.0, nop < 1.0, clean image, offline build, repeatable (stable across re-runs)** as the gate. A task that fails the oracle is not Harbor-compliant and is not ready to submit — catching problems now is far faster than round-tripping through the PR.

Once every item is pass, head to **Submitting the PR**. If any item is close-but-not-quite, skim [Common errors and examples](/pitfalls) for the recurring shapes these gates catch.

---

## Task workflow videos

<sub>`/workflow-videos` · nav label: *Video walkthroughs* · [source](https://project-dynamo.learn.joinhandshake.com/workflow-videos)</sub>

Short screen recordings that walk through building a TerminalBench task end to end. Watch them in order, or jump to the stage you're on.

Watch in order the first time

Each clip builds on the one before it — from proposal to merged PR.

### 1. Write the proposal

Make sure to write a proposal and statement that results in a difficult task for the model.

Proposal, workflow, and checklist

### 2. Create the four core components

The four contracts, `instruction.md`, the environment, the solution, and the tests, must agree with each other.

The four core components

### 3. Write good instructions

Describe the goal, not the method — and pin exact input and output paths.

Writing good instructions

### 4. Specify the environment, inputs, and metadata

You must stage input files in the repo for the agent to use. You should also write the Oracle solution and the task metadata in task.toml.

Environment, inputs, and metadata

### 5. Sample instruction.md

Try to stump the model through a well-written instructions.md.

Sample task

### 6. Write the solution

You should write the Oracle solution, verifiers, and run Harbor locally.

Confirm reward = 1 before you push

A reward of 1 means the Oracle Solution passed every verifier. Inspect the logs first.

Write the solution

### 7. Pull request and review

Go through the PR workflow, automated checks, Pass@k evaluation, and human review.

The pipeline has grown since this recording

The checks now include an **AVA (Adversarial Verifier Audit)** layer alongside the Automated Review. For the current end-to-end flow — every check in order and what gates the PR — see [What happens on your PR](/submit#automated-review).

Pull request and review

## Submitting the pr

<sub>`/submit` · nav label: *Ship it* · [source](https://project-dynamo.learn.joinhandshake.com/submit)</sub>

Your work ships as a **pull request from your fork** back to `handshake-project-dynamo/<your-task-repo>`. The PR contains the full task under `task/`: `task.toml`, `instruction.md`, `solution/solve.sh`, `environment/Dockerfile`, `tests/test.sh`, `tests/test_outputs.py`.

### Before you push

Clear the [final checklist](/submit/checklist). The hard gates: the oracle scores **reward 1.0** and the nop agent scores **reward < 1.0**; and `instruction.md` ends with the "You have N seconds…" line (N = `[agent].timeout_sec`).

### Push and open the pr

See [Push and open the PR](/submit/push) for the exact commands.

### What happens on your pr

On every push, automated checks run and post their results as PR comments. Read each comment, fix what it flags, and push again — the checks re-run automatically. Your task is ready when the checks are green and the rubric verdict is **PASS**.

1. Static checks

Structural and formatting rules — paths, Dockerfile hygiene, dependency pinning, the single-verifier setup, and the `instruction.md` timeout line.

Passes when all structural rules are satisfied.

2. Rubric review

An LLM grades the task against the Dynamo rubric and posts a per-criterion PASS/FAIL verdict, including that `environment/Dockerfile` pins its test dependencies for the reused verifier image.

Passes when the verdict is PASS.

3. Duplicate check

Compares `instruction.md` against existing Terminal-Bench task sets.

Passes when the task is novel — not a reworded or reskinned version of a benchmark task.

6. Automated Review

A deep rubric review of the whole task, run after Pass@2 and before Pass@5. Posts a Verdict, Blocking Issues, and Advisory Notes — see [Automated Review](#automated-review) below.

Passes when the verdict is PASS with no blocking issues.

5. Pre-check (Pass@2)

A coding agent attempts the task twice.

Passes when at least one of the two attempts is a valid failure — the task is plausibly hard enough to proceed to Pass@5.

4. Validation

Builds the environment and runs the verifier against both the reference solution and doing nothing.

Passes when the reference solution passes (oracle) and doing nothing fails (nop).

5a. Pass@2 Difficulty Suggestion

Only if Pass@2 fails

Posts a Root cause, a Suggested fix, and optional Also-consider notes.

Not gating — capped at 2/day (UTC).

7. AVA — Verifier Audit

An adversarial audit of the verifier itself, run after Pass@2 and before Pass@5 — see [AVA](#ava-review) below.

Passes when routing is pass, with no blocking (Major) finding.

8. Adversarial Cheat-Pass

Advisory

A red-team pass asking whether the tests can be gamed without solving the task, run with `task.toml` hidden — see [Adversarial Cheat-Pass](#adversarial-cheat-pass) below.

Advisory only — posts a comment but never blocks.

9. Per-Check QC — Task Soundness

A second, independent tier of automated soundness checks and probes across the whole task, run once Automated Review and AVA both pass — see [Per-Check QC — Task Soundness](#qc-task-soundness) below.

Passes when all checks and probes pass clean, with no blocking soundness defects.

10. Agent Trial Results — Pass@5

With the task and verifier now cleared by every review, the coding agent attempts the task five more times.

Passes when the agent fails at least 3 of 5 attempts.

1. Static checks

Structural and formatting rules — paths, Dockerfile hygiene, dependency pinning, the single-verifier setup, and the `instruction.md` timeout line.

Passes when all structural rules are satisfied.

2. Rubric review

An LLM grades the task against the Dynamo rubric and posts a per-criterion PASS/FAIL verdict, including that `environment/Dockerfile` pins its test dependencies for the reused verifier image.

Passes when the verdict is PASS.

3. Duplicate check

Compares `instruction.md` against existing Terminal-Bench task sets.

Passes when the task is novel — not a reworded or reskinned version of a benchmark task.

4. Validation

Builds the environment and runs the verifier against both the reference solution and doing nothing.

Passes when the reference solution passes (oracle) and doing nothing fails (nop).

5. Pre-check (Pass@2)

A coding agent attempts the task twice.

Passes when at least one of the two attempts is a valid failure — the task is plausibly hard enough to proceed to Pass@5.

6. Automated Review

A deep rubric review of the whole task, run after Pass@2 and before Pass@5. Posts a Verdict, Blocking Issues, and Advisory Notes — see [Automated Review](#automated-review) below.

Passes when the verdict is PASS with no blocking issues.

5a. Pass@2 Difficulty Suggestion

Only if Pass@2 fails

Posts a Root cause, a Suggested fix, and optional Also-consider notes.

Not gating — capped at 2/day (UTC).

7. AVA — Verifier Audit

An adversarial audit of the verifier itself, run after Pass@2 and before Pass@5 — see [AVA](#ava-review) below.

Passes when routing is pass, with no blocking (Major) finding.

8. Adversarial Cheat-Pass

Advisory

A red-team pass asking whether the tests can be gamed without solving the task, run with `task.toml` hidden — see [Adversarial Cheat-Pass](#adversarial-cheat-pass) below.

Advisory only — posts a comment but never blocks.

9. Per-Check QC — Task Soundness

A second, independent tier of automated soundness checks and probes across the whole task, run once Automated Review and AVA both pass — see [Per-Check QC — Task Soundness](#qc-task-soundness) below.

Passes when all checks and probes pass clean, with no blocking soundness defects.

10. Agent Trial Results — Pass@5

With the task and verifier now cleared by every review, the coding agent attempts the task five more times.

Passes when the agent fails at least 3 of 5 attempts.

*Blue stages gate the PR. The yellow stage is advisory and never blocks.*

The combined gate — AVA ∪ Deep-Review

The Automated Review (labeled **Deep-Review** in the combined comment) and AVA are a **union**: your task advances only when **both** pass, and either one failing blocks the PR. You only see the combined **AVA ∪ Deep-Review** box when something blocks — on a clean run you just see the individual passing comments.

The difficulty gate

If the agent solves your task **3 or more times out of 5**, it is too easy and is rejected. The agent must fail **at least 3 of 5** attempts. This is the hard, empirical difficulty bar — it's why "is this genuinely hard for an expert?" is the question to keep asking while you build. If a task is failing here, make the core reasoning harder; don't add busywork or crank up compute.

Iterating

When a check fails, its comment tells you what to fix. Edit, commit, and push to the same branch — you do not open a new PR. The comments update in place as the checks re-run.

Pass@ & timeouts

Pass@2 and Pass@5 are the agent-trial layers of the pipeline. **[Understanding Pass@ & Timeouts](/submit/pass-at) is the canonical source** for the bands (0–2/5 accept, 3–5/5 reject), the 3600s ceiling, valid-vs-invalid failures, and the Terminus-2 / GPT-5.4 reference pair. The single-Dockerfile rule the rubric review enforces is defined in [Build the Dockerfile](/workflow/step-6); the full `task.toml` schema lives in the [task.toml reference](/workflow/step-9).

### The four review checks

After Pass@2 and before Pass@5, these four deeper reviews run — Automated Review, AVA — Verifier Audit, and Per-Check QC — Task Soundness all **gate** the PR; Adversarial Cheat-Pass is **advisory only**:

| # | Check |  | What it checks |
| --- | --- | --- | --- |
| 1 | [Automated Review](#automated-review) | 🔵 Gates | Is the *task* sound? |
| 2 | [AVA — Verifier Audit](#ava-review) | 🔵 Gates | Is the *verifier* sound? |
| 3 | [Adversarial Cheat-Pass](#adversarial-cheat-pass) | 🟡 Advisory | Can the tests be gamed? |
| 4 | [Per-Check QC — Task Soundness](#qc-task-soundness) | 🔵 Gates | A second, independent pass of granular soundness checks and probes. |

All four post a **Verdict**; how you act on one is the same for all — see [Acting on a review comment](#acting) below.

### 1. Automated review — Is the task sound?

A deep gap-rubric review of your whole task. It reads your `instruction.md`, `solution/`, `tests/`, `environment/Dockerfile`, and Pass@2 agent traces, and grades roughly two dozen criteria against the same rubric a human reviewer uses. The ones it flags most often:

- **Test coverage** — every requirement in `instruction.md` maps to an assertion; no material behavior is left unchecked.
- **Correct expected values** — the verifier's expected results are actually right (not a buggy golden), with an independent check rather than blind trust in the oracle.
- **Fixture / tamper independence** — ground truth isn't read from an agent-writable path (e.g. `/app/…`) without re-copying it to a trusted location or integrity-checking it.
- **Traceability & consistency** — `instruction → solution → tests` describe the same task; paths, schemas, and limits don't contradict each other.
- **Clean agent traces** — your Pass@2 traces show no reward hacking (no writing to `reward.txt`, no reading `tests/` or `solution/`, no PATH or monkey-patch tricks).
- **Difficulty evidence** — the Pass@2 failures reflect the intended crux, not model-latency timeouts or format artifacts.
- Plus environment/permissions, Dockerfile structuring, line endings, and prompt-injection checks.

It posts a **Verdict** (PASS/FAIL), **Blocking Issues** (each names the file and often the line, and ends with a concrete fix), **Advisory Notes** (never block), and a collapsible **deep-review assessment**: a requirement → assertion map, a Pass@2 trajectory analysis, a domain-expert read, the graded gap rubric, and **CI escapes** — a check on the pipeline itself that flags any misleading result (a defect that slipped a gate, or a check that failed for a non-task reason like a latency timeout).

What a flag looks like

- **Blocking:** "A requirement in `instruction.md` has no matching assertion in `tests/test_outputs.py` — add a test asserting that field's value."
- **Advisory:** "`max_tiles_played` is generated by running the oracle itself, so the verifier fully trusts it — sound now because the oracle is exhaustive, but consider cross-validating with an independent method."

### 2. Ava — Is the verifier sound?

Where the Automated Review grades your task's quality, AVA (Adversarial Verifier Audit) attacks your **verifier**. It works blind — reconstructing what your verifier accepts without trusting your solution — then tries to break the boundary two ways:

- **False accept** — an invalid or adversarial submission that still earns reward 1 (the verifier is too loose).
- **False reject** — a valid, spec-faithful submission the verifier wrongly fails (too strict).

It posts a routing of `pass` or `block` (empty output is treated as a **fail**, fail-closed): Major findings block and each describes the hole plus how to close it; Minor findings are advisory.

What a flag looks like

- **Blocking (Major):** "The verifier loads its ground truth from `/tests/reference_data.npz`, which the submitted module can also read — a submission that does no real work can open that file and echo the reference values. → Move the reference data off any path the submission can read."
- **Advisory (Minor):** "The verifier imports its own oracle module (an import/phase risk) — noted, but does not block."

### 3. Adversarial cheat-pass — Can the tests be gamed? (Advisory)

A focused red-team that tries to build a submission passing every test **without doing the real work** — a stub, a hardcoded answer, a shortcut. It runs with your `task.toml` hidden so it can't lean on your notes, and it **never gates** (it's deliberately excluded from the Pass@5 gate). On FAIL it posts the concrete **exploit** — often the actual code that would pass — plus a fix.

It targets the same weakness as AVA's false-accept, so a FAIL here is a strong signal that AVA or a human reviewer will catch it too. Take it seriously even though it can't block you: fixing it now saves a later rejection. A PASS means it couldn't build a passing-but-wrong submission.

### 4. Per-check qc — Task soundness — Is the task internally sound?

A second, independent tier of automated checks and probes that runs once Automated Review and AVA both pass — dozens of them (41–44 on a typical run), covering things like whether the reference solution actually still passes its own verifier, determinism (no random ports, PIDs, or unseeded randomness in the tests or solution), and correctness properties that can only be confirmed by execution rather than a static read.

Each blocking issue is posted in a three-part format — **What this means** (the general risk), **What we found** (the specific evidence from your task), and **Fix** (the concrete remediation) — alongside a running count of checks passed and any advisory notes. This check **gates** the PR — Pass@5 does not run until it passes.

What a flag looks like

- **Must fix:** "**Oracle Fails Its Own Verifier** — `test_outputs.py`. *What this means:* the task's own reference solution doesn't pass the task's tests, so even a perfect submission may be graded wrong. *What we found:* the reference solution does NOT pass its own verifier (reward=0). **Fix:** fix the reference solution (or the verifier) so `solution/solve.sh` scores full reward under the shipped tests."
- **Advisory:** "Correctness Not Statically Confirmable — `tests/test_outputs.py`: correctness of this task cannot be established statically — multiple graded outcomes require execution and are verified only by running artifacts."

### Acting on a review comment

How to read the PR comments and make a decision

These reviews attack different things, but you act on all of them the same way:

1. **Start at the Verdict.** On FAIL, go straight to the **Blocking Issues** — the fix is written into each one. Fix them, commit, and push; the pipeline re-runs and re-reviews.
2. **Read the Advisory Notes** even though they don't block — they're often the difference between a task that scrapes through human review and one that sails through.
3. **A FAIL is not a rejection.** It's the gate telling you what to fix before Pass@5, part of iterating on the PR — not a decision on your task. And passing the gates doesn't guarantee human acceptance.

When your task is complete, replace the repo's `README.md` with a short description of your task (overview, approach, environment, and how verification works).

### Understanding pass@ & Timeouts

<sub>`/submit/pass-at` · section: **Ship it** · nav label: *Pass@ And timeouts* · [source](https://project-dynamo.learn.joinhandshake.com/submit/pass-at)</sub>

Before a task can be submitted, it runs through an automated evaluation pipeline. This page explains what that pipeline does, how to read your pass@ results, and how to set a timeout — because the most common mistake is misreading a **timeout** as **difficulty**.

A good task is a solvable stump

The **oracle** proves the task is solvable; the **model** must fail **at least 3 of 5** attempts to prove it's hard. The bar is **pass@5 ≤ 2/5**, so **0–2/5 is acceptable** — and a **0/5 is the strongest result**, a fully stumped model. What matters is that the failures are **valid**: the model finishing and getting the answer **wrong** on a fair problem — *not* a **timeout** or an agent/verifier error (those never count). A 0/5 of valid failures is great; a 0/5 of timeouts or an ambiguous prompt is broken, not hard.

#### The evaluation pipeline

Your task moves through these layers in order. It must clear each one to advance:

1. **Proposal** — you write and submit the proposal idea.
2. **Pull request** — you open the PR with the full built task.
3. **Validity check** — an automated LLM check runs on the PR.
4. **Pass@2 at your timeout** — two runs at the timeout you set in `task.toml`. **If either run times out, the task is rejected.** This gate proves the model can finish inside your chosen budget.
5. **Automated Review (gates)** — a deep gap-rubric review runs on your PR. Every Blocking Issue must be fixed and pushed before it passes; Pass@5 runs only after it does. See [Automated Review](/submit#automated-review).
6. **Pass@5 at your timeout** — if all 5 trials *time out*, that's almost always because **your timeout was set too low**, not because the task is too hard. Raise it (up to the 3600s ceiling) and re-run. A task that can't **finish** inside 3600s is broken — but a task the model **finishes and gets wrong** every time (a clean 0/5) is exactly the stump we want.

Pass@2 has a daily run limit

Pass@2 is limited to **6 runs per day, per fellow, per task**. Plan your runs — get the task into good shape locally with the oracle before spending a Pass@2 run.

Pass@5 only runs if Pass@2 is valid

Pass@5 is kicked off automatically — but **only if Pass@2 produced a valid run** (both trials finished inside your timeout without timing out) **and the Automated Review passes**. If Pass@2 fails the gate, or the Automated Review returns a FAIL verdict with Blocking Issues, Pass@5 never runs. Fix the blocking issue first and push — the pipeline re-runs.

3600s is the ceiling for everyone

3600 seconds is the hard maximum timeout across the entire project. Both Pass@2 and Pass@5 run at the timeout you set in `task.toml`, which must be at or below 3600s.

#### Setting your timeout

You set your own timeout and **justify it** — there are no fixed easy/medium/hard tiers. The only rules:

- **Hard cap: 3600 seconds.** Your timeout may not exceed it.
- **The timeout must be long enough for the model to produce an answer.** The challenge is *correctness*, not finishing in time. If the model can't even finish, you've built a speed test, not a difficulty test.

#### Reading your pass@5 Score

The acceptance bar is **pass@5 ≤ 2/5** — the agent must fail at least 3 of 5 attempts.

| Pass@5 result | What it means | Outcome |
| --- | --- | --- |
| **0/5 — valid failures** | Fully stumped, the hardest case: the oracle still solves it and every model failure is a genuine wrong answer (no timeouts/infra/verifier errors). | **Accepted** |
| **0/5 — invalid failures** | Failing for the wrong reason — timeout, agent/verifier error, or an unfair/ambiguous prompt. Broken, not hard. | **Rejected — fix the cause** |
| **1–2 / 5** | Solvable and genuinely hard, with valid failures. | **Accepted** |
| **3–5 / 5** | Too easy — the agent solves it 3 or more times out of 5. | **Rejected** |

#### How difficulty is measured

The recorded pass@5 score must come from the **Terminus-2** agent (via Harbor), run **5 times**, using **GPT-5.4**. Cheaper models (Sonnet, Haiku) are fine for pre-filtering while you iterate, but the number you submit must be measured with the reference model.

| Model | Settings |
| --- | --- |
| **GPT-5.4** | max completion tokens = 128,000; reasoning enabled; effort = `xhigh` |

Record the model in `task.toml` (`model_tested`, `agent_tested`) — see the [task.toml reference](/workflow/step-7).

#### What to do at a 0/5

A **0/5 is great if the failures are valid** — the model finished and got the answer wrong, and your oracle still solves the task. It's only a problem when the failures are **invalid**: a timeout, an agent/verifier error, or an unfair/ambiguous prompt that makes the model fail for the wrong reason. Open the **job analysis** and read the breakdown — valid wrong answers → you're done; invalid → fix the cause:

| Cause | How to fix it |
| --- | --- |
| **Timeout** (the model ran out of time) | Move difficulty into *reasoning*, not computation. Trim expensive steps. Raise the timeout only if justified (≤ 3600s). If it still times out, redesign. |
| **Ambiguous prompt** | Tighten the instruction so there's exactly one reasonable interpretation — the model should fail because the problem is hard, not because the ask was unclear. |
| **Broken or brittle verifier** | Fix it so it tests the real requirement and accepts any sound correct answer. |
| **Not solvable** | Run your **oracle** (`solve.sh`) in a clean container — it must reach reward 1.0. The oracle, not the model, is what proves the task is solvable. |

Not every 0/5 is a good 0/5

A 0/5 is the strongest result **only if the failures are valid** — the model finishing and getting it wrong, with the oracle still solving the task. A 0/5 made of timeouts, agent/verifier errors, or an ambiguous prompt is **broken, not hard**: the model is failing because the setup is unfair, not because the problem is difficult. Check the job-analysis breakdown before you submit.

#### What to do at 3–5/5

The task is too easy (pass@5 > 2/5) — raise the difficulty of getting the answer **right**:

- Add edge cases the model must handle.
- Require multi-step reasoning or interacting layers of complexity.
- Strengthen the verifier so a sloppy-but-close answer fails.

Never game the score

Do NOT lower the timeout or add busywork to push a 3–5/5 down. That makes the task harder to *finish*, not harder to *get right* — it's gaming, and reviewers will send it back. Difficulty must come from the problem, not the clock.

### Final checklist

<sub>`/submit/checklist` · section: **Ship it** · [source](https://project-dynamo.learn.joinhandshake.com/submit/checklist)</sub>

First clear the [build checklist](/wrap-up) — task structure, instruction, Dockerfile, tests, and a genuine solution all live there. This page is the short list of **validation-result gates** to confirm right before you push:

Work through each item.

##### Checklist

0 of 4 complete

Oracle scores reward 1.0 (harbor run -p . --agent oracle); nop scores reward < 1.0 (harbor run -p . --agent nop).The [agent].timeout_sec in task.toml matches the "You have N seconds…" line in instruction.md, and is justified by the oracle's actual runtime (with headroom) — not padded or guessed.Pass@2 cleared the 3600s cap without timing out (see /submit/pass-at).Pass@5 lands in the 0–2/5 band — recorded in the PR. 0/5 (all valid failures, oracle passes, no timeouts) is the hardest case and is good. 3–5/5 means too easy or the verifier is too loose — do NOT submit. A 0/5 from timeouts or ambiguity is broken, not hard — do NOT submit, needs fixing.

### Open your pr

<sub>`/submit/push` · section: **Ship it** · nav label: *Open your PR* · [source](https://project-dynamo.learn.joinhandshake.com/submit/push)</sub>

Push your branch and open the PR against `handshake-project-dynamo/<your-task-repo>`:

```
git add -A
git commit -m "Task submission"
git push -u origin submission
gh pr create --repo handshake-project-dynamo/<your-task-repo> --fill
```

To iterate after reading the feedback, edit your files and push again:

```
git add -A && git commit -m "Address review feedback"
git push
```

The checks re-run on every push and update their PR comments in place. Your task is ready when the checks are green and the rubric verdict is PASS.

#### Pr description template

Use this exact shape for the PR body. It gives reviewers the one-sentence problem, the numbered criteria (mirroring `instruction.md`), your calibration results, and the commands to reproduce.

```
## One-sentence problem
The task is done when ___.

## Success criteria (numbered, mirror instruction.md)
1. ...
2. ...

## Calibration results
- Golden solve.sh:                  reward 1.0
- Bad / nop solution:               reward < 1.0

## How to run
harbor run -p . --agent oracle   # reward 1.0
harbor run -p . --agent nop      # reward < 1.0

## Notes / open questions
Anything in instruction.md you had to interpret.
```

#### AI tool policy

Task descriptions and solutions should be human-written. Other files (Dockerfiles, test boilerplate) may be generated by coding assistants as long as they are human-verified before submission.

### Submit on the platform

<sub>`/submit/platform` · section: **Ship it** · nav label: *Platform submission* · [source](https://project-dynamo.learn.joinhandshake.com/submit/platform)</sub>

Once your PR is open and the automated checks pass, there are a few steps you should perform on the platform to mark the task as ready for review.

#### Before you submit

Make sure the PR is actually green on GitHub. Submitting a task whose checks are still failing wastes a reviewer's slot and bounces straight back to you.

#### Review the checklist and add reviewer notes

Walk through the checklist one item at a time, then add notes that make it easier for a reviewer to evaluate the nuances of your task — anything subtle, tricky, or non-obvious they should know before reading your code.

![Platform checklist and reviewer notes section
</1>](/submit-platform-checklist.png)

#### Attach your pass@ Screenshot and score

You'll find the pass@ results as a comment on the Pull Request tab in the repo — it looks like this:

![Example pass@ results comment from github-actions bot
</1>](/submit-platform-pass-example.png)

Screenshot that comment, attach it on the platform, and enter the pass@ score in the field below.

![Pass@ screenshot upload and score input
</1>](/submit-platform-pass-score.png)

Read the pass@ Job Analysis

Just getting a failed run is not sufficient. The Job Analysis provides insight into why your run passed or failed — use that feedback to improve your task before submission.

## How to stump the model

<sub>`/stump-the-model` · nav label: *Stump the model* · [source](https://project-dynamo.learn.joinhandshake.com/stump-the-model)</sub>

A plain-language guide to the moves that make a task fail a frontier model *fairly*.

The through-line across every strategy: a good stump does not make a task broadly hard. It makes the agent do 90% of the work correctly and then fail on **one decisive point** that is determinate (there is exactly one right answer), but that the agent cannot pattern-match, recall, or self-verify its way past.

The thread through every pattern below: the model stops at the first green result — it tunes to the visible sample, trusts the obvious rule or tool, and never checks the case it can't see.

Every pattern here needs one correct answer

The patterns below make a task hard on purpose — but they only count when the contract has a single, fully determined answer a strong engineer could reach. Difficulty that comes from a spec that contradicts itself or reads two ways isn't a stump; it's a defect that [routes to rejection](/stump-the-model/why-tasks-get-rejected), not difficulty the task gets credit for. Before you lean on any pattern, check that spelling out the deciding rule would still leave the task genuinely hard.

### Stumping patterns

A
The latent crux — the deciding case is invisible in the data the agent sees
▾

Consider a task that asks the agent to compute the total weight of a set of manufactured metal parts from their CAD drawings. The agent is given a handful of sample parts with known correct weights to calibrate against. It correctly extracts the geometry from every drawing, correctly computes areas, looks up the standard sheet-metal gauge-to-thickness table, multiplies through by density, and reproduces every sample weight to the gram. Confident and well-tested, it submits — and fails, because the held-out parts it never saw are made of a different material.

The trap is that the sample was homogeneous along the one axis that actually matters. All the calibration parts were steel, so applying the steel gauge table to *everything* looks flawless in every check the agent can run. Only a non-ferrous part — which uses a different gauge standard — exposes the error, and those exist only in the hidden test set. This is the most common and most effective stump in the corpus because it defeats the agent's own diligence: the more carefully it validates against the provided data, the more confident it becomes in the wrong answer. The technique generalizes to any rule that is real and determinate but simply never *fires* on the visible data — a caching key that only breaks on a repeated request, an off-by-one that only shows past ten records, a policy clause that only binds in a scenario the sample omits.

B
The wrong-default lure — the obvious approach is subtly wrong
▾

Consider a financial reconciliation task where the agent must identify which rows in a ledger are "rollup" rows — parent entries that summarize their children — and exclude them to avoid double-counting. There is an obvious, natural rule staring the agent in the face: a row is a rollup if its account path is a prefix of other rows' paths (e.g. `warehouse/east` is a parent of `warehouse/east/dock-3`). The agent implements exactly this, and it works on almost everything.

The correct rule, though, is not about path *shape* — it is about *value*: a row is a rollup only if its amount equals the sum of its direct children's amounts. Most of the time these two rules agree, which is what makes the lure so effective. They diverge precisely on the "charged intermediate" rows — parents that carry their own charges *in addition* to their children's — and on those the path-shape rule wrongly drops them, silently under-counting. Every failing agent produced a byte-identical wrong answer, because they all reached for the same intuitive shortcut. This strategy works whenever there is a plausible, cheap heuristic that is *almost* equivalent to the correct-but-more-expensive definition; the agent takes the bait because the heuristic passes casual inspection and the gap only appears in cases the agent has no reason to suspect.

C
Misdirection — the environment actively points at the wrong answer
▾

Consider a site-reliability task where a service outage has cascaded across a system and the agent must identify the true root-cause service. To help, the environment ships a diagnostic tool — the kind of internal utility an on-call engineer would reach for first. The agent runs it, the tool confidently names a service, and the agent writes that service down as the answer and finishes, often in under two minutes.

The tool is a plant: it points at a downstream *symptom* service, not the upstream cause. The only way to the right answer is to distrust the convenient conclusion and trace the dependency graph back to the source — work the agent skips precisely because a trusted-looking tool already gave it an answer. What makes this stump reliable is that it weaponizes the agent's own eagerness to close: the misdirection doesn't have to be subtle, it just has to arrive *early* and look authoritative. The same idea covers misleading in-code comments that flag the wrong bug, decoy files or branches that reproduce most of the expected output, and stale-but-official-sounding documentation that contradicts the real machine-readable source of truth. The lesson the task enforces is a real professional skill — verify your tools against ground truth before trusting them — which is exactly why it is fair game.

D
Evidence-forced reverse engineering — recover an undocumented rule from what you can observe
▾

Consider a task where a metrics-rollup service has crashed and its source code is lost, but the agent has the raw input logs and knows what correct output should look like. The agent must reconstruct the service's behavior from scratch. Buried in the data are several undocumented conventions the original code applied: a special sentinel value that means "overflow," timestamps in milliseconds rather than seconds, counters that reset and must be segmented, rate series that are scaled by the scrape interval, and so on. None of this is written down anywhere; it must be *inferred* from the values themselves.

This is hard the way senior debugging is hard — it demands forming and testing hypotheses against evidence — but it is scrupulously fair, because every convention is *forced* by the data. A competent engineer staring at the logs long enough will converge on the same rules, and the task is designed with a wide enough correctness margin that small method differences can't flip the answer. The distinction that keeps this on the right side of the fairness line is crucial: the answer is *discoverable* from material the agent can actually read, even if discovering it takes real work. The same family includes reverse-engineering a custom binary format bit by bit, or recovering an algorithm's hidden constants from the differences between archived input/output pairs — and, in its most elegant form, tasks where the natural modeling choice *structurally cannot* fit the hidden behavior (for example, fitting a smooth function to data whose true rule has a sudden discontinuous jump that no smooth model can represent).

E
The ordering assumption — the data violates a property the agent takes for granted
▾

Consider a task that asks the agent to decode timestamps from a stream of GPS-style navigation records. The hardware encodes the year using a field that wraps around every so often, so recovering the absolute date requires tracking which "cycle" each record belongs to. The natural implementation keeps a running lower bound — each new record must be at least as recent as the last — and this works perfectly on the sample, which is in chronological order.

The hidden log is deliberately *not* in chronological order: partway through, it jumps backward several years. A stateful decoder that assumed monotonic time then adds a spurious extra cycle to every earlier record, throwing the decoded dates off by decades. The correct approach anchors each record independently against a fixed reference rather than carrying forward an assumption about order. This strategy works by exploiting an implicit invariant the agent never consciously chose — "the input is sorted," "records are well-formed," "anomalies are terminal" — and then quietly breaking it in the data the agent doesn't inspect. Because the assumption is never stated, the agent never thinks to question it, and its tests (built on ordered sample data) reinforce the blind spot.

F
The discovery-hop — a final opaque guess with no partial feedback
▾

Consider a security task where the agent must forge an authorization token. It reverse-engineers the cryptographic flaw correctly — that is the genuinely hard, satisfying part — and now needs to supply the right combination of role, scope, and channel to complete the exploit. The catch is that every wrong combination returns the *identical* rejection, with no hint about which of the three fields was wrong.

Because the failure signal carries no information, the agent cannot narrow the search: it faces a joint guess across three opaque values, and one obscure literal it never tries blocks it entirely. This is a real property of the domain — a well-built authorization endpoint *should* fail closed without leaking which field was wrong — so it is defensible as a difficulty source. But it is the riskiest strategy on the list, because it shades easily into unfairness: if the value the agent must guess is genuinely unguessable from anything it can read, the task stops testing skill and starts testing luck. Used well, the discoverable-in-principle constraint (a value hinted somewhere, or derivable from the protocol) keeps it fair; used carelessly, it becomes a coin flip.

G
Multi-mechanism accumulation — many interacting fixes, all required
▾

Consider a task to repair a binary-interface relinker that has eight independent bugs, spanning things like revision handling, symbol binding, alignment, and how a component's "kind" is encoded. Each bug is individually tractable, but they interact, and the grader accepts only a fully correct result. There is no partial credit: fixing seven of eight still scores zero.

This strategy produces difficulty not through any single hard insight but through *breadth under an all-or-nothing bar*. Agents spread out by how many mechanisms they manage to fix — most get one to three, a strong run gets seven — and the pass rate falls out of that distribution naturally. The most instructive failures are the near-complete ones: an agent that fixed seven bugs but wrote a component's raw kind value instead of its encoded rank, an error invisible under the sample (which happened to use the rank-zero case) and caught only by the held-out families. Breadth tasks work best when the individual fixes are genuinely independent — so the agent can't solve them all from one realization — and when at least one of them hides in a case the sample doesn't exercise, combining this strategy with the latent-crux idea from A.

H
Entangled rules — handling each rule correctly still gives the wrong answer
▾

Consider a task that asks the agent to reconstruct the current state of a document-approval system from its full event history — approvals, corrections, resets, and revocations, applied in order. Each rule is simple on its own: an approval marks a record approved, a correction edits a field, a reset clears a run of earlier decisions, a revocation withdraws one. The agent implements each faithfully, replays the log, and produces a clean final state that matches the sample exactly.

It fails because the rules aren't independent — they reach back and change each other. A reset doesn't just stop future decisions; it discards approvals made before it. A revocation doesn't just withdraw one record; it can resurrect a parent that was superseded, which re-validates or invalidates that parent's children. Handled one at a time in file order, each rule looks right and the result is plausible, but the interactions land on a subtly wrong global state — and those combinations appear only in the held-out histories the sample never shows. What separates this from a task with many independent bugs (G) is that fixing "one more rule" never converges: the difficulty is the coupling, not the count. The correct approach reasons about the whole history at once — establish the active epoch, resolve which decisions survive each reset and revocation, then apply the rest in a principled order — rather than folding rules in as they stream by. It's fair because every rule and interaction is fully determined by the data and the spec; the trap is that the natural incremental implementation is exactly the one that misses how events rewrite each other. Generalizes to bitemporal data, ledger reversals, dependency resolution where one choice forbids another, and state machines where a late event changes the meaning of an early one.

Amplified by:
[No self-check](/stump-the-model/amplifiers#amp-selfcheck)
[All-or-nothing](/stump-the-model/amplifiers#amp-allornothing)

I
Stale authority — the "current" value is wrong; use the one that was authoritative at the time
▾

Consider a task that asks the agent to recompute a fund's official end-of-day valuations from a price feed and a set of holdings. The feed carries every price the system ever saw, each stamped with when it was published. The agent joins each holding to its price, totals them, and reproduces every historical statement to the cent — then fails on the days that matter.

The trap is that a valuation must use the price known as of that day's cutoff, not the price that looks current now. Prices get corrected after the fact — a value published late, or a revision that supersedes an earlier one — and using the latest available price silently rewrites history on exactly those days. Every statement in the sample happened to have all its prices in before cutoff, so "use the current value" reproduces them all and looks flawless; the agent has no reason to suspect "latest" and "authoritative-at-the-time" differ. This is a close relative of the latent crux (A) — the deciding case, a late correction, is simply absent from the sample — but it earns its own name because the assumption is so natural and the fix is specific: default code reaches for the current or most-recent value, and that's the wrong one for anything time-scoped. The correct approach treats every lookup as "as of" a moment: among values effective on or before the reference date and published on or before the cutoff, take the most recent, and ignore whatever status the row carries today. Fair because the timestamps and revisions are all present — the agent just has to use them. Generalizes to point-in-time joins, effective-date vs. posting-date accounting, superseding document versions, and identity known only later ("this account was merged after the fact").

Amplified by:
[Silent failure](/stump-the-model/amplifiers#amp-silent)
[No self-check](/stump-the-model/amplifiers#amp-selfcheck)

### Check your understanding — Patterns a–d

Check your understanding — patterns A–D

An agent perfectly reproduces every sample weight in a CAD-parts task, then fails on the hidden set. Which pattern is this?

The wrong-default lure — a plausible heuristic is almost but not quite the correct ruleThe latent crux — the deciding case never appears in the data the agent can seeMisdirection — a trusted-looking tool points at the wrong answerEvidence-forced reverse engineering — an undocumented rule must be recovered from the data

Check answer

### Check your understanding — Patterns e–i

Check your understanding — patterns E–I

A GPS-timestamp decoder assumes the log is chronological and quietly mis-dates every earlier record when the log jumps backward. Which pattern?

The ordering assumption — the data violates an invariant the agent never consciously choseMulti-mechanism accumulation — many independent fixes are requiredEntangled rules — each rule is right individually but they reach back and change each otherStale authority — the "current" value isn't the one that was authoritative at the time

Check answer

### When difficulty is really a defect

Every pattern above earns its difficulty from an answer that's pinned down. The counterexample is the opposite — a real task from client review that looked like a hard statistics stump but was actually just under-specified. Read it and decide whether it's a fair stump before you reveal the critique.

The task

A task ships a district-clustered dataset and asks the agent to estimate a treatment effect, report *its standard error*, and give a 95% confidence interval. Clustering by district is the obvious crux, and the reference solution quietly settles on one specific method — Bell–McCaffrey CR2 with Satterthwaite degrees of freedom. The verifier accepts any standard error between 0.5x and 2.5x the reference, and any interval that merely contains the point estimate. The pass rate is low, so it looks like a hard inference task. Is it a legitimate stump?

See why it isn't a stump

### Check your understanding — Fair difficulty vs defect

Check your understanding — fair difficulty vs defect

A verifier accepts any standard error between 0.5x and 2.5x the reference, and any confidence interval that merely contains the point estimate. What does the wide tolerance band signal?

The task is rigorously calibrated to real statistical uncertaintyThe contract never pinned down what "correct" means, so several defensible answers all passThe verifier is correctly protecting against numerical noiseThe agent has too much freedom in choosing a model

Check answer

---

**Where to go next:** see [Why tasks get rejected](/stump-the-model/why-tasks-get-rejected) for the fairness line these patterns must stay inside, [Amplifiers & fairness](/stump-the-model/amplifiers) for what turns a near-miss into a hard failure, and [Live examples](/stump-the-model/live-examples) for real graded runs mapped back to the patterns above.

### Why tasks get rejected

<sub>`/stump-the-model/why-tasks-get-rejected` · section: **Stump the model** · [source](https://project-dynamo.learn.joinhandshake.com/stump-the-model/why-tasks-get-rejected)</sub>

Almost every rejected task fails for one of five reasons. They all share one root problem: the task shows a low pass rate that looks like difficulty but isn't — the model failed because the task was unfair, not because it reasoned and got the answer wrong. When a reviewer (or now the automated pass@2 check) can fix the flaw and the task suddenly becomes easy, the difficulty was never real.

The one test behind all five

If spelling out the deciding rule makes the task easy, the difficulty was fake. A good task stays hard even when every rule is stated — the model fails because the *problem* is hard, not because it was missing information or misled. Before you harden a task, ask: "with the deciding rule written plainly, would a strong engineer still struggle?" If no, you'll get flagged.

The most common one by far

Across the tasks flagged in review, roughly half failed for the very first reason below — the grader checked a rule the instructions never stated. If you fix nothing else, make sure every rule your verifier enforces is written in the instructions.

#### The five rejection reasons — And how to avoid each

| Reason (plain) | What it is | How to avoid it |
| --- | --- | --- |
| **Grading on a rule you never told the agent** *(undisclosed verifier convention)* | Your verifier requires a format, sort order, tie-break, or convention that `instruction.md` never mentions. Agents solve everything you documented and fail only on the hidden rule. | Write down every rule the verifier checks — output format, ordering, tie-breaks, edge cases — in the instruction (or a file it references). A good check: could a reasonable *different* implementation still pass? If only your exact choice passes and you never stated it, disclose it. |
| **Your task files contradict your instructions** *(contradictory shipped data / spec)* | A data file, config, or the reference solution shipped in the task follows a different rule than the instruction states. An agent that trusts the instruction does the right thing and still fails. | Make the shipped data and your reference solution obey the instruction exactly. Regenerate fixtures if they drift. Never ship a file that says something the instruction contradicts — even one labeled "old" or "not used." |
| **Instructions that read two ways** *(ambiguous spec)* | A term or rule has two defensible readings; the verifier silently accepts only one. The score just measures which reading the model guessed. | When a value can be computed more than one valid way, name the single canonical rule (assignment, priority, tie-break, sort order). Then check: once it's unambiguous, is the task still hard? If not, add a real crux. |
| **The only hard part is the mistake** *(difficulty collapses once the defect is removed)* | The single thing failing the model is one unstated or broken rule. Disclose or fix it honestly and the task is trivial. | Build the difficulty into genuine reasoning that survives full disclosure. If your task only "works" because of one confusing rule, it needs a new hard part, not a patch. |
| **Decoys with no way out** *(misleading / decoy documentation)* | The task points the agent at the wrong answer through an authoritative-looking file, while the real rule hides in something marked "deprecated / superseded / not used" — and nothing the agent can see corrects it. | Misdirection is allowed *only* if the task itself can set the record straight (see Amplifiers & fairness → "No uncorrectable lie"). Never state a wrong rule the agent can't overturn, and don't bury the real rule to manufacture a failure. |

#### Where you'll see this now: Pass@2 In github actions

These used to be caught only later, by a human reviewer. Now the **pass@2 check in GitHub Actions flags them right after it runs** — the analysis of your two trials calls out when the failures look unfair (an undisclosed rule, an ambiguity, a contradiction, a decoy) rather than a genuine miss. **The flag shows up in your PR comments.** Read it before you push further: if it says your failures aren't legitimate, fix the cause — don't try to submit around it.

Finding the pass@2 flag on your PR

Check yourself before pass@2 does

- Run your own oracle from a clean checkout and confirm the failures your trials show are the *intended* crux — not a format, ordering, or naming convention.
- Red flag: if the failing tests are about file existence or output formatting, that's usually an undisclosed convention, not real difficulty.
- Re-read the instruction as if you'd never seen your solution: is every rule the verifier checks actually stated? Can any sentence be read two ways?
- Watch the pass@2 analysis in the PR comments and act on it — a fair 0/5 is great, but a flagged one means fix the cause.

### Amplifiers & Fairness

<sub>`/stump-the-model/amplifiers` · section: **Stump the model** · [source](https://project-dynamo.learn.joinhandshake.com/stump-the-model/amplifiers)</sub>

These are the two dials you tune after you've picked a trap. Amplifiers make the trap hit harder; fairness keeps it honest — hard for a real reason (skill), not because it's impossible or down to luck. Turn the amplifiers up as far as the fairness lines allow.

#### Amplifiers

amplifier

##### Silent failure — the wrong answer looks normal

No crash, no error, so the model gets no hint it's off and stops. (If it had crashed, it would keep fixing.) Lever: make every wrong answer a believable near-miss, never an error.

amplifier

##### No self-check — the model can't grade itself

The real grading runs on hidden cases the model never sees, so matching the sample only feels like success. Lever: keep the sample friendly-looking but unrepresentative, and grade on held-out cases.

amplifier

##### All-or-nothing — mostly right scores zero

With no partial credit, one wrong piece fails the whole thing. Use it when the answer is a single correct artifact, not when partial progress should count.

#### Fairness principles

Keep the trap a test of skill, not luck:

- ✓

  Figure-out-able. The answer must be recoverable from what the model is given — not secret or impossible.
- ✓

  Real skill. It should punish a mistake a pro could avoid, not a random gotcha.
- ✓

  Fair margins. Don't let pass/fail hinge on a hair-thin tolerance — the idea should decide it, not the threshold.
- ✓

  No uncorrectable lie. It's fine to hide the deciding case, but don't state a wrong rule that nothing in the task can set straight.

#### The gut check

Would a human expert, seeing only what the model sees, get it right — and call the failure fair? Yes to both = a good trap. If they'd be stuck too, it's testing luck — cut it.

### Live examples

<sub>`/stump-the-model/live-examples` · section: **Stump the model** · [source](https://project-dynamo.learn.joinhandshake.com/stump-the-model/live-examples)</sub>

Companion to the [How to stump the model](/stump-the-model) page. That page describes the traps and winning moves in general; this one shows the **actual graded runs** — the task exactly as the model saw it (`instruction.md`), the exact wrong answers it produced, and, from the automated post-run analysis, where and how it went wrong.

#### Plain-language key

| Term | What it means |
| --- | --- |
| **trial / run** | One independent attempt at the task by the model. Each task here was attempted 5–8 times. |
| **pass@8 / pass@5** | "Attempted 8 (or 5) times." "0/8 fail" = wrong on all 8; "5/8 fail" = wrong on 5 of 8. |
| **Terminus-2** | The wrapper that lets the model use a terminal, edit files, and run tests. |
| **Opus-4.8 / GPT-5.4** | The two frontier AI models tested. |
| **golden / reference** | The correct answer, or the author's correct solution. |
| **grader / verifier** | The automated test that decides pass or fail. |
| **held-out** | Hidden test inputs used only for grading — never shown to the model while it works. |
| **post-mortem (`analysis.md`)** | An automatically-written report explaining why each run passed or failed. |
| **budget** | The time limit the model had for the task (e.g. 900 s = 15 min). |

#### Overview

[1
Opus-4.8
5/8 fail

bytecode-vm-debug

Fixed the obvious bug, never ran a subtraction test → `-7` where `7` was right.](#live-bytecode)
[2
Opus-4.8
8/8 fail

accrued-interest

Skipped the UK-gilt ex-dividend rule → `+1.833791` instead of `-0.041209`.](#live-accrued)
[3
Opus-4.8
8/8 fail

gnss-log-decode

Decoded bytes perfectly, then used one satellite system's clock rules for all → timestamps ~20 years off.](#live-gnss)
[4
GPT-5.4
5/5 fail

experiment-readout

Used per-session instead of per-user statistics → error bar ~5× too small, called a non-result "significant".](#live-experiment)
[5
GPT-5.4
5/5 fail

legacy-formatter-clone

Tried every known checksum instead of rebuilding the custom one by algebra → every checksum wrong.](#live-formatter)

#### The failures in detail

1. bytecode-vm-debug
Opus-4.8
5/8 fail
expert: 0.5 h
[Trap A — Latent crux](/stump-the-model#pattern-a)
▾

Software Engineering / Compilers & interpreters

The task (`instruction.md`)

```
/app/vm.py is a stack-based bytecode VM. /app/compiler.py provides a compile_source() function that translates a Python subset into bytecode dicts that the VM executes. The programs in /app/programs.py should all produce the expected output.

Run the test suite to check:

cd /app && python3 run_tests.py

Fix any bug(s) you find. You may modify /app/vm.py. If the compiler has a bug, write a correct /app/compiler.py that exports compile_source(source) — replacing the existing file is fine. Do not modify programs.py or run_tests.py.

You have 900 seconds to complete this task. Do not cheat by using online solutions or hints specific to this task.
```

###### What the model did

It found and fixed the obvious bug, ran the example programs, saw them all pass, and declared itself done — with most of its time still unused.

###### Where it failed

A second bug only shows up on subtraction (where order matters), and the examples used only addition and multiplication, so it never appeared. On the hidden tests, subtraction came out negated — the model answered `-7` where the right answer was `7`.

Failing tests (all 5 failing runs): `test_sub_simple`, `test_sub_larger`, `test_sub_as_arg`, `test_two_subs_added`.

| Case | Correct | Model |
| --- | --- | --- |
| subtract(10, 3) | `7` | `−7` |
| multiply(subtract(6, 2), 3) | `12` | `−12` |
| two subtractions added together | `13` | `−13` |

###### How it failed

It stopped as soon as the examples passed — most runs quit in **77–137 seconds of a 900-second budget**.

###### What the model was thinking

- `task__qb36MJV` — *"there might be something in the compiler I'm missing"* — then stopped.
- `task__dWaPPqs` — *"I should scan to catch any other potential issues"* — but never did.
- `task__oCQbCrw` — noticed the parameter order was *"reversed,"* then dismissed it as harmless *"since addition is commutative."*
- `task__R4zHkWc` — worked out both bugs, but ran out of time having made no edits.

2. accrued-interest
Opus-4.8
8/8 fail
expert: 3 h
[Trap A — Latent crux](/stump-the-model#pattern-a)
▾

Regulated Knowledge Work / Finance & quantitative workflows

The task (`instruction.md`)

```
At `/app/data/trades.csv` is a set of government-bond secondary-market trades, and `/app/data/expected.csv` gives the correct accrued interest for each of those trades. Each trade row has: `trade_id`, `market` (the issuer/market code, e.g. `UST`, `UKT`, `DBR`), `coupon_rate` (annual, in percent), `maturity` (ISO date), `settlement` (ISO trade-settlement date), and `nominal` (face amount traded).

Write a program at /app/solve.py that computes the accrued interest for each trade. It will be invoked as:

```
python3 /app/solve.py &lt;trades_csv&gt; &lt;output_csv&gt;
```

reading a trades file in this same format — it will be run on other trade files, not just the sample — and writing &lt;output_csv&gt; with the header trade_id,accrued_interest and one row per input trade, in the input order.

Accrued interest is the coupon interest that has built up on the bond as of the settlement date, computed according to the standard market conventions for the bond's market — including how that market lays out its coupon schedule and how it measures accrued interest. Different markets do not all follow the same conventions. The sample trades.csv and expected.csv let you check your implementation against known-correct results.

Report accrued_interest as a number for each trade (scaled to the trade's nominal). Use the trade_id values exactly as given, and emit one output row per input trade. Depend only on the Python standard library and compute the result yourself — no third-party packages and no network access.
```

###### What the model did

It figured out the interest formula from the sample (which was all US bonds) and matched every sample answer exactly. It even handled the German bonds' yearly-coupon rule correctly.

###### Where it failed

The hidden tests included UK bonds bought just before a payout, where the interest is actually negative (a rebate). The sample never showed that case, so the model gave a normal positive number — about `+1.83` where the right answer was `-0.04`.

Failing tests (all 8 runs): `test_accrued_interest_matches`, `test_ex_dividend_negative_accrued`.

| Case | Correct | Model |
| --- | --- | --- |
| a UK bond bought inside the ex-dividend window | `−0.041209` | `+1.833791` |

###### How it failed

Most runs actually named the UK rule and then dropped it.

###### What the model was thinking

- `task__7H6xE5e` — the ex-dividend rule *"probably isn't being tested."*
- `task__6N63E6j` — *"likely beyond the scope."*
- `task__LHEcdEM` — *"feels risky and error-prone."*
- `task__QLBYqEC` — *"probably won't be tested in a generic problem."*
- `task__rc4rC3a` — *"not certain it's what they're testing for."*
- `task__NhZYM53` — treated UK gilts as *"identical to US Treasuries."*

3. gnss-log-decode
Opus-4.8
8/8 fail
expert: 3 h
[Trap E — Ordering assumption](/stump-the-model#pattern-e)
▾

Security / Reverse engineering

The task (`instruction.md`)

```
A multi-constellation GNSS receiver records its navigation fixes as a binary log. You are given the firmware's log-reading utility /app/gnsslog (a stripped ELF), one sample log /app/capture.bin, and /app/samples.txt showing the expected decoded output for that sample log.

Running the tool:

```
/app/gnsslog --version        prints the firmware banner
/app/gnsslog &lt;capture.bin&gt;    prints the raw navigation fields of each fixed-size record: sys (satellite system), wn (week), tow (time of week), val (raw reading), flags
```

It prints the fields exactly as stored and does not convert them. Reverse engineer /app/gnsslog and the log format, then write /app/solve.py that fully decodes a log.

When run as:

```
python3 /app/solve.py &lt;capture.bin&gt;
```

it must print one line per record, in file order, each line being:

```
&lt;UTC timestamp, ISO-8601 'YYYY-MM-DDTHH:MM:SSZ'&gt; &lt;calibrated reading to exactly 4 decimal places&gt; 0x&lt;flags as 4 lowercase hex digits&gt;
```

i.e. the receiver fix time expressed as a UTC timestamp, the reading converted to its real engineering value, and the flags. Your output for /app/capture.bin must match /app/samples.txt exactly.

/app/solve.py must compute the decode itself and be self-contained: it must not invoke or depend on /app/gnsslog (the utility will not be present when your program is graded) and must not require network access. It will be graded on other log files in the same format, recorded by the same receiver across its operating life, so handle the full range of values the format can carry — not only those resembling the sample.

Do not modify /app/gnsslog or /app/capture.bin. Only /app/solve.py is graded.

You have 3600 seconds to complete this task. Do not cheat by using online solutions or hints specific to this task.
```

###### What the model did

It decoded the raw data perfectly — the readings and flags all matched the sample.

###### Where it failed

It assumed time only moves forward and stays in one era. But the device's week counter wraps around roughly every 20 years, and different satellite systems count time differently. On the hidden logs, which span several eras, its timestamps came out about **20 years off**.

Failing test (all 8 runs): `test_fresh_captures_span_eras` — the other 4 structural tests passed.

| Case | Correct | Model |
| --- | --- | --- |
| a fix that crosses the ~20-year week rollover | `2017-06-10T11:44:28Z` | `2037-01-24T11:44:28Z (≈20 yrs off)` |
| an older fix from an earlier leap-second era | `2007-07-07T10:30:23Z` | `2007-07-07T10:30:19Z (4 s off)` |

###### How it failed

Several runs flagged the wrap-around risk and then dismissed it, so they shipped a single-era guess.

###### What the model was thinking

- `task__NyqZrq2` — flagged the week-rollover risk in its reasoning, then dismissed it.
- `task__wfyqoZa` — same: noticed the rollover risk, shipped a single-era guess anyway.
- `task__CCF7akK` — flagged the rollover, then committed to one era.
- `task__b7NrWpT` — also dropped the BeiDou branch, treating the satellite-system field as *"informational."*

4. experiment-readout
GPT-5.4
5/5 fail
expert: 3 h
[Trap B — Wrong-default lure](/stump-the-model#pattern-b)
▾

Data Science & Reporting / Experiment & metrics analysis

The task (`instruction.md`)

```
I need the readout for our checkout-flow rollout. During the rollout window the site served each user one of two variants; `/app/data/assignments.csv` (`user_id,variant`) maps each user to `control` or `treatment` — one row per user, fixed for the whole period. `/app/data/events.csv` (`session_id,user_id,session_ts,revenue`) is the raw session export from the platform, one row per checkout session with revenue in USD. Known quirks of this export: client retries sometimes write the same session more than once (same `session_id`; keep the earliest-timestamped record and count each session once), timestamps appear in two formats (both UTC), and sessions from crawler accounts we have already identified must be excluded — those `user_id`s are listed one per line in `/app/data/bots.txt`. Sessions from users that never appear in the assignment table are stray traffic and must also be dropped. Apply the cleaning in that order: retry dedup first, then crawler removal, then stray-traffic removal.

Write a Python 3 program at /app/solve.py that is invoked as:

python3 /app/solve.py &lt;events_csv&gt; &lt;assignments_csv&gt; &lt;bots_txt&gt; &lt;out_json&gt;

and writes the readout as JSON with exactly this schema (normative):

{
"date_range": {"start": "YYYY-MM-DD", "end": "YYYY-MM-DD"},
"data_quality": {
"duplicate_events_dropped": <int>,
"bot_sessions_removed": <int>,
"unassigned_sessions_dropped": <int>
},
"daily_revenue": {"YYYY-MM-DD": {"control": <float>, "treatment": <float>}, ...},
"control":   {"users": <int>, "sessions": <int>, "total_revenue": <float>, "revenue_per_session": <float>},
"treatment": {"users": <int>, "sessions": <int>, "total_revenue": <float>, "revenue_per_session": <float>},
"absolute_lift": <float>,
"standard_error": <float>,
"p_value": <float>,
"significant_at_0.05": <bool>
}

date_range spans the earliest to latest UTC calendar date among retained sessions. Each data_quality counter is the number of event rows removed at that cleaning step. daily_revenue has one entry per UTC date from start to end inclusive, with each variant's summed revenue for that day (a variant with no retained sessions that day reports 0.0). Per variant: users is the number of distinct users with at least one retained session, sessions the retained session count, total_revenue the summed revenue, and revenue_per_session total revenue divided by sessions. absolute_lift is treatment minus control revenue_per_session. standard_error is the standard error of that lift, p_value the two-sided p-value for the difference, and significant_at_0.05 is true iff p_value is below 0.05. Report floats with at least 6 significant digits.

Run your program on the shipped export and write the result to /app/output/result.json. The correct readout for this sample export, floats rounded to 2 decimal places, is provided at /app/data/expected_result.json so you can validate your implementation end to end. Your program will also be run on other exports from the same platform — same schema and cleaning quirks, different traffic — so compute everything from the input files; nothing specific to the sample may be assumed or hard-coded.
```

###### What the model did

It cleaned the data and got every number right except the error bar, which it computed by treating each session as its own independent data point — the standard, obvious way.

###### Where it failed

The test split whole users into groups, and each user had many sessions, so sessions aren't independent. The correct error bar is about **5× larger**. On the hidden data the model's error bar was far too small, turning a "no real effect" into a false "significant."

Failing test (all 5 runs): `test_heldout_inference` — the other 14 of 15 tests passed.

| Case | Correct | Model |
| --- | --- | --- |
| the error bar | `0.6341` | `0.1265 (≈5× too small)` |
| the significance verdict | `not significant` | `"significant" (false positive)` |

###### How it failed

One run even computed the correct error bar, saw both versions matched on the sample, and then picked the wrong one.

###### What the model was thinking

- `task__Qt7tWEY` — computed both the correct (per-user) and the wrong (per-session) error bar, saw they matched on the sample, and picked the wrong one.
- `task__fKhtNFn` — *"if user-level ratio deltas were important, they would have mentioned computing per-user revenue per session."*
- `task__njC7fbq` — implemented the same per-session method a different way — still wrong.

5. legacy-formatter-clone
GPT-5.4
5/5 fail
expert: 8 h
[Trap D — Evidence-forced reverse engineering](/stump-the-model#pattern-d)
▾

File & Media Operations / Text editing & manipulation

The task (`instruction.md`)

```
The directory `/app/data/samples/` holds 36 documents from a plant-engineering memo archive. Each document appears twice: `sNN.src` is the marked-up source, and `sNN.txt` is the exact page image that PAGEFORGE, the company's retired in-house text formatter, produced from that source when the archive was printed. The source dialect is documented in `/app/data/MARKUP.md`. No other documentation of the formatter survives: the archived `.txt` outputs are the normative and complete specification of its rendering behavior, byte for byte — line filling and spacing, pagination, page furniture, and the per-page audit field are all defined by them.

Reimplement the formatter. Write a self-contained Python module at /app/render.py exposing a function render(source: str) -&gt; str that, given the contents of any well-formed .src file from this archive, returns the complete formatted page image exactly as PAGEFORGE would have emitted it, byte for byte, including the trailing newline.

/app/render.py must be pure computation over its source argument. It may import only these standard-library modules: re, math, itertools, functools, collections, string, typing, dataclasses. It must not read or write files, use the network, start processes, or use dynamic code or reflection. A static screen runs before the module is imported and rejects: any import outside the list above, relative imports, the names open, eval, exec, compile, __import__, getattr, setattr, delattr, vars, globals, locals, input, breakpoint, any double-underscore name or attribute (other than __name__), and any attribute that names an OS, interpreter, or import-system facility (for example sys, os, io, subprocess, importlib, builtins, modules, open, system, popen, environ). The module is then executed in an isolated subprocess with no access to the verifier. render() must be deterministic and must not carry state between calls; solve the task by actually reproducing the formatter, not by locating its output.

The verifier grades /app/render.py exactly as it exists on disk — there is no separate submission step, nothing outside the file is considered, and a module that reproduces only some documents correctly is still scored on exactly those. The 3 success criteria below are verified independently.

Success criteria:

1. /app/render.py exists, passes the static purity screen described above, imports cleanly, and exposes a callable render that returns a str for a well-formed source document.
2. For every archived sample, render() applied to the sNN.src content returns a string byte-identical to the corresponding sNN.txt content.
3. For a set of held-out documents from the same archive — well-formed sources in the same dialect, not shipped under /app — render() output is byte-identical to the retired formatter's output for each document.

Do not modify anything under /app/data/; grading uses pristine copies of the archive.
```

###### What the model did

It rebuilt the page layout almost perfectly — the body of every page matched. The only thing off was the footer check-code.

###### Where it failed

That check-code is a custom, home-made formula. Every run tried a long list of famous formulas hoping one would fit, none did, and left the code blank on every page.

Failing tests (all 5 runs): `test_sample_fidelity` and `test_heldout_fidelity` (plus `test_module_contract` for the 2 runs that never saved a file).

| Case | Correct | Model |
| --- | --- | --- |
| a page's footer check-code | `7FD2FCAC` | `00000000 (blank on every page)` |

###### How it failed

None worked the formula out from the examples using math, which is the only way to get it — two runs ran out of time still trying famous formulas.

###### What the model was thinking

- `task__YHLhbjv` — built a fully correct page renderer in a scratch folder (36/36 pages), then spent ~44 minutes trying named checksums and never saved the working file.
- `task__PvSRGTH` — stayed in diagnostic mode the whole run; never saved a solution.
- `task__2DnXSgL` — tried the math approach once, but on the wrong slice of bytes, then went back to named formulas.

#### How these line up with the strategies

Each example maps to a solver-playbook winning move and a stumping pattern. The key check: **the mistake each strategy predicts is exactly the mistake the runs show** — so the strategies come from the real failures, not the other way round.

| Example | Main solver move | Also | Pattern | Does the predicted mistake match what really happened? |
| --- | --- | --- | --- | --- |
| 1 bytecode-vm-debug | **#13** keep checking after green | #1 | [A](/stump-the-model#pattern-a) sample hides it | ✅ fixed bug 1, saw 8/8 green, quit in 77–137 s of 900 s without the subtraction test |
| 2 accrued-interest | **#9** apply the right convention | #1, #13 | [A](/stump-the-model#pattern-a) expert knowledge | ✅ used the sample's US conventions; skipped the UK ex-dividend rule |
| 3 gnss-log-decode | **#6** put on one common footing | #9, #1, #13 | [E](/stump-the-model#pattern-e) | ✅ decoded perfectly, then used one satellite system's clock for all |
| 4 experiment-readout | **#7** stats at the right unit | #13 | [B](/stump-the-model#pattern-b) hidden grading | ✅ used per-session stats, not per-user — exactly #7's predicted default |
| 5 legacy-formatter-clone | **#4** rebuild, don't guess | #3 (the layout part) | [D](/stump-the-model#pattern-d) | ✅ tried every known checksum, never rebuilt it — exactly #4's predicted default |

**Verdict: aligned.** Example 5 is listed under both #3 (rebuilding the page layout, which the model got *right*) and #4 (the checksum, which it got *wrong*); the failure is the #4 part. Move #13 (*keep checking after green*) is the common thread across all 5.

### Update log

<sub>`/stump-the-model/update-log` · section: **Stump the model** · [source](https://project-dynamo.learn.joinhandshake.com/stump-the-model/update-log)</sub>

Dated log of additions to the **How to stump the model** section. Update this page every time a strategy is added, revised, or a new live example is recorded.

#### July 11, 2026

- **Why tasks get rejected** — Added a new page in the section covering the five reasons tasks fail illegitimately (undisclosed verifier convention, contradictory shipped data, ambiguous spec, difficulty that collapses under disclosure, uncorrectable decoys), how to avoid each, and the new pass@2 GitHub Actions flag (with video) that surfaces these on your PR.

#### July 7, 2026

- **Section created** — Added "How to stump the model" with Strategies (A–G), Amplifiers & fairness, an empty Live examples page, and this update log.

---

## Reviewer guide

<sub>`/reviewing` · nav label: *Review tasks* · [source](https://project-dynamo.learn.joinhandshake.com/reviewing)</sub>

Project Dynamo — reviewer guide

This section is for **reviewers** on Project Dynamo. Every submitted task is reviewed twice on the platform before it moves to Pending Pass@ — Review 1 makes the call, Review 2 is a second pass over that call. Your job as a reviewer is to reach the correct verdict (**Accept, Revise, or Reject**) on each submission and leave feedback the attempter can act on.

### Overview

You review a real Terminal-Bench task a fellow built and decide whether it can go forward. Reviews are entirely **reading and judgment** — the automated layers already built the image, ran the oracle, ran an automated gap-rubric review, and executed pass@5. You are the layer that catches the things a machine can't reliably judge: coherence across files, genuine difficulty, realism, ambiguity, verifier robustness, and whether the task is solvable as packaged.

The automated reviewer is a floor, not a ceiling

Before a task reaches you, an **Automated Review** applies the same gap rubric you use and **gates the PR** — all Blocking Issues must be fixed before pass@5 runs. Treat it as a floor: it catches the obvious gaps, but **you are stricter**. A task that passed the Automated Review can still be Revised or Rejected on the judgment calls a machine can't reliably make.

For the full walkthrough — what the machine already did, how to prep for a review, the judgment areas, scoring, and how to record your verdict in HAI — see [Reviewer guidelines](/reviewing/guidelines).

Reviewers are paid at an hourly rate across every tier of the ladder below.

### Reviewer flow

Reviewers move through a promotion ladder based on how closely their calls align with high-quality R2 reviewers.

1

##### Onboarding Reviewer

When you're first promoted into reviewing, you start as an Onboarding Reviewer. Your reviews are graded and compared against the R2 review on the same task to measure alignment.

2

##### Unthrottled Reviewer

Consistent, high alignment with R2 on your reviews promotes you to Unthrottled Reviewer. A portion of your tasks will still be routed through the R2 layer so we can keep tracking the quality of your reviews.

3

##### R2 Reviewer

Exceptional review performance and very high alignment with the high-quality specialists already in R2 can lead to promotion into R2 itself — the final review layer on the platform.

**Related:** [Reviewer guidelines](/reviewing/guidelines) · [The judgment areas](/reviewing/judgment) · [Scoring: checkboxes and the 1–5 score](/reviewing/scoring) · [Recording your review in HAI](/reviewing/recording)

### Reviewer guide

<sub>`/reviewing/guidelines` · section: **Review tasks** · nav label: *Guidelines* · [source](https://project-dynamo.learn.joinhandshake.com/reviewing/guidelines)</sub>

Project Dynamo — reviewer guide

This guide is for **reviewers** on Project Dynamo. You already know how to build a strong Terminal-Bench task. This guide teaches the other side of the table: reaching the correct verdict (**Accept, Revise, or Reject**) on each task submission, with feedback the attempter can act on. Every task is reviewed twice on the platform before it moves to Pending Pass@. Review 2 is a second pass over Review 1's call.

#### 1. Your role: From building tasks to judging them

As a reviewer you look at a real Terminal-Bench task a fellow built and decide whether it can go forward. You assess the **whole task**, meaning the proposal and the task repo. Every review ends in one verdict (Accept, Revise, or Reject), plus a **1–5 Standard Quality Score**, **issue checkboxes**, a **comment**, and (in Review 1) a **Task Verdict** and **Fellow Verdict**.

Two things change from your work as an attempter.

You do **not** build, run, or execute anything; the automated layers below already did that. Your review is entirely **reading and judgment**: the subjective quality calls a machine can't reliably make. They span the whole task: whether it's hard enough, whether it's realistic, whether the pieces gel together, whether the verifier is robust, whether it's genuinely solvable.

And you judge the task as a **domain expert** would. Is it genuinely hard, fair, and correct? The task being hard for *you* is fine. You are judging the task's design, not your own ability to solve it.

The mindset

A task can pass every automated check and still be a bad task: incoherent across its files, too easy under the surface, ambiguous to a real practitioner, gradable by luck, or solvable by a trick. You are the layer that catches that, by **reading** the proposal and repo rather than running anything. These calls carry equal weight.

Your job is the judgment automation can't be trusted on

Static checks can't see it, and an LLM grades it unreliably. Read the task as the **domain expert who would be paid to do this work** and judge:

- Do all the pieces gel together, with instruction, solution, tests, and environment all serving the *same* task?
- Is the task genuinely solvable as packaged, and does the solution actually solve the *stated* problem (not a narrower one)?
- Is it *genuinely* hard for an expert, or just hard-looking, tedious, or high-volume?
- Is the scenario realistic, and is the problem novel for this domain?
- Could a *sound* alternative expert method fail the verifier (ambiguity)?
- Is the verifier robust, with tolerances calibrated, no domain-specific shortcut or reward hack, and no answer the agent was never given (hidden knowledge)?
- Do the tests grade exactly what the instruction states, no more and no less?
- Does the solution genuinely compute the answer, or echo/hardcode it?

Each of these is covered one by one in [The judgment areas](/reviewing/judgment#4-the-judgment-areas).

#### 2. What the machine already did — And how far to trust it

By the time a task reaches you, several layers have already run. They fall into two groups.

Ignore entirely — handled internally, not your review scope

- **Duplicate check against Terminal-Bench**: confirms the task isn't a near-duplicate of a prior submission. This isn't something a human can feasibly re-verify at this submission volume, and if it misses something, tuning it is on the Dynamo team.
- **Task validation results**: the platform builds the Docker image, runs the oracle (the task's own solution script) against the tests (all should pass), and runs a no-op test without the solution (which should fail). This mechanically exercises solvability and basic verifier strength. Assumed to be working as intended, so don't re-verify it.
- **Proposal gate**: the proposal already passed an automated LLM rubric check for specificity and difficulty.
- **Pass@2 at 3600s**: an upstream cost gate only. These two runs decide whether the more expensive pass@5 is worth running; they are not part of your review. Every task that reaches you already has a pass@5, which carries far more signal about what the agents are doing, so judge the task on that. Disregard the pass@2 result even when it failed — a task that missed pass@2 but sits in the 0–2/5 pass@5 band is fine and should not be sent back on that basis.
- **Pass@5 at the author's chosen timeout**: five runs. The task was blocked only if the failures were **invalid** (timeouts or agent/verifier errors). A clean 0/5 with valid failures passes through as the hardest case.

Read, but verify — an LLM first pass over the same criteria you judge

- **Static checks on the PR**: LLM-based validations of file structure and content quality: coherence, difficulty, realism, novelty, solvability, ambiguity, verifiability, docstrings, cheat-resistance, solution quality, plus mechanical items (absolute paths, dependency pinning, Dockerfile hygiene, declared output files).
- **LLM rubric eval on the PR**: an automated pass over the full task rubric. Note: in the review tool this and the static checks often surface together as one combined checks panel, so you're not missing a second layer if you only see one section.

These two are fallible LLM judgments about exactly the things your review exists to judge. **Always read their notes section**, which flags likely issues worth a deeper look, but treat green as a hint rather than a verdict: your own read of the files overrides theirs in both directions.

How to read the PR comments and make a decision

Format, packaging, obvious path/dependency errors, and "does the oracle pass" are largely covered by these layers. What is *not* pre-filtered for you is whether the pass@5 failures are actually **valid** failures. That's still your call ([The core skill: valid vs. invalid failures](/reviewing/judgment#5-the-core-skill-valid-vs-invalid-failures)).

#### 3. Before you judge

Work through each item.

##### Checklist

0 of 6 complete

Read the approved proposal and the fellow's task notes. Open the full task repo: instruction.md, task.toml (difficulty / solution / verification explanations), environment/, solution/, tests/, Dockerfile.Note the exact latest commit hash on the PR. You'll record it in HAI and review that commit (see [Recording your review in HAI](/reviewing/recording)).Skim the PR's commit history for signs of manufactured difficulty, e.g. a clarifying instruction removed so that passing trials would start failing (see the [Decision rule](/reviewing/judgment#6-the-verdict-accept-revise-reject)).Check for previous reviewer feedback. If the task was reviewed before, first confirm the fellow implemented the required changes.Open the pass@5 analysis — it's posted as a comment on the PR (click "Pass@ Analysis," or copy the comment's markdown) — and note the recorded score.Read the static-check notes for anything they flag.

Walkthrough: Review of one example task end-to-end, covering the same flow this guide lays out.

Reviewer walkthrough

Then work through the judgment areas below, reading as a domain practitioner. Afterwards, record your verdict, 1–5 score, and feedback in HAI ([Recording your review in HAI](/reviewing/recording)).

**Related:** [The judgment areas](/reviewing/judgment) · [Scoring: checkboxes and the 1–5 score](/reviewing/scoring) · [Recording your review in HAI](/reviewing/recording)

### Judgment areas, valid failures, and the verdict

<sub>`/reviewing/judgment` · section: **Review tasks** · nav label: *Judgment* · [source](https://project-dynamo.learn.joinhandshake.com/reviewing/judgment)</sub>

#### 4. The judgment areas

You are the domain expert for this task, so evaluate each area below with the same rigor you'd apply to this work professionally. Record what you find using the issue checkboxes and quality score ([Scoring](/reviewing/scoring)).

##### The task as a whole

| **Judgment call** | **How to test it** | **If it fails → checkbox** |
| --- | --- | --- |
| **Everything gels together** | Do `instruction.md`, `solution/solve.sh`, `tests/`, and the Dockerfile all describe and serve the *same* task? Does the environment provide what the solution needs; does `solve.sh` produce exactly the artifacts the tests read; do the tests check what the instruction asks for? A task where the pieces drift apart is broken even if each file looks fine alone. | **Instruction contain incorrect or irrelevant info** / **underspecified** as fits + comment |
| **Genuinely solvable** | From the instruction and the solution, does a real solution path exist, and does `solve.sh` actually solve the *stated* problem, not a narrower or different one? (The author's oracle passed; your job is to confirm it passes by solving the real task, not by sidestepping it.) | **Other** + comment: "not genuinely solvable / solves a narrower task." |

##### Difficulty & realism

| **Judgment call** | **How to test it** | **If it fails → checkbox** |
| --- | --- | --- |
| **Genuinely hard for an expert** | Would a competent domain expert (or an average undergrad in a few days) crack it quickly? Is the difficulty real reasoning, system design, or methodological judgment, or just tedium, volume, or obscure recall? | **Other** + comment: "too easy / difficulty is busywork." |
| **Not a kitchen-sink task** | Does the difficulty come from piling on dozens of interacting rules until the model slips on one of them? That failure is technically "valid" but the difficulty is artificial, and how the rules interact with the data is near-impossible to audit. | **Other** + comment: "difficulty is rule-overload, not reasoning." |
| **Realistic** | Would a real practitioner be paid to produce these outputs? Is the scenario authentic, and are the requested outputs what that person would actually want, not an artifact no one uses? | **Task is not realistic issue** |
| **Novel** | In this domain, is it a textbook or well-known published problem with a widely available solution a model could reproduce from memory? | **Other** + comment: "not novel / known solution." |

##### The instruction

| **Judgment call** | **How to test it** | **If it fails → checkbox** |
| --- | --- | --- |
| **Not over-directed** | Does the instruction hand over the method, mandate a specific tool/library, or walk through steps, removing the actual challenge? Grading should be on *what* is produced, not *how*. | **Instructions are overspecified** |
| **Unambiguous (sound-alternative test)** | Can you name a *specific sound* expert approach (a single coherent method a competent practitioner would choose, not an error or hybrid) that would FAIL verification? If yes, it's ambiguous/underspecified. Also: are arbitrary or non-standard choices the agent must match actually disclosed? | **Instructions are underspecified** |
| **No hidden knowledge** | Does the golden solution rely on a constant, schema, threshold, or fact that the agent was never given in the instruction or its inputs? The agent can only use what it can see. | **Instructions are underspecified** (or **incorrect/irrelevant info** if the disclosed info is wrong) + comment |
| **No incorrect or irrelevant info** | Are there wrong paths, contradictions, claims that don't match the repo, or leftover filler that could mislead the agent? | **Instruction contain incorrect or irrelevant info** |
| **No answer leakage** | Open the files the agent can read (docstrings, comments, READMEs). Does any disclose the bug, the fix, or the expected output? | **Other** + comment: "answer leaked in [file]; move reasoning to solution/tests." |
| **No misleading content** | Is there a file/detail, not referenced in the instruction, that points away from the golden answer? Would a reasonable agent follow it and fail for that? | **Instruction contain incorrect or irrelevant info** + comment. |

Omission is not automatically ambiguity

The instruction is not supposed to hand-hold; the agent should make its own choices of method and approach. An omitted detail is fine when a domain expert could **deduce** it from the instruction, the input files, or standard domain knowledge. The best tasks contain an apparent decision with a hidden requirement that the provided information is enough to resolve. It only becomes underspecification when the missing detail is an arbitrary or non-standard choice the agent must match and has no way to deduce.

##### The verifier

| **Judgment call** | **How to test it** | **If it fails → checkbox** |
| --- | --- | --- |
| **Tolerances not too tight** | For each numeric band, would a genuinely correct solution produced by a *different sound method* still fall inside it? A band only the reference implementation can hit is too tight. | **Verifiers too tight. Low tolerances fail the tasks unfairly** |
| **Tolerances not too loose** | Would a plausible *wrong* method also land inside the band? Could a wrong-but-close answer pass? | **Verifiers too loose. Wrong answers pass through** |
| **No domain-specific cheat path** | Beyond generic anti-cheat: is there a shortcut a clever agent could exploit in THIS domain, such as an analytical shortcut the task means to exclude, an online lookup of the answer, exploiting a fixture, or hardcoding a value that happens to pass? | **Verifiers too loose** + comment |
| **Tests match the instruction 1:1** | Does every assertion trace to a requirement the instruction states (or clearly implies), and is every stated requirement actually tested? Grading on unstated criteria is an unfair stump; missing coverage lets wrong work pass. One trivially-minor requirement (of many) left untested is non-blocking, so score it 4. Material coverage gaps are a Revise. | **underspecified** / **overspecified** / **incorrect info** as fits + comment |
| **No injection or malicious content** | Scan env files, comments, READMEs, and fixtures for text that tells the agent to ignore the task / reveal answers / tamper with grading, and for obfuscated or encoded payloads. | **Other** + comment. |
| **Deterministic** | Are seeds/inputs fixed and ordering stable, with nothing depending on wall-clock/date or live-generated data? | **Other** + comment: "nondeterministic, fix seeds/inputs." |
| **Requirements traceable** | Can you trace each material instruction requirement to a solution step and a verifier assertion (and back)? | **Other** + comment. |

##### The solution

| **Judgment call** | **How to test it** | **If it fails → checkbox** |
| --- | --- | --- |
| **Solution genuinely solves it** | Does `solve.sh` actually compute the answer through real work, or does it echo/hardcode a precomputed result? Are expected values in tests/ derived, not pasted in? | **Other** + comment: "solution doesn't genuinely compute / hardcoded." |

##### Metadata labels

The `task.toml` `[metadata]` block tags the task with controlled-vocabulary labels from `.dynamo/diversity-taxonomy.toml` (browseable on the [Task categories](/task-categories) page). **Only `task_objective` and `artifact_type` are the fellow's job**. `category` and `subcategory` are seeded by the Dynamo team in the platform task and must be left untouched. Your check is that the task the PR implements still matches them. Both fellow-set fields must be filled with the **best available fit** (lowercase `snake_case` labels from the taxonomy), not a loose match and never an empty array. These labels drive dataset-level diversity tracking, so a wrong or missing label silently corrupts the benchmark mix.

| **Judgment call** | **How to test it** | **If it fails → checkbox** |
| --- | --- | --- |
| **No placeholder defaults** | Neither `task_objective` nor `artifact_type` is empty or still holds scaffold text. | **Metadata labels missing, placeholder, or wrong fit** + comment |
| **`category` / `subcategory` still match the PR** | These were seeded by the Dynamo team in the platform task. Confirm the fellow hasn't changed them **and** that the task the PR actually implements still fits them, since attempters often edit the PR until it passes and forget the platform entry drifted. If a mismatch is the only issue, **Accept at a 3**: the task is deliverable, and the 3 logs that the platform category needs correcting (see the [Decision rule](#6-the-verdict-accept-revise-reject)). | **Metadata labels missing, placeholder, or wrong fit** |
| **`task_objective`: valid array, best fit** | A non-empty array where every entry is a lowercase `snake_case` label from `.dynamo/diversity-taxonomy.toml` and reflects the task's **end goal**, not the tools, files, or commands used to get there. Multiple labels are allowed when several genuinely apply. | **Metadata labels missing, placeholder, or wrong fit** |
| **`artifact_type`: valid array, best fit** | A non-empty array where every entry is a lowercase `snake_case` label from `.dynamo/diversity-taxonomy.toml` and names the **central** objects the task operates on, not incidental helper scripts, logs, or temporary outputs. Multiple labels are allowed when several genuinely apply. | **Metadata labels missing, placeholder, or wrong fit** |

Best fit, not just valid

A label can be spelled correctly and still be wrong. Read the task, decide what it is really about, and confirm the fellow picked the closest label(s). A `debug` task tagged `implement`, or a database task tagged only `text_or_log_file`, is a wrong-fit failure even though the labels exist in the vocabulary. If a value sits outside the controlled vocabulary in `.dynamo/diversity-taxonomy.toml` entirely, it's also a fail.

When in doubt, write it down

If you suspect an issue but can't fully confirm it (e.g. a tolerance you think is too tight but can't recompute), select the closest checkbox and say so in the comment with your reasoning. A flagged uncertainty is far more useful to the next reviewer and the author than a silent pass.

#### 5. The core skill: Valid vs. Invalid failures

As an attempter you experienced the pass@ gates from the other side. As a reviewer, reading them is a judgment call, and it is the one part of the pipeline **not** pre-filtered for you. A good task is a **solvable stump**: the oracle solves it (proving it's solvable) while the model fails at least 3 of 5 (proving it's hard), and a clean 0/5 of valid failures is the hardest case. The failures must be the model getting the answer **wrong**, never running out of time. A timeout is not a valid failure.

The proof standard for a valid failure

A failure is **valid** only if you can point to something concrete, such as a sentence in the instruction or an analysis of the input files, that *proves* the agent's approach or decision was incorrect. If instead an expert could defend the approach from the instruction alone ("nothing here forbids this; given what was provided, this is a reasonable method"), the task is ambiguous and the failure is **invalid**, even if the trial-analysis panel calls it valid.

Reading the trial analysis panel

Each trial's analysis breaks into: a Per-Trajectory Rubric (task specification, reward hacking, difficulty crux, near miss, refusal, timeout, approach validity), Fail Reasons, Golden vs. Agent Values, Failing Tests, Golden Solution Approach, Agent Approach, the difference between the two, a Validity-of-Agent-Approach call, a Rubric Aggregate, and a final Summary. Treat all of it as an LLM first pass rather than ground truth. It can be wrong in either direction, and it can be fooled by an incorrect `task.toml` difficulty explanation. (If the difficulty explanation itself states a wrong "correct" answer, the panel may score a genuinely correct agent trial as a valid failure, so check the difficulty explanation against your own read of the solution when something looks off.) If the panel isn't enough, use View Logs and Artifacts to pull the full agent trajectory, which is expected to be rare rather than routine.

The full path: View logs & artifacts → "trials" in the left panel → expand "Upload Harbor Output" for the download link.

One fast diagnostic: if the failing tests are about file existence or output formatting, treat it as a red flag rather than real difficulty — it usually means a naming/format convention the instruction never disclosed, which is an ambiguity (invalid failure), not a genuine stump.

| **Judgment call** | **How to test it** | **If it fails → action** |
| --- | --- | --- |
| **Pass@5 in the target band** | Is the score in the **0–2/5** band (pass@5 ≤ 2/5) with **valid** failures? A clean **0/5** (all valid fails, oracle solves it) is the hardest case and is good; **3–5/5** = too easy. A task in this band is fine regardless of its pass@2 result. Note which agent/model ran the trials, since it can vary by task. | **0/5 with invalid failures** (timeout / agent / verifier) → send back to fix the cause. **3–5/5** → send back with guidance to raise *real* difficulty (edge cases, multi-step reasoning, stronger verifier), not lower the timeout or add busywork. |
| **Failures are legitimate, not timeouts** | Open the job analysis: are the failing runs producing *wrong answers*, or just hitting the time limit? | If failures are timeouts, the difficulty is fake. Send back to move difficulty into reasoning, not compute time. |
| **Failures aren't prompt ambiguity** | Are the runs failing because the prompt admits more than one reasonable interpretation, rather than because the problem is genuinely hard? | **Instructions are underspecified** + comment. |
| **Agent consensus vs. golden** | If most or all failing trials converge on the same value/approach that differs from golden, don't default to "the agents are wrong." Check whether the golden solution is actually correct, whether an undisclosed rule is making agents fail unfairly, or whether the agents found a legitimate approach the golden solution disregards. | **Instructions are underspecified**, or **Other** (if golden itself is wrong) + comment. |
| **Verifier tests the real requirement** | Does the verifier check what the task actually asks, and is it robust rather than brittle (it accepts any sound correct answer, rejects wrong ones)? | **Verifiers too tight** / **too loose** as fits + comment. |
| **Timeout justified and ≤ 3600s** | Did the author justify their chosen timeout, and is it within the 3600s hard cap and long enough for the model to produce an answer? | **Other** + comment: "timeout unjustified / exceeds cap / too short to finish." |
| **Trace reviewed for cheating** | Skim a representative agent trace: did it do the work, or shortcut / read ground truth / tamper with the verifier? | **Other** + comment. |

Send back to attempt when…

Two pass@5 outcomes always go back to the fellow, regardless of how good the rest of the task looks:

- **0/5 from invalid failures** (timeout, ambiguity, brittle verifier): send back to fix the cause; a clean 0/5 with valid failures and a passing oracle is fine.
- **3–5/5 on pass@5** (pass@5 > 2/5): too easy; tell the fellow to raise the difficulty of getting it *right*, never to lower the timeout or add busywork.

See [Understanding Pass@ & Timeouts](/submit/pass-at) for the full fellow-facing policy.

#### 6. The verdict: Accept / Revise / Reject

Everything you've found now collapses into one call.

Accept

Accept if the PR has no issues. A mismatch between the proposal and the platform's task description is fine on its own, since that's just metadata and can be corrected after the fact. This holds even for a **category/subcategory mismatch**: if the task the PR implements is clean but belongs to a different category than the platform records, Accept the task and score it a 3 to log the mismatch (rather than 4 or 5). The task is deliverable; the 3 flags that the platform's category needs correcting so the task-type distribution the project requires isn't silently eroded (`category`/`subcategory` are seeded in the platform by the Dynamo team; see the Metadata labels subsection in [§4 The judgment areas](#4-the-judgment-areas)).

Revise

Revise in every other case: a real but fixable problem that does not collapse the task's difficulty. Send it back with actionable feedback.

Reject

Reject if the task's difficulty is illegitimate or the task is unsalvageable, meaning fixing the problem would make the task easy or it needs a rebuild from scratch. Reject when any hold:

- Most models failed because of an undisclosed requirement enforced in the verifier.
- Trials failed because the model misunderstood an ambiguous term, and clarifying it would lead to a perfect answer.
- The agents solved every aspect correctly but failed on a choice that is still valid and was never pinned by the instruction (ordering, naming, or formatting conventions not specified or unclear); pinning it would lead to a correct answer.
- The instruction or input data contains red herrings that deliberately lead the agent to an incorrect answer.
- The difficulty was manufactured: e.g. the commit history shows a clarifying instruction was removed so a passing task would start failing, and fixing the ambiguity makes the task solvable, so the difficulty was never real.
- Trials failed because the instruction or input files contain incorrect information that was never disclosed (the model had no reason to distrust the given information).
- All agent failures were caused by an overly strict verifier that rejected valid answers.
- There are other critical issues that would require starting from scratch, not just fixing.
- The attempter ignored feedback from a previous reviewer and did not implement the required fixes (or disputed the feedback without addressing it).

The hardest call — Reject vs Revise

Both send the task back, but they differ. When the failure comes from something missing or wrong in the task, ask: *if I fix it, is the task still genuinely hard?* If yes → Revise (tell the fellow exactly what to change). If fixing it makes the task easy or trivial → Reject (the difficulty was never legitimate).

**Related:** [Reviewer guide](/reviewing) · [Scoring: checkboxes and the 1–5 score](/reviewing/scoring) · [Recording your review in HAI](/reviewing/recording)

### Scoring — Checkboxes and the 1–5 Score

<sub>`/reviewing/scoring` · section: **Review tasks** · nav label: *Scoring* · [source](https://project-dynamo.learn.joinhandshake.com/reviewing/scoring)</sub>

#### 7. Scoring: Checkboxes and the 1–5 Score

You record a review in several parts: the **issue checkboxes**, a **comment**, a **1–5 Standard Quality Score**, and (in Review 1) a **Task Verdict** and **Fellow Verdict**.

##### What each checkbox means

Select every issue that applies. Map your findings from [The judgment areas](/reviewing/judgment#4-the-judgment-areas) and [Valid vs. invalid failures](/reviewing/judgment#5-the-core-skill-valid-vs-invalid-failures) onto these options.

| **Checkbox** | **Select it when…** |
| --- | --- |
| **Instructions are overspecified** | The prompt hands over the method, mandates a tool/library, or walks through steps, so the task is no longer hard. |
| **Instructions are underspecified** | A sound expert approach would fail verification, an arbitrary choice the agent must match isn't disclosed, or the solution needs knowledge the agent was never given. |
| **Verifiers too tight. Low tolerances fail the tasks unfairly** | A genuinely correct solution from a different sound method falls outside the accepted band. |
| **Verifiers too loose. Wrong answers pass through** | A wrong or wrong-but-close answer passes, or there's a bypass / domain-specific cheat path the verifier misses. |
| **Task is not realistic issue** | A gimmick, trick, or toy puzzle; outputs no real practitioner would want. |
| **Instruction contain incorrect or irrelevant info** | Wrong paths, contradictions, claims that don't match the repo, or misleading filler. |
| **Metadata labels missing, placeholder, or wrong fit** | `task_objective` or `artifact_type` is unset, still a scaffold placeholder, drawn from outside the controlled vocabulary in `.dynamo/diversity-taxonomy.toml` (browseable on [Task categories](/task-categories)), or not the best-fit label for what the task actually does. (`category` / `subcategory` are seeded by the Dynamo team in the platform task; flag here when the fellow changed them or the task the PR implements no longer matches them.) |
| **This task is good. Send it forward** | All gates clear. Select only when you'd ship it as-is. |
| **Other (add comments)** | Anything not named above: too easy, not novel, hardcoded solution, tests not aligned to the instruction. Explain in the comment. |

Comments must be actionable

Point at the exact file, criterion, or line and say what to change. For example, "the [29,31] band rejects a valid trapezoidal-rule result; widen to [28,32] or justify the method restriction," not "verifier seems off." A specific comment is what lets the author fix it in one pass.

##### Standard Quality Score (1–5)

Score and verdict are set independently. The **verdict** answers whether the task can be salvaged (Accept / Revise / Reject); the **score** answers how good the task was on arrival (1–5). They don't move together: a task can be salvageable and still low quality. Sending a task back to Revise and grading it a 2 is a normal, intended outcome — it means "worth fixing, but the quality on arrival was poor," which is exactly the signal that lets us judge attempter quality over time. Only a **1** is inherently unsalvageable, because a 1 is reserved for bad faith (ignored feedback, spam), not merely poor work.

Score the task on arrival, meaning its quality before any suggested fixes. The score tracks your verdict, so don't agonize over 4-vs-5.

| **Case** | **Verdict** | **Score** |
| --- | --- | --- |
| No issues | ✅ **Accept** | 5 |
| Minor, non-blocking issue (typos, grammar, or one very minor requirement of many left untested) — still sendable to the client | ✅ **Accept** | 4 |
| No issues except that the task belongs to a different `category` than the platform records | ✅ **Accept** | 3 |
| Blocking-but-fixable issue that doesn't collapse the task's difficulty (ambiguity, incorrect facts, leaked solution fragments, missing required files such as `test.sh`) | 🔄 **Revise** | 3 |
| Major issue that blocks delivery but doesn't flip the difficulty | 🔄 **Revise** | 2 |
| Any issue that would flip the difficulty or require a fresh start | ❌ **Reject** | 2 |
| Attempter ignored or disputed valid reviewer feedback without addressing it | ❌ **Reject** | 1 |
| Egregious LLM / spam / highly misaligned | ❌ **Reject** | 1 |

Calibrate before you score

Set the score and the verdict independently: the **score** records the task's quality on arrival, the **verdict** records where it should go. Score 5 or 4 is clean enough to Accept. Score 3 is a minor blocking issue (Revise), with one special case: if the *only* issue is that the task belongs to a different `category` than the platform records, the task itself is deliverable, so Accept it and use the 3 to log the mismatch. Score a major issue a 2 for the quality read even when it's fixable. The Revise-vs-Reject call is then separate and rides on one question: does the task stay genuinely hard once fixed? If yes, Revise (a 2 sent back). If fixing it would flip the difficulty so the agents pass, or the task needs a full rebuild, Reject. Score 1 is reserved for bad faith: the attempter ignored valid feedback or the task is spam/misaligned.

Worked example: a task with a major design flaw that a competent fellow could still fix scores a 2 (poor quality) and gets a Revise (salvageable) — the low score records the quality problem for attempter tracking even though the task is going back rather than being rejected.

**Related:** [Reviewer guide](/reviewing) · [Judgment areas, valid failures, and the verdict](/reviewing/judgment) · [Recording your review in HAI](/reviewing/recording)

### Recording your review in hai

<sub>`/reviewing/recording` · section: **Review tasks** · nav label: *Recording* · [source](https://project-dynamo.learn.joinhandshake.com/reviewing/recording)</sub>

#### 8. Recording your review in hai

After you've judged the task and chosen a score and issue flags, you record your review in HAI. The Review-1 form has these fields. Fill them in this order.

##### 8.1 R1 Reviewed PR Commit Hash

Record the exact commit you reviewed

Before you review, open the PR and copy the exact latest commit hash. Enter it in the HAI field **R1 Reviewed PR Commit Hash** (its instruction: *"Please specify the exact commit hash (latest) that you will review"*), and review that commit. This matters because the PR can get new commits later: the second reviewer (R2) reads your recorded hash, confirms they're reviewing the same commit (it may not be the latest), and evaluates your review against the exact commit you saw. If your hash is wrong or missing, your review can't be fairly checked.

##### 8.2 Standard Quality Score – Review 1

Rate the quality of the task as you received it, 1–5 (see [Scoring](/reviewing/scoring) for the full scale and how each score maps to a verdict). Don't rely on a shorthand here: the line between a 2 and a Reject depends on whether the task's difficulty survives the fix, not on the number alone.

##### 8.3 Review 1 Task Verdict

This verdict sets the routing. Choose one:

- ✅ **Accept**: this task is good to approve as is
- 🔄 **Revise**: this task is salvageable with revisions I have explained
- ❌ **Reject**: this task is unsalvageable

Don't click Approve on a Revise or Reject

Clicking **Approve** in HAI routes the task forward to the next review layer; it is not a neutral "submit review" button. Only click it when your Task Verdict is **Accept**, and note the system only treats an Accept as valid when **zero issues** are flagged. For **Revise** or **Reject**: flag the issue(s), leave your feedback, and do **not** click Approve. Wait for the gray send-back option to become available and use it, which routes the task back to the fellow. This has gone wrong before: reviewers intending to revise clicked Approve, and their tasks advanced to the next review layer instead of returning to the attempter. See the [Decision rule](/reviewing/judgment#6-the-verdict-accept-revise-reject) above.

##### 8.4 Review 1 Fellow Verdict

Separate from the task verdict: here you are rating the **fellow**, not the task.

- ⭐ **Excellent**: this fellow is already of exceptional quality
- 🎓 **Trainable**: this fellow is good and can be trained to successfully contribute on this project
- 🛑 **Misaligned**: this fellow is misaligned with the project guidelines or is not qualified

##### 8.5 Task Notes and Feedback

- Only accept tasks that are deliverable. An Accept is only valid when there are **zero issues** flagged. Whenever you Revise or Reject, the task is sent back, so flag every issue as either **minor** or **major issue** depending on the severity of the change. Only in that case do your comments become blocking.
- Leave feedback in **both** places: the taxonomy comment field **and** the inline text-bubble comment on the file, so the fellow sees it in their sidebar. A practical pattern: write one paragraph listing all issues, then file each issue as its own feedback bubble.
- Always provide feedback, including on a Reject. A rejection with no explanation feels terrible and teaches nothing; even an unsalvageable task is a chance to keep the fellow from repeating the mistake. Good feedback points at the exact file / criterion / line, names what is wrong, and says what to change, so the next revision has a high chance of approval.
- A rejected task is removed from the pipeline and will not be paid, so give solid reasoning for a Reject.
- If the fellow already received feedback from a previous review, first confirm they implemented the required changes.

Use the **R1 Other comments** field for any notes that aren't feedback to the fellow.

Review with the war room open

The war room is a Zoom office hour where you can get help with any reviewer question. It's announced on Slack and reviewers are sent the invite. When it's active, keep it open while you review and ask questions in real time; unblocking a judgment call live beats guessing.

**Related:** [Reviewer guide](/reviewing) · [Judgment areas, valid failures, and the verdict](/reviewing/judgment) · [Scoring](/reviewing/scoring)

---

## Common errors and examples

<sub>`/pitfalls` · nav label: *Errors & Examples* · [source](https://project-dynamo.learn.joinhandshake.com/pitfalls)</sub>

### Common pitfalls, grouped by requirement area

Most tasks that get sent back fall into one of a few requirement areas, so we've grouped the common pitfalls and examples that way. These areas line up with what reviewers check in [Automated Review](/submit#automated-review) and [Wrap-up](/wrap-up) — the grouping is a way to navigate the failure modes, not a fixed or exhaustive contract. Each card names the area, the common ways authors miss it, a bad-vs-good example, and how to avoid it.

Collapse all

#### 1 · Coherent and complete instructions

Problem

The instruction — together with any spec, docstring, or reference it points at — must fully and consistently describe what to produce. Every graded field, format, method, and edge case must be nameable from the text alone, and no two rules can contradict each other on the actual shipped data.

**Common pitfalls**

- Two rules that can't both hold on the shipped fixtures (e.g. warm-up-window vs zero-volume forcing the same cell).
- Underspecified methodology — only a defect when the choice changes the graded answer (e.g. variance estimator). Leaving the method open is usually preferable; if reasonable methods converge within tolerance, leave it open — otherwise pin only the deciding choice.
- Behaviors, objects, or fields named but never defined (e.g. an ID scheme).
- Verifier enforces a string, field, or schema that appears nowhere in the instruction (e.g. exact key name).
- A required field's format or naming is unspecified and the verifier hardcodes one (e.g. sort key).
- A value with several valid computations, but no single-assignment, priority, or tie-break rule stated.
- Edge cases undescribed, so a reasonable choice diverges from the hidden reference (e.g. duplicates).
- Spec wording that contradicts intent (e.g. "first match wins" where the reference keeps the last).

**View example**

**❌ Bad — names the goal, not the method**

```
Report the program's effect as the difference in mean outcome between treatment
and control, together with its standard error, a two-sided 95% CI, and whether
it's significant at 0.05.
```

CR2, ordinary cluster-robust (CR0), jackknife, and plain i.i.d. each give a different number — all defensible, only one passes.

**✅ Good — pins every graded choice**

```
Report the program's effect as the difference in mean outcome between treatment
and control, together with its standard error, a two-sided 95% CI, and whether
it's significant at 0.05.

Because the program was cluster-randomized at the district level, use a
bias-reduced cluster-robust variance estimator (CR2 / Bell–McCaffrey) clustered
at the district level, with Satterthwaite degrees of freedom, and form the CI
and significance test using the corresponding Student-t critical value.
```

How to avoid it

Walk every rule against the real shipped data (not a hypothetical). Pin a method only when the method choice actually changes the graded answer — and then pin just the deciding choice (estimator, tolerance, rounding, convention), not the whole recipe. If two competent experts could give different numbers and both be right on the answer the verifier grades, the spec is underspecified.

#### 2 · Correct reference solution

Problem

The Oracle must produce the exact output the spec designates as correct — not *an* answer that happens to be valid, and not "probably right on inspection." Since the verifier is usually built off the Oracle's output, an Oracle bug becomes wrong ground truth.

**Common pitfalls**

- Oracle "works" but drifts from the spec — outputs fields or shapes never described (internally consistent, externally wrong).
- Tie-break or ordering bug returns a valid-but-non-canonical answer (e.g. keeps the last tied match).
- Solvability assumed from reading code, not running it (e.g. silent NaN only surfaces on execution).

**View example**

**❌ Bad — keeps overwriting on ties, so the last tied path wins**

```
for path, regs in candidates_in_sort_order:
    if ok:
        best = (path, regs)
        continue                 # never breaks -> last tied path wins
```

**✅ Good — locks in the first valid path**

```
for path, regs in candidates_in_sort_order:
    if ok:
        if best is None:
            best = (path, regs)  # keep the FIRST valid path
            break
```

How to avoid it

Run the Oracle end-to-end with `harbor run -p task --agent oracle` and confirm `reward 1.0`. Static reading isn't enough for numerical or data-specific solutions. Re-read the instruction line by line against the Oracle's actual output — every field, ordering, and edge case should be traceable to a sentence in `instruction.md`, and vice versa. Explicitly test tie-break and ordering rules on a case that actually contains ties.

#### 3 · Sound and materially complete verifier

Problem

The tests must distinguish a correct answer from a plausible-but-wrong one. Every requirement the instruction states needs at least one assertion that would fail if the method were wrong — not just if the output were mis-shapen.

**Common pitfalls**

- Tolerances so loose a hardcoded or degenerate value passes (e.g. hardcoded `p = 1`); surface-only checks (row counts, types) let fabrications through.
- Stated requirement with no discriminating test — instruction says it, verifier never checks it.
- Verifier stricter than the spec — rejects correct answers over serialization never required (e.g. trailing newline).
- Verifier too tight (symptom, not license to loosen) — calibrated to the Oracle, it rejects an approach that satisfies the instruction but differs on an unpinned methodology. Fix in area 1 or 5 by pinning the method — don't widen the verifier.
- Verifying against a wrong reference — asserting what the Oracle outputs, not what the instruction requires.
- No exact schema / dtype / key-set / rounding enforcement, so near-misses slip through (e.g. extra `debug` key).

**View example**

**❌ Bad — only discriminating assertion is a wide threshold**

```
def test_effect_is_not_significant():
    result = json.loads(OUT.read_text())
    assert result["p"] > 0.05        # hardcoded p = 1.0 passes
```

**✅ Good — recomputes the correct reference and pins method + tolerance**

```
def test_effect_uses_bias_adjusted_p():
    result = json.loads(OUT.read_text())
    ref = compute_bias_adjusted_reference(DATA)   # independent recompute

    assert set(result.keys()) == {"effect", "se", "ci_low", "ci_high", "p"}
    assert isinstance(result["p"], float)
    assert result["ci_low"] < result["ci_high"]                # no zero-width
    assert abs(result["p"] - ref["adjusted_p"]) < 0.15         # absorbs numerical /
                                                               # implementation noise
                                                               # around the same
                                                               # intended answer;
                                                               # still rejects the
                                                               # uncorrected result
                                                               # and hardcoded 1.0
```

How to avoid it

For each assertion, ask "could someone fake this and still pass?" Assert against the *spec*, not the Oracle's output; compare parsed values rather than raw bytes; pin the exact shape, dtype, key set, and rounding. The verifier should admit the golden solution and only the golden solution. Where a result can't be exact — floating point, non-deterministic solvers computing the same answer — a justified numerical tolerance is fine, but tolerance must never be widened to admit genuinely different answers, fabricated values, or alternative methodologies. If a different valid approach would be rejected, that's an instruction problem (pin the method), not a reason to loosen the check. In general, test for the golden solution.

#### 4 · Protected and independent ground truth

Problem

The agent must not be able to read, alias, or influence the answer key. The verifier must answer "did the agent produce the right output?" — never "did the agent write the file we read back?"

**Common pitfalls**

- Output aliased to ground truth (e.g. agent symlinks its output at the expected path and passes by matching itself).
- Reference recomputed from agent-writable inputs — agent rewrites the input to manufacture a pass.
- Verifier trusts a file under `/app/` (agent-mutable) without re-copying or hash-pinning.
- Not knowing what the agent can reach — assuming "hidden" means "safe."

**View example**

**❌ Bad — trusts an agent-writable path with no guard**

```
OUT = Path("/app/recovered_key.json")
data = json.loads(OUT.read_text())
assert data == EXPECTED_KEY
# agent runs: ln -s /tests/expected_key.json /app/recovered_key.json
# -> file matches itself, test passes
```

**✅ Good — rejects symlinks and pins the real path**

```
OUT = Path("/app/recovered_key.json")
assert not OUT.is_symlink(), "output must not be a symlink"
real = os.path.realpath(OUT)
assert real.startswith("/app/"), "output must be a real file under /app/"
assert os.path.isfile(real)
data = json.loads(Path(real).read_text())
assert data == EXPECTED_KEY
```

How to avoid it

Enumerate what the agent can see, edit, or redirect. Keep ground truth in `tests/` (never in `environment/`), reject symlinks at the artifact path, and re-copy or hash-pin any input the verifier trusts.

#### 5 · Runnable, realistic benchmark task

Problem

The task must be honestly solvable from the instructions as written — the difficulty should come from reasoning, not from guessing what the Oracle happened to do.

**Common pitfalls**

- Not honestly solvable — instruction and verifier disagree, so no output satisfies both.
- Passing requires matching the Oracle's undocumented quirks (e.g. tie-break) rather than the stated spec.
- Difficulty from tedium or compute (e.g. thousands of near-identical steps) instead of reasoning.

**View example**

**❌ Bad — two rules contradict on the shipped data**

```
`vwap_deviation` must evaluate to exactly `np.nan` for indices 0 through 119,
and are valid everywhere else.
```

But the daily rule also forces `vwap` to null across two zero-volume days (~2,880 rows), and `vwap_deviation = forward_filled_price - vwap` propagates the null — so `vwap_deviation` is null in far more places than "indices 0–119." No output satisfies both rules.

**✅ Good — states the propagation explicitly**

```
`vwap_deviation` is `np.nan` for indices 0 through 119 and additionally at every
index where `vwap` is `np.nan`, since a `np.nan` `vwap` propagates through the
`(forward_filled_price - vwap)` numerator.
```

How to avoid it

Read your instruction as if you'd never seen the Oracle. Trace every rule against the real fixtures, name every propagation and edge case, and make sure the difficulty comes from the reasoning — not from guessing an undocumented Oracle convention.

The one habit that catches most of these

Run the task both ways before submitting:

- `harbor run -p task --agent oracle` — must score **reward 1.0**
- `harbor run -p task --agent nop` — must score **reward < 1.0**

Oracle failing points at areas 1, 2, or 5 (instructions, reference solution, or solvability). `nop` (or any trivial shortcut) passing points at areas 3 or 4 (weak verifier or unprotected ground truth).

For the exhaustive version the QC gate runs — all 30 specific checks across these same five areas, plus worked examples of real tasks that passed and failed — see [Flags & Fixes](/pitfalls/qc-eval). When you're ready to ship, run through the [Before you submit](/pitfalls/checklist) self-check.

### Flags & Fixes

<sub>`/pitfalls/qc-eval` · section: **Errors & Examples** · [source](https://project-dynamo.learn.joinhandshake.com/pitfalls/qc-eval)</sub>

The Dynamo QC evaluation reviews every submission from an adversarial perspective. It assumes the task should fail unless it can verify that every requirement has been implemented correctly.

The evaluation looks for ways a model could produce an incorrect answer and still pass the verifier. Your task only passes if all of those cases are prevented. If even a single check fails, the entire task fails.

The key principle is simple: everything the verifier checks must be clearly specified in instruction.md, the environment/ directory, or the provided examples. Likewise, the verifier should enforce every required behavior directly, rather than relying on indirect or aggregate checks.

How the gate decides

The gate defaults to FAIL and only reaches PASS when every break attempt is refuted by a citation in your code. Any single Major check that fails → the whole task fails, so breadth matters as much as depth. There is no discretion to excuse a surfaced break — "near-correct," "immaterial," "obscure," and "intended difficulty" are not valid defenses. Materiality only sets severity, never whether something is a finding.

#### The 30 checks

The [five failure areas](/pitfalls) cover the *what*; this page is the exhaustive version the QC gate actually runs — 30 specific checks across those same five concerns (families A–E), every one **Major** (any single failure fails the task). The strategies and checklist below cite the individual IDs; expand a family for exactly what a cited ID (e.g. A5, C4) triggers on.

Collapse all

##### A · Solution / oracle correctness (A1–A6)

- **A1 · Oracle fails its own verifier** — the reference solution, run against the verifier as shipped, wouldn't score full reward (fixture/generator bug).
- **A2 · Incomplete reference solution** — `solution/` doesn't perform every action the instruction requires (e.g. reports the problem but skips the mandated repair).
- **A3 · Hardcoded answer in reference** — a decisive answer, table, threshold, or constant is baked into the reference rather than computed from agent-visible inputs.
- **A4 · Oracle relies on hidden/privileged access** — the oracle imports a private module supplying the task's crux, or reads a protected fixture the agent couldn't reconstruct.
- **A5 · Oracle undocumented assumption** — a silent default, injected record, unit conversion, or dedup that is neither documented nor derivable and changes the result.
- **A6 · Oracle edge-case or logic bug** — a class of valid input on which the oracle produces a wrong or crashing result (tie-break, off-by-one, filtering, null-handling).

##### B · Contract coherence & determinacy (B1–B6)

- **B1 · Ambiguous rule, no disambiguation** — two reasonable readings of one rule yield different graded answers and nothing agent-visible picks one.
- **B2 · Internal contradiction / impossible mechanism** — two rules conflict on a real input, or the end-state is unreachable via the only permitted mechanism.
- **B3 · Missing definition, field, or data** — a value the graded computation needs is absent from agent-visible inputs (incl. undefined ownership, precedence, tie-break, dedup).
- **B4 · Undocumented requirement enforced** — the verifier enforces a requirement stated nowhere to the agent: hidden thresholds, undisclosed encodings, precedence/tie-break rules.
- **B5 · Underdetermined / hidden-knowledge mapping** — disclosed material doesn't uniquely determine graded outputs (rule/cipher family undisclosed, or inputs outside observed range).
- **B6 · Unstated data-anomaly / selection policy** — graded input has an anomaly (duplicate keys, ties, malformed rows, overlapping windows) whose handling changes the answer, with no rule stated.

##### C · Verifier rigor & scoring (C1–C6)

- **C1 · Partial / degenerate / stub output accepted** — a stub (report-only, boolean-only, or a subset of actions) clears the verifier without doing the real work.
- **C2 · Over-permissive tolerance or threshold** — a tolerance, threshold, or aggregate metric accepts a concrete, materially-wrong answer.
- **C3 · Narrow / hardcodable held-out coverage** — a solution that hardcodes a shared constant or ignores the real input still passes.
- **C4 · Truth recomputed from agent-writable inputs** — the verifier re-reads an agent-writable path to compute ground truth, so altering the input makes the reference compute a trivial matching answer.
- **C5 · NaN / infinity bypass** — a graded numeric field has no NaN/Infinity rejection, so a non-finite value slips past a bare tolerance check.
- **C6 · Scoring contract mismatch** — the reward scheme contradicts the stated grading (e.g. instruction promises partial credit but `test.sh` emits binary 0/1).

##### D · Fixtures, environment & determinism (D1–D5)

- **D1 · Degenerate test fixture** — the initial/no-op state already satisfies the verifier, so zero real work passes.
- **D2 · Malformed / unparseable fixture** — a shipped fixture raises a parse error under the format the solution/tests assume.
- **D3 · Environment build failure** — an uninstallable or unpinned dependency/build step fails for the specified Python/OS/arch.
- **D4 · Nondeterminism in gen/solution/verification** — an unseeded RNG, seed-without-default, `time.time()`, network fetch, or set/dict iteration changes generated data or the accepted answer across clean runs.
- **D5 · Unseeded build-time randomness** — a key/IV/random value is generated at build/setup time without a fixed seed.

##### E · Anti-cheat & isolation (E1–E7)

- **E1 · Oracle / answers readable by the agent** — `solution/`, `tests/`, a seed, or an expected value is present or importable inside the agent image during the run (e.g. `COPY solution/` in the Dockerfile).
- **E2 · Immutable-input integrity not enforced** — a protected path isn't integrity-pinned AND tampering with it changes the graded outcome.
- **E3 · Reward / harness plumbing exploit** — a concrete agent-writable file is imported or executed as code by the verifier, letting the agent hijack the reward.
- **E4 · Root / elevated access exposes secrets** — the agent's privileges let it read a secret/ground-truth file the verifier relies on at grade time.
- **E5 · Symlinked output path** — the verifier reads a graded `/app` output path and follows an agent-created symlink to a golden/expected file.
- **E6 · Unsafe archive extraction** — an agent-influenced archive is extracted without sanitizing member paths (absolute paths / `../` traversal).
- **E7 · Non-self-contained deliverable / copied oracle** — the agent passes without real work by preserving/copying a retained reference tool/oracle the graded entrypoint can invoke, import, or decode.

#### Proven strategies to pass

These are the six things the gate actually grades on — each pairs a real defect that got flagged (red) with a real task confirmed sound (green). Several green cases were even flagged Major by a first reviewer, then confirmed sound on appeal — study the boundary carefully. Build tasks that look like the green blocks, not the red ones.

Core principle

Everything the verifier grades must be derivable by the agent from `instruction.md` + `environment/` + shipped examples, and the verifier must independently enforce every structural requirement — not a proxy. Design backward from that.

Collapse all

##### Strategy 1 · Put every graded decision in agent-visible material

*Covers: A3, A5, B3, B4 — this is the single most common cause of flags.*

- Enumerate every constant, threshold, tie-break, ordering, precedence, unit, and filter your verifier uses. For each, point to the exact line in `instruction.md` or `environment/` that states or determines it. If it lives only in `solution/` or `tests/`, document it or remove the dependency.
- If a mechanism is meant to be learned rather than told, say so and ship enough data to pin it uniquely.

FAILED — `73de419-entity-resolution`

The runbook says dominant pairs link — but the oracle secretly also requires a 4.5 score floor. Pair P00245 is dominant under the written rule yet graded "separate." The deciding rule exists only in the solution.

`solution/engine.py (L67–78)`

```
# The recovered link rule. An edge links only when it is a DOMINANT match for
# both of its records: its score is within SLACK of the strongest score that
# record carries anywhere in the candidate graph, and it clears a small global
# floor (so a shared-common-value-only edge never links)...
SLACK = 0.6
FLOOR = 4.5
```

→ `FLOOR = 4.5` decides many answers but appears nowhere the agent can see. A spec-faithful solution without it grades wrong.

PASSED — `e3c330f-lumenward-frame-recovery`

The spec omits one material's exact color adjustment — but explicitly tells the agent to recover it from the gold frames, which include a pixel that directly exposes it.

**Why it cleared:** The rule isn't written down, yet the shipped data provably determines it — so it's derivable, not hidden. That is the exact line between a B4 fail and a pass.

`environment/data/SPEC.md (L128–131)`

```
One specific `material_id` applies an additional, fixed
per-channel adjustment to `color` before this blend; the rule is not stated
here — recover both which material and the adjustment from the gold frames,
which include a pixel that directly exposes it.
```

##### Strategy 2 · Make the verifier enforce structure, not just an aggregate

*Covers: C1, C2.*

- List every structural requirement (exact count, shape, keys, ordering, byte-exactness) and add an assertion pinning each. Never let a single aggregate (ARI, correlation, RMSE, a count tolerance) stand in for a structural constraint.
- Actively try to construct a wrong-shape or degenerate answer that clears your metric. If you can, so can the agent — tighten until only real work passes.

FAILED — `afe5af4-stream-processor-repair`

Two of the required repairs are never exercised by any fixture. No window reaches the two-cycle closure threshold, so the off-by-one this line guards is never tested — a solution that fixes only one bug still passes.

`tests/test_outputs.py (L89–97)`

```
# Check closure eligibility (CORRECT: >= WATERMARK_DEPTH - 1)
for wid, window in windows.items():
    if window["state"] == "open":
        appear_count = sum(1 for past in watermark_history if wid in past)
        window["watermark_advanced"] = appear_count >= WATERMARK_DEPTH - 1
```

→ The logic is correct, but nothing drives a window to closure — so the requirement is unenforced. Coverage, not correctness, is the defect.

PASSED — `b8a6374-rebuild-release-bundles`

The contract forbids keying behavior to filenames. A reviewer worried a packer could recognize only known SDK filenames and still pass.

**Why it cleared:** Held-out ("unseen") release trees are graded by exact SHA-256 and reach the packer from outside `/app/data`, so it must derive everything from the tree it's handed — no filename shortcut clears it.

`tests/test_outputs.py (L87–100)`

```
@pytest.mark.parametrize("release", UNSEEN)
def test_rebuilds_lost_release_bundles(release):
    """For each release whose artifact was lost, the rebuilt bundle matches
    the published SHA-256. These trees are not in /app/data, and they reach
    the packer from a directory outside it, so the packer has to derive
    everything from the tree it is handed."""
```

##### Strategy 3 · Protect ground truth in code, not by convention

*Covers: C4, E1, E2, E5.*

- Grade from the verifier's own `/tests` copy or recompute truth from inputs the agent cannot write. Never re-read an agent-writable path to derive the expected answer.
- Open graded output paths with a symlink guard (`O_NOFOLLOW`), hash-pin protected inputs, and never `COPY solution/` or `tests/` into the agent image. Assume the golden path is guessable.

FAILED — `78b7c06-sla-credit-reconciliation`

Expected results are recomputed at grade time from the same writable `/app/data` files. An agent can zero fees and delete incidents, then submit a trivial zero reconciliation that matches the corrupted "expected."

`tests/reference_solution.py (L176–187)`

```
def compute_expected():
    """Recompute the full correct reconciliation from the raw /app/data exhibits."""
    contracts = _load("service_contracts.json")
    incidents = _dedupe_latest(_load_jsonl("incident_log.jsonl"), "incident_id")
    invoices = _load("invoices.json")
    ...
```

→ "...from the raw `/app/data` exhibits" — those exhibits are agent-writable, so truth is computed from data the agent controls.

PASSED — `3770094-docket-replay-proofs`

Protected sources sit beside the submission and are even `chmod 0666` before an untrusted Lean compilation — a reviewer worried submitted metaprograms could alter verifier logic.

**Why it cleared:** The verifier assembles a fresh package from the pristine spec plus only the submission artifact in a private temp dir, so the agent's writable copies never feed the graded build.

`tests/test_outputs.py (L59–72)`

```
def _assemble() -> Path:
    """Build the verification package once: pristine spec + submission."""
    wd = Path(tempfile.mkdtemp(prefix="curia-verify-", dir="/tmp"))
    shutil.copy(TESTS / "spec" / "Curia" / "Spec.lean", wd / "Curia" / "Spec.lean")
    shutil.copy(ARTIFACT, wd / "Curia" / "Proofs.lean")  # only the agent's artifact
```

##### Strategy 4 · Make the whole pipeline deterministic

*Covers: A1, D3, D4, D5.*

- Seed every RNG on every graded generation path with a fixed constant (a seed read from the environment without a default counts as nondeterministic). Avoid `time.time()`, network fetches, and digesting set/dict iteration order.
- Pin dependencies exactly; never hash-match a binary built by an unversioned, mutable toolchain. Confirm the reference solution scores full reward against the verifier exactly as shipped.

FAILED — `a3e1221-rpc-parser-finding`

The image compiles a binary with an unversioned GCC toolchain, then the verifier requires that binary to match one fixed SHA-256. A compiler or linker update breaks every valid submission despite unchanged source.

`tests/fixture_hashes.json (L12–18)`

```
"queue-plan": {
    "mode": 493,
    "sha256": "70bde4f5679038281893ee9ec7f87a35714f2787e14679d8d8366503de204186"
},
```

→ Pinning a compiled artifact to an exact hash while the toolchain is mutable makes the grade non-reproducible over time.

PASSED — `6211dbe-oncology-integrity`

All semantic inputs are committed local files; solution and verifier both use deterministic ordering, fixed timestamps, and exact decimal arithmetic — no randomness, no external services.

**Why it cleared:** Explicit total-ordering sort keys (no reliance on dict/set iteration order) mean identical clean runs always produce the same result. This is the determinism bar.

`solution/solve.py (L669–682, identical in tests/)`

```
audit.sort(key=lambda row: (row["patient_id"], row["regimen_key"], int(row["cycle_index"])))
rank = {"NONE": 0, "STANDARD": 1, "HIGH": 2, "CRITICAL": 3}
grouped = defaultdict(list)
for row in audit:
    grouped[row["patient_id"]].append(row)
```

##### Strategy 5 · Ship a complete reference that derives its own answer

*Covers: A2, A4, B5.*

- The reference must perform every action the instruction requires (not just report), and must derive its answer from agent-visible inputs — not import a private module that hands it the crux, and not rely on a rule family the disclosed data doesn't pin.
- If a private helper module is unavoidable, make sure everything it supplies is recoverable from the shipped corpus — and that the graded inputs stay inside the range the examples demonstrate.

FAILED — `fbfe7d4-reverse-vm-isa`

The hidden MIX function uses six arbitrary, unpublished constants; the visible data gives only finite probes and never defines the function family. Many functions fit the probes but differ on the eight required programs' unseen inputs.

`solution/svm.py (L30–43)`

```
# MIX opcode: a bespoke multiply-xorshift finalizer with non-standard
# multipliers and shift amounts so it cannot be pattern-matched to a
# published hash...
MIX_ROT = 13
FMIX_S1 = 15
FMIX_K1 = 0x7FB9AD35
```

→ "...so it cannot be pattern-matched" — the constants are unknowable from the finite probes, so the required outputs are underdetermined.

PASSED — `8aecca3-octant-run-manifests`

The oracle imports a hidden `octant_core` module for exact field widths and byte order that aren't documented — a reviewer flagged this as hidden knowledge.

**Why it cleared:** The spec states, and it's true, that the surviving corpus fully determines those values — hundreds of recorded manifest lines pin them. An import of a private module is fine when its output is recoverable from visible data.

`solution/gate_recover.py (L28–31)`

```
sys.path.insert(0, str(Path(__file__).resolve().parent))
import octant_core as oc  # noqa: E402
```

`environment/data/SPEC.md (L103–106)`

```
The record's exact field widths, field order, and byte order... are
not documented here. They are, however, fully determined by the surviving
corpus: the recorded manifests carry hundreds of keyed job lines...
```

#### Pre-submission checklist

Run this before you submit. Each item maps to the Major checks most likely to flag you.

Work through each item.

##### Checklist

0 of 15 complete

All verifier rules stated in `instruction.md` or derivable from `environment/` — constants, thresholds, tie-breaks, ordering, units (A3, A5, B3, B4)Nothing graded lives only in `solution/` or `tests/`If a mechanism must be learned, instruction says so and shipped data pins every graded answer (B5)Verifier enforces every structural requirement (count, shape, keys, ordering), not just an aggregate metric (C1, C2)You tried to construct a wrong-shape or degenerate answer that clears the metric — and couldn't (C1, C2, C3, D1)Graded numeric fields reject NaN/Infinity (C5)Reward path matches stated grading — binary vs. partial credit (C6)Ground truth graded from `/tests` or recomputed from non-agent-writable inputs; no agent-writable path feeds the expected answer (C4, E2)Graded output paths opened with `O_NOFOLLOW`; protected inputs hash-pinned (E5, E2)`solution/` and `tests/` never `COPY`'d into the agent image (E1)Every copy of any reference tool/oracle neutralized; deliverable is self-contained (E7)RNGs on graded paths seeded with a fixed default; no time/network/iteration-order nondeterminism; deps pinned (D3, D4, D5)Reference solution scores full reward against the verifier exactly as shipped (A1)`solution/` performs every action the instruction requires, not a subset (A2)Every data anomaly (dupes, ties, malformed rows) has a stated, enforced handling rule (B6)

### Pass AVA

<sub>`/pitfalls/ava` · section: **Errors & Examples** · [source](https://project-dynamo.learn.joinhandshake.com/pitfalls/ava)</sub>

AVA — the **Adversarial Verifier Audit** — is a gating check on your PR. It doesn't take your reference solution on faith. Instead it reconstructs, blind, what your **verifier** actually accepts, then asks one question: *can the pass/fail line be broken?* It runs after Pass@2 and gates Pass@5 — your task can't advance until AVA returns a routing of `pass`.

AVA audits your verifier, not your task

Every other check asks "does the task work?" AVA asks "**can the grader be fooled?**" It works **blind** — reconstructing what your verifier accepts without trusting your reference solution — then attacks the pass/fail boundary from both sides and checks that your tests actually exercise every requirement. (Deeper contract-coherence and spec-alignment checks are the Automated Review's job.)

#### The two ways your verifier's boundary slips

A verifier is sound only when its boundary is exactly right: every correct submission passes, every wrong one fails. Put another way, a sound verifier minimizes both **false positives** (an invalid submission accepted) and **false negatives** (a valid submission rejected) — the two ways that boundary slips.

![A sound verifier minimizes false positives (invalid submissions accepted) and false negatives (valid submissions rejected).](https://raw.githubusercontent.com/Handshake-Learn-Apps/survey-images/0eef7b3630182c8769414ceaee79895fb2ee6dfe/dynamo-videos/sound.svg)

A sound verifier sits at the boundary that minimizes both false positives (invalid work accepted) and false negatives (correct work rejected).

False accept (false positive) — the verifier is too loose

An invalid or adversarial submission still earns **reward 1**. A stub that does no real work slips through. This is the dangerous one — it lets a non-solving agent "pass" your task, and it's the failure AVA is built to catch first.

False reject (false negative) — the verifier is too strict

A valid, spec-faithful submission is **wrongly failed** — usually over-tight formatting, ordering, or float tolerance. A correct agent gets no credit.

#### How AVA decides

pass or block — and empty means fail

AVA returns a routing of **`pass`** or **`block`**. **Major** findings block the PR; **Minor** findings are advisory and don't. Empty or unparseable output is treated as a **fail** (fail-closed) — silence never passes.

#### What a flag looks like

A **Major** finding names the hole in your boundary and how to close it. The classic one: ground truth sitting where the submission can read it.

Blocking (Major)

The verifier loads its ground truth from `/tests/reference_data.npz`, which the submitted module can also read — a submission that does no real work can open that file and echo the reference values. → Move the reference data off any path the submission can read.

```
# ❌ Too loose: truth read from a path the submission can also open
expected = np.load("/app/reference_data.npz")   # agent can read (or overwrite) this

# ✅ Sound: truth lives where the submission can't reach it
expected = np.load("/tests/private/reference_data.npz")   # verifier-only, never in /app
```

A Minor finding, for contrast

"The verifier imports its own oracle module (an import/phase risk) — noted, but does not block." Advisory findings are worth fixing, but they never gate.

#### How to pass

Be your own AVA before you push

Try to write a submission that passes **without doing the work** — a stub, a hardcoded answer, an echo of the fixtures. If you can build one, so can AVA. Then check the other two fronts: run a few valid-but-differently-shaped correct answers and confirm they all pass, and re-read your reference solution against the instructions to confirm it obeys the stated method — not just the expected output.

The general verifier defenses — ground-truth isolation, no `COPY solution/`, symlink guards, structural assertions over aggregate metrics — are on the [Flags & Fixes](/pitfalls/qc-eval) checklist.

#### The combined gate

AVA ∪ Deep-Review

AVA and the Automated Review (labeled **Deep-Review** in the combined comment) form a **union** — your task advances only when **both** pass, and either one failing blocks the PR. You only see the combined **AVA ∪ Deep-Review** box when something blocks.

For where AVA sits in the full pipeline, see [What happens on your PR](/submit#ava-review).

### Before you submit

<sub>`/pitfalls/checklist` · section: **Errors & Examples** · [source](https://project-dynamo.learn.joinhandshake.com/pitfalls/checklist)</sub>

#### Quick self-check

Tick each item once you've confirmed it for your task. See [Errors & examples](/pitfalls) for the case studies these items refer back to.

Work through each item.

##### Quick self-check

0 of 11 complete

Every output field's format and naming is fully specified — IDs, enums, and any exact string literals — so the agent never has to guess (e.g. `finding_id` format, the `details` `reason` string).The verifier only checks things the instruction (or a doc it points to) actually states — no hidden literals or undocumented fields.When a value can be computed more than one valid way, the instruction names the single canonical rule — single-assignment, priority / tie-break order, and sort order.Duplicate, redelivery, and other edge cases are described explicitly — e.g. dedup by key, and how ties resolve.A reasonable alternative implementation still passes — the verifier isn't silently enforcing the oracle's arbitrary choice; if only one approach is valid, the instruction says so.No file the agent can read (docstrings, comments, READMEs, filenames) discloses the bug, the fix, or the expected output.No undisclosed file or detail steers the agent toward a non-golden answer — the task fails on the agent's own wrong call, not because the environment misled it. Every file the agent should use is named in the instruction.No malicious or destructive code, and no text in env files, comments, READMEs, or fixtures that tells the agent to ignore the task, reveal answers, or tamper with grading; no obfuscated or encoded payloads.Every rule in instruction.md has been traced against the real shipped fixtures — no two rules contradict each other on the actual data (see "Contradictory instructions").The output of solution/solve.sh was re-read line by line against instruction.md — every field and edge case in the output is described in the spec, and vice versa (see "Reference solution doesn't match your own spec").For each assertion, "could someone fake this and still pass?" is no — tests check the specific values that matter, not just row counts, types, or wide thresholds (see /submit#automated-review and /wrap-up §5).

### Audit the requirements

<sub>`/practice/requirements` · section: **Errors & Examples** · nav label: *Practice — Audit requirements* · [source](https://project-dynamo.learn.joinhandshake.com/practice/requirements)</sub>

You're the reviewer now. Each item below is something a task author actually put in a submission. Flag the ones that break a workflow requirement and leave the ones that are sound. The reason and the fix appear once you decide.

Flag each item that violates a task requirement. Leave the correct ones alone.

0 / 6 decided

instruction.md says "Save the cleaned data to the output folder."

instruction.md

Violates a requirementLooks correct

Success criterion - "The result should be correct and well-formatted."

instruction.md

Violates a requirementLooks correct

Dockerfile line - RUN pip install pandas==2.2.2 pytest

environment/Dockerfile

Violates a requirementLooks correct

task.toml adds an `author_name` and `email` field.

task.toml

Violates a requirementLooks correct

solve.sh opens with #!/bin/bash on line 1.

solution/solve.sh

Violates a requirementLooks correct

test.sh writes the score with - echo 1 > /logs/verifier/reward.txt

tests/test.sh

Violates a requirementLooks correct

Check my work

You can submit now; 6 blank items will count as incorrect.

If you flagged everything, look again — two of these are exactly right. The skill isn't suspicion; it's knowing which requirement each item is measured against.

### Don't expose the answer

<sub>`/practice/symlinking-errors` · section: **Errors & Examples** · nav label: *Practice — Don't expose the answer* · [source](https://project-dynamo.learn.joinhandshake.com/practice/symlinking-errors)</sub>

The grader never watches the agent work; it runs after the agent stops and reads what's left on disk — by opening the output paths your `instruction.md` names. But the agent controls those paths, which opens a cheat your content assertions will never catch.

#### The symlink cheat

Your verifier reads the agent's output by opening a fixed path — say `/app/output/clean.csv`. Instead of doing the work, the agent replaces that file with a **symlink** pointing at your answer key (commonly under `/tests/`, but also `/solution/`, a sibling `expected/`, or the untouched inputs). When your verifier follows the link, it reads *your own ground truth* back, every comparison matches, and the agent passes having done nothing. A plain `os.path.exists` or `is_file()` check doesn't save you — those follow symlinks too.

Two things defeat it:

1. **Load the truth independently**, from a location the agent's process can't name or reach — never read the expected answer from a path the agent could point a link at.
2. **Treat the output path as untrusted.** Before reading, confirm it isn't a symlink and that it resolves inside the agent's own tree — with an explicit check (`os.path.islink`, `os.lstat`, or `O_NOFOLLOW`), applied to *every* output path, including each file when you walk an output directory.

```
import os

p = "/app/output/clean.csv"
assert not os.path.islink(p)                      # the output must be a real file, not a redirect
assert os.path.realpath(p).startswith("/app/")    # and must resolve inside the agent's own tree

actual = open(p).read()
expected = load_expected_from_sealed_fixture()    # truth loaded independently, not from an agent-nameable path
assert actual == expected
```

The principle: compare *data the agent actually wrote* against *data your verifier loaded independently* — never one against a redirected copy of the other.

#### A subtler leak: A verifier that runs the agent's code

Symlinks aren't the only way the answer leaks — re-running the agent's code at grade time is another. Here's a real one.

The agent finishes a script (`/app/ledger_audit.py`) that reads a list of payment transactions, adds them up into each account's final balance, and writes those balances to `/app/audit.json`. The verifier grades it by running the script and checking its `/app/audit.json` against the correct answers stored in `/tests/data/expected/`.

**The error:** the script is run *after* Harbor overlays `/tests` into the container. So the script can just open the golden outputs in `/tests/data/expected/` (and the staged input fixtures), figure out which case is loaded, and copy the right answer to `/app/audit.json` — passing every case with zero ledger logic, and no symlink involved. The verifier handed the agent's own code a live view of the answer key.

How the task must **not** leak the answer:

- **Grade what's already on disk.** Score the artifacts the agent produced during its run; don't re-execute agent-controlled code at verify time — that code runs with `/tests` mounted and can read everything in it.
- **Keep the answer key unreachable.** Expected outputs (and, ideally, the raw fixtures) must live where the agent's process can never open them. If a path is mounted while agent code can run, assume the agent can read it.
- **Only your own harness runs at verify time**, loading the truth independently — never the agent's program handed a view of the fixtures and expected results.

A leak like this does double damage: because a copying "solution" never runs any real logic, it also masks bugs in *your own* reference — a defect can sit in an untested code path forever, since nothing ever exercises it.

#### Check your understanding

Check your understanding

A ledger-auditor task grades a submission by re-running the agent's own /app/ledger_audit.py as a subprocess — after Harbor has overlaid /tests into the container. Why can a submission that implements no ledger logic still pass every case?

The content assertions are too loose, so a roughly-right answer slips throughThe agent's code, running at grade time, can open /tests/data/expected/*.json and copy the golden answer straight to /app/audit.jsonThe output path is a symlink pointing at the answer keyThe spec contradicts itself, so any answer is defensible

Check answer

### Your docs must be true of the data

<sub>`/practice/coherent-contract` · section: **Errors & Examples** · nav label: *Practice — Coherent contract* · [source](https://project-dynamo.learn.joinhandshake.com/practice/coherent-contract)</sub>

A task's documentation can read perfectly — clear, unambiguous, no contradictions between one sentence and the next — and still be wrong, because it makes a claim about the data that the actual data doesn't back up. That's a different failure than a symlink or a leaked answer key: nothing is being exposed, nothing is gameable. The problem is that an agent doing exactly what it's told, trusting the documentation the way it's told to, can build something that breaks — not because the agent made a mistake, but because the documentation lied to it first.

#### The example

**The task.** A depot replenishment planner. The agent gets a systems team's field notes (`data_dictionary.md`) describing several CSV extracts, plus a year of historical sales and shipment records, and has to reconstruct each SKU's demand pattern to size a purchase order.

**The claim.** The data dictionary states, about the sales extract: *"The export writes exactly one row per SKU per date, including zero-fulfillment days."* Flat, checkable, unhedged.

**The reality.** The actual `daily_sales.csv` has 25,320 rows against an expected 25,200 (420 days × 60 SKUs). 120 of those rows are exact duplicates of an existing (date, SKU) pair — not conflicting values, just the same row twice. The dictionary's guarantee is false for 120 of the 25,200 keys it's making a claim about.

**Why it matters.** Nothing in the instruction or the dictionary says what to do if a duplicate shows up — because according to the dictionary, that can't happen. An agent who takes the documentation at its word (which is exactly what it's told to do: "read the dictionary before relying on any column") has every reason to write a straightforward day-by-day reconstruction that assumes each (date, SKU) key appears once. That reconstruction walks each SKU's days in order, subtracting that day's sales from running stock. Feed it a date with the sale counted twice, and the running stock goes negative — something the dictionary says is impossible.

This isn't hypothetical. The task's own reference solution has this exact line, with this exact comment:

```
# The export is one row per SKU per date; byte-identical repeats are a
# log-replay defect (keeping them drives reconstructed stock negative).
sales = sales.drop_duplicates()
```

The person who wrote the reference solution hit this, diagnosed it, and patched around it — proof that the gap between the documented claim and the real data is a genuine trap, not a theoretical one. An agent that doesn't happen to add the same defensive line either crashes outright or silently mis-tracks inventory for every affected SKU, through no fault of its own — it followed the instructions.

#### Why "An agent will obviously just dedupe it" Misses the point

It's tempting to wave this off: the duplicate rows are byte-identical, so dropping them is a one-line, unambiguous fix — surely any competent agent gets there. But the difficulty was never in the fix. It's that the documentation actively tells the agent this situation cannot occur, at the exact moment the agent is deciding whether it needs to guard against it. A rule that's trivial to satisfy once you know to look for it is still a real defect if nothing points you toward looking.

#### What actually fixes this

Two changes, and you need both:

- **Make the documentation true.** Either state the real invariant ("(date, SKU) pairs are usually unique, but duplicate rows can occur and should be treated as redundant, not summed") or fix the export so the guarantee is actually honored. Don't leave a hard, false claim sitting in a doc the agent is told to trust.
- **Test the case the documentation almost hid.** If duplicate rows are a real possibility in the data, ship a fixture that contains one and grade on it. A verifier that never exercises the one input shape the reference solution had to specially handle is exactly the kind of coverage gap that lets this go unnoticed — same lesson as the missing-test-case problem, just showing up on the authoring side instead of the grading side.

#### Check your understanding

Check your understanding

A data dictionary states "exactly one row per SKU per date." The actual file has 120 duplicate rows out of 25,200 expected keys, all byte-identical (no conflicting values). Why is this still worth fixing, given that dropping exact duplicates is a trivial, unambiguous operation?

It isn't worth fixing — any agent will obviously drop identical duplicate rows, so the documentation error has no real effectIt's a sound-verifier problem: the exact-match grading should be loosened to tolerate small discrepanciesThe documentation tells the agent this situation is impossible at the exact moment the agent is deciding whether to guard against it, so a straightforward, instruction-following implementation can crash or mis-track state through no fault of its ownIt's a protected-ground-truth problem: the duplicate rows let an agent infer the answer key early

Check answer

### The rules were wrong, and the checker was blind

<sub>`/practice/sound-verifier` · section: **Errors & Examples** · nav label: *Practice — Sound verifier* · [source](https://project-dynamo.learn.joinhandshake.com/practice/sound-verifier)</sub>

When you build a task, there are two major criteria to satisfy:

- Coherent contract
- Sound verifier

Every task has the same shape — an agent, an environment, a **contract** telling the agent what's true, and a **verifier** turning its work into a verdict. The two failure modes are just those two pieces going wrong:

![A task as an agent-environment loop. A contract feeds into the agent (failure point 1, must be true of the world); the agent acts on the environment, which returns a reward through the verifier (failure point 2, must soundly check the rule).](/assets/task-anatomy-loop.svg?v=2)

Two pieces, two ways to fail: the contract must be true of the world (①), and the verifier must soundly check the rule (②).

#### The contract failure: Example of a dinosaur park

In a movie called Jurassic Park, the geneticists on staff count the number of dinosaurs using a computer program (let's call it **Malcolm's counter**). The park's stated rule is clean and internally consistent: every dinosaur is engineered **female,** and a single-sex population cannot reproduce. Nothing about that rule contradicts itself.

The problem is that it isn't true of the actual system it describes. The geneticists filled gaps in incomplete dinosaur DNA with frog DNA, and some frog species can spontaneously change sex in a single-sex environment. The park's own biology quietly violates the assumption the entire safety plan was built on.

That's a **coherent-contract** failure: the rule reads fine, but it's false about the real system. Anyone trusting "all female means no breeding" — which is exactly what they're told to trust — has no reason to go looking for nests. The failure isn't sloppy writing. It's a true-sounding claim that the underlying reality doesn't actually honor.

#### The verifier failure: Counting to 238

Separately, the park's computer is asked to confirm the population is what it should be. It searches for dinosaurs and stops as soon as it finds the expected number — 238 — and reports success.

It never asks whether there are more than 238. So when the real population climbs past that number, the system keeps reporting exactly 238, every time, because it stops looking the moment it hits that count. Only when Malcolm reruns the query with a higher ceiling does it find the extras.

That's an **unsound-verifier** failure: the intended rule is "there must be exactly 238," but the code only ever checks "there are at least 238." The check exists — it's not missing — it's just calibrated to a coarser question than the one that was actually asked. It can catch a shortfall. It cannot, by construction, catch a surplus.

![A number line centered on 238. Below 238, a shortfall is caught because the search runs out early. Above 238, a surplus is missed because the search stops at 238 and never looks further.](/assets/sound-verifier-blindspot.svg)

The check is symmetric in appearance but not in effect — it catches too few, never too many.

Play with the same bug below. The counter is wired up exactly like the film: it stops at 238 no matter how high the real population climbs, until you flip on the patch.

Malcolm's counter

#### Why these are two separate defects, not one

Fixing either one leaves the other completely open:

- Warn every keeper that dinosaurs might be breeding, and the counting program still silently caps out at 238. The contract is now honest, but the system still can't detect the very thing you just warned everyone about.
- Patch the counting program to keep searching past 238, and the park's founding assumption — that an all-female population can't reproduce — is still false. The verifier now works, but nobody has corrected the belief that made anyone stop worrying about nests in the first place.

One is a wrong claim about the world. The other is a check that doesn't audit the full rule. Both have to be fixed, and fixing one tells you nothing about the state of the other.

#### Check your understanding

Check your understanding

The park's operating rule is "all dinosaurs are female, therefore they cannot breed." Why is this a coherent-contract defect rather than an unsound-verifier defect?

Because the rule is internally contradictory — it doesn't make logical sense on its ownBecause the rule is clear and self-consistent, but it's false about the actual system — the frog DNA gap-filling lets some dinosaurs change sex, something the rule never accounts forBecause nobody wrote a test to confirm the dinosaurs stayed femaleBecause the park's computer stops counting at 238

Check answer

## FAQ

<sub>`/faq/inplatform` · [source](https://project-dynamo.learn.joinhandshake.com/faq/inplatform)</sub>

Common questions from task authors. If your question isn't here, ask in #project-dynamo before you start guessing.

Slack

For project-specific and task-related questions. This is where you'll be in contact with your project team for day-to-day support.

[Launch Slack](https://handshakeai.enterprise.slack.com/)

Support Desk

For general program questions, access issues, CPT/OPT inquiries, pay questions, and other administrative needs. Reach out by selecting "Support" in the upper right hand corner of your Handshake AI dashboard.

[Handshake AI Dashboard](https://ai.joinhandshake.com/fellow/projects)

Office Hours

These sessions are led by your project team to support you throughout your fellowship journey. Sessions differ by project — please look out for guidance from your project lead.

### Supplemental resources

Help Center

Your central hub for FAQs, guides, and troubleshooting tips to help you navigate the program.

[Visit the Help Center](https://ai-support.joinhandshake.com/)

### The essentials

<sub>`/faq/inplatform/essentials` · section: **FAQ** · [source](https://project-dynamo.learn.joinhandshake.com/faq/inplatform/essentials)</sub>

Key things every fellow needs to know from day one.

##### What experience do I need before getting started?

This project requires GitHub and Terminal experience. You may still attempt the assessment if you are unfamiliar with these tools.

Because pay is based on approved tasks, earnings depend on your work quality and approvals. To leave the project, select **Support** in your Handshake AI dashboard.

##### Which CLI do I use to build and run a task?

**Harbor.** Install it once with `uv tool install harbor`, then point it at a task path: `harbor run -p . --agent oracle` (run from the `task/` directory). It builds the single task image, runs it, and writes the reward.

##### Do I put my name in task.toml?

There is no author or identity field in `task.toml` — you don't enter your name, email, or anything personal anywhere in it. Identity is tracked outside the manifest.

##### Do I write solve.sh as pure shell or use Python?

Whichever fits. Keep the real logic in a helper (e.g. `solution/solve.py`) that `solve.sh` calls. Use shell for CLI-style work and Python when you need libraries or data manipulation.

##### Where do reward.txt and ctrf.json go?

`/logs/verifier/reward.txt` and `/logs/verifier/ctrf.json`, written from inside the verifier. Harbor mounts `/logs/verifier/` at runtime - anywhere else and the task records as a silent failure.

##### Do I install pytest in the Dockerfile?

Yes — into the single `environment/Dockerfile`. pytest and `pytest-json-ctrf` are baked (pinned) there, and the verifier reuses the same image after the agent run. `tests/test.sh` installs/downloads nothing at verify time (the static checks reject it). `tests/` is not present during the agent run, so the agent still can't see the tests.

##### Is there a separate verifier image (tests/Dockerfile)?

No. Dynamo runs in **single verifier mode**: there is one image (built from `environment/Dockerfile`), used for both the agent run and the verifier run. Bake your test dependencies (pinned) into that single Dockerfile. There is no `tests/Dockerfile`, and no separate/shared mode distinction — leave `environment_mode` unset in `task.toml` (canonical TB2 shared model; Harbor overlays `tests/` at verify time). `tests/` itself is added only at verify time, so the agent never reads ground truth.

##### My task needs network access. What do I do?

The agent has **open internet by default** (`allow_internet = true` in `task.toml`). You don't need to do anything to enable it. The catch: because the network is open, the answer to your task must not be retrievable online — design the task so it can't simply be looked up, fetched, or copy-pasted from a public source.

##### How long should instruction.md be?

As short as possible, and **never more than 1,500 tokens** (hard cap). The shortest examples are three sentences. Lead with the problem, pin the paths, list the success criteria, name the constraints. If you specify a structured output, document the schema in the prompt or a referenced spec file. Never use subjective goals like "make this better" — every requirement needs an objective acceptance criterion the verifier can assert on.

##### How do I navigate the project dashboard?

Your dashboard has two main sections:

- **Available tasks** — unclaimed tasks open for you to pick up
- **My tasks** — tasks you've started or already submitted

Use the dropdown filters to find what you need:

- **Stage** — filter by where a task is in the process (e.g., In progress, Needs fixing)
- **Sort by** — order tasks from newest to oldest, or vice versa
- **Priority** — filter by urgency
- **Task type** — filter by task role (e.g., attempter or reviewer)

For a full walkthrough, check out the help center article below.

[Annotation platform overview](https://ai-support.joinhandshake.com/articles/32262318892439)

##### What are quality checks, and how do I resolve them?

Quality checks flag answers that may be incomplete or incorrect. You'll find them in the top-right corner of your task, next to the Skip and Exit buttons — look for the checklist icon (a page with a checkmark and an X).

To resolve a quality check:

1. Click the icon to open the quality checks panel.
2. Click into each flagged item. If there's a Reasoning dropdown, open it to see the explanation.
3. Fix the issue, or disagree with the check if you believe your answer is correct.

To disagree: click the strikethrough circle icon in the top-right corner of that quality check and enter your reasoning.

Resolve or respond to every quality check before continuing — unresolved checks will block your task.

##### I got my task back for review. How do I claim it and adjust the comments?

Tasks that have been reviewed will show up in your My tasks section as **Needs Fixing**.

The comments will appear in the quality checks section of your task. Most of the time, these will be marked as major or minor errors. Be sure to acknowledge and fix every mistake and comment, or the task may block you.

##### What is the unknown/holding stage?

This means a project lead is taking a closer look at your task. No action is needed from you — just continue working on other tasks as normal.

If this task is blocking you from moving forward, reach out to your project lead on Slack.

##### How long does it take for a task to be reviewed?

Most tasks are reviewed within 48 hours, though timing varies with submission volume.

Many reviewers are active on weekends, so we recommend waiting until Monday before following up. If you'd like faster feedback, reach out in Slack or office hours for a live review.

##### Can I use an LLM (ChatGPT, Claude, Gemini, Copilot, etc.) to help me with any part of this task?

Generally, no. You are strictly prohibited from using Large Language Models or other artificial intelligence-assisted tools (collectively, "LLMs") to generate work product for Handshake AI, unless otherwise expressly authorized in writing by Handshake.

To learn more, check out the help center article below.

[LLM policy](https://ai-support.joinhandshake.com/articles/37148280550295)

##### What work will I be paid for?

Tasks are paid based on time spent tasking. You must track your time in Handshake AI for every task you complete. This is our primary way of tracking work and processing payments.

Meetings are generally not paid unless explicitly stated by your project leads.

Projects may occasionally offer incentives for onboarding activities or high-quality work. For more information, please reference guidance shared by your project leads.

##### How will I be paid (setting up payments)?

Generally, every fellow will use Stripe, but some older fellows have access to Deel. If you don't know what Deel is, please ignore it. Each individual project has a unique pay rate and is listed on the contract related to that project.

[Set Up Stripe](https://ai-support.joinhandshake.com/articles/36935929970711)

##### When should I expect my pay to arrive?

Handshake AI processes payouts every Wednesday for the prior week's work. Banks may take a few additional days to post the funds to your account.

[Pay Processing Tracker](https://docs.google.com/document/d/1vbfwmvoFPCcecjI-m-EHMwAxujiN2tlmO81uDWBEBQM/edit?tab=t.0)

##### What is the maximum number of hours I can work each week?

You can work up to 40 hours per week. On rare occasions, fellows producing high-quality work may be approved to exceed this cap.

If you need to work beyond 40 hours in a given week, get approval from your project lead before billing the additional hours.

##### What is the minimum hourly requirement per week?

There usually isn't a minimum hourly requirement, but we encourage fellows to aim for at least 20 hours per week to maintain quality and task output.

Many fellows contribute 15–20 hours per week. Some projects do have a minimum — check your project instructions to confirm.

##### What should I do if I haven't received a payment?

Before reaching out, make sure you're tracking time in Handshake AI for every task completed, and remember that banks may take a few additional days to post funds.

If you still haven't received a payment notification, please wait until Friday at 12:00pm PST before reaching out. If it's past 12:00pm PST on Friday and you still haven't been paid, please visit our [Help Center](https://ai-support.joinhandshake.com/), or select "Support" in the upper right hand corner of your [Handshake AI dashboard](https://ai.joinhandshake.com/fellow/projects).

