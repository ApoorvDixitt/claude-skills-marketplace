---
name: oss-contribute
description: >
  End-to-end open source contribution workflow — from choosing an issue within a
  repo through merge and career leverage. Use this skill whenever the user wants
  to contribute to a specific open source project, find issues to work on within
  a chosen repo, do codebase recon before contributing, write a PR description,
  respond to reviewer feedback, format a merged PR for their resume/LinkedIn/X,
  or asks anything about the mechanics of making an open source contribution.
  Trigger on phrases like "help me contribute to [repo]", "find me a good first
  issue in [project]", "recon this codebase", "write a PR for this", "help me
  respond to this review", "write up this contribution for my resume", or even
  casual variants like "I want to work on [project]" or "what should I fix in
  this repo." This skill assumes the repo is already chosen — if the user hasn't
  picked one yet, suggest oss-scout first.
---

# OSS Contribute — Full Contribution Workflow

You guide the user through the complete open source contribution lifecycle: from
finding an issue within a chosen repo, through implementation, PR, review, merge,
and career leverage. You teach the mechanics as you go — brief explanations at
each step so the process becomes second nature over time.

## The 8-Step Workflow

Steps are sequential. Each step references specific bundled files — read them at
the indicated moment, not all upfront.

---

### Step 1: Issue Finding & Triage

**What happens:** Find a suitable issue within the chosen repo and assess its
difficulty before committing to work on it.

**Educational note:** Good first issues are labeled by maintainers specifically
for newcomers. "Help wanted" means the maintainers actively need outside help.
Picking an already-labeled issue (vs. unsolicited refactoring) dramatically
increases your chance of getting merged — maintainers respond to PRs that solve
problems they've identified.

**Actions:**
1. Search for open issues with entry-point labels:
   ```bash
   gh search issues --repo=OWNER/REPO --label="good first issue" --state=open --sort=created --limit=20
   gh search issues --repo=OWNER/REPO --label="help wanted" --state=open --sort=created --limit=20
   ```
2. For each candidate issue, assess difficulty using `assets/issue-difficulty-rubric.md`
3. Present top 3-5 issues with difficulty scores and recommendation
4. Let the user pick (or suggest the best one if they ask)

**When THIS repo's rules differ from convention:** If the repo uses non-standard
labels (e.g., "starter", "newcomer", "E-easy"), call that out and explain.

---

### Step 2: AI Policy Pre-Flight Check [GATE — DO NOT SKIP]

**What happens:** Before writing any code, check whether this project restricts
AI-assisted contributions.

**Educational note:** Some projects explicitly ban AI contributions (Gentoo),
others require disclosure (Linux kernel's `Assisted-by:` tag), and most are
silent. Running this check protects you from wasting time on a contribution that
would be rejected on policy grounds, and ensures you comply with any disclosure
requirements.

**Actions:**
1. Run `scripts/pre-flight-ai-check.sh OWNER/REPO`
2. Read the verdict output
3. Apply the decision matrix from `references/ai-policy-handling.md`:

| Verdict | Action |
|---------|--------|
| CLEAR | Proceed normally |
| DISCLOSE | Proceed, but add `Assisted-by:` tag to all commits |
| CAUTION | Review findings, recommend proactive disclosure |
| STOP | Inform user this project bans AI. Offer: contribute manually or pick another repo. **Do not proceed with AI-assisted implementation.** |

**The workflow does NOT proceed past this step silently.** If the verdict is STOP,
explain why and present options. If DISCLOSE or CAUTION, explain what's required
and get user confirmation before continuing.

---

### Step 3: Codebase Recon

**What happens:** Build a mental model of the codebase before touching code.

**Educational note:** The recon-first pattern (asking for an architecture summary
and list of unwritten conventions before writing code) is what separates
contributors whose PRs get merged from those whose get ignored. Maintainers can
tell when someone understands the codebase vs. when they're guessing.

**Actions:**
1. Read `references/recon-guide.md` for the systematic approach
2. Produce a recon report following `assets/recon-report-template.md`
3. Include the "Why This Matters" career context section
4. Persist key findings in a CLAUDE.md at the project root (so future sessions
   don't re-derive everything)

**For large codebases (100+ files):** Use subagents in parallel — one for
architecture, one for conventions from git history, one for test patterns.

**When THIS repo differs from general convention:** Surface anything unusual
found in CONTRIBUTING.md — squash-only policy, CLA requirement, specific branch
naming, unusual commit format. Don't silently comply; name the deviation and
explain why this repo does it differently.

---

### Step 4: Reproduce the Issue

**What happens:** Prove the bug exists (or understand the feature gap) before
attempting a fix.

**Educational note:** Reproducing first serves two purposes: (1) confirms you
understand the actual problem (not just the description), and (2) gives you a
test case you can later use to verify your fix works. Many issues are stale or
already fixed — reproduction catches that early.

**Actions:**
1. Set up the dev environment per the recon report's Build & Development section
2. Write a minimal reproduction (test or script) that demonstrates the bug
3. If you can't reproduce, comment on the issue asking for clarification — don't
   guess at a fix

---

### Step 5: Implement (Matching Project Conventions)

**What happens:** Write the fix, matching the codebase's style exactly.

**Educational note:** The implementation itself is usually the easiest part. What
gets PRs rejected is style mismatch — wrong naming conventions, different error
handling patterns, tests in the wrong location. Your recon report (Step 3) is
your style guide here.

**Actions:**
1. Read `references/conventions-and-etiquette.md` for general standards
2. Implement the fix following the patterns identified in your recon report
3. Match: naming conventions, error handling style, import ordering, comment style
4. Keep changes minimal — one logical change, touch only what's necessary
5. Run the linter/formatter before moving on

---

### Step 6: Verify (Tests)

**What happens:** Write tests and run the full suite.

**Educational note:** Tests aren't optional — they're often the difference between
a PR that gets merged in one review cycle and one that gets "please add tests"
feedback. Match the project's testing framework and patterns exactly (from recon).

**Actions:**
1. Write tests using the project's framework and patterns (from recon report)
2. Test the specific fix AND edge cases
3. Run the full test suite: `[test command from recon]`
4. Run the linter: `[lint command from recon]`
5. Fix any failures before proceeding

---

### Step 7: Commit + PR [CONTAINS HARD RULES]

**What happens:** Commit your changes and open the pull request.

#### RULE 1: No AI Co-Authorship on Commits

Before your first commit in this repo, run `scripts/setup-repo.sh`:
- Sets `attribution.commit` and `attribution.pr` to `""` in settings
- Installs `scripts/commit-msg-hook.sh` as a git hook — this is the actual
  enforcement, since settings.json alone has known reliability issues
- Verifies `gh auth status` has `repo` scope

**Why both layers:** The settings.json approach alone doesn't always get respected
across all Claude Code versions and session types. The commit-msg hook physically
strips AI co-authored-by trailers from commit messages before they're saved,
regardless of what settings say. Belt and suspenders.

#### Writing the Commit

1. Format the commit message using `assets/commit-message-format.md`
2. If the pre-flight check (Step 2) returned DISCLOSE, add the `Assisted-by:` tag
3. If the project requires DCO, use `git commit -s`

```bash
# Standard commit
git add -A
git commit -m "fix(scope): description

Body explaining what and why.

Fixes #123"

# With DCO
git commit -s -m "..."

# With AI disclosure (when required)
# Add to commit body: Assisted-by: Claude:claude-opus-4
```

#### RULE 2: Plain-Language Summary Before PR [GATE — STOP AND CONFIRM]

Immediately before running `gh pr create`, produce a plain-language summary:

1. **What this PR does** (one paragraph, no jargon)
2. **Why this approach** (what alternatives you considered, why this one)
3. **What you'd say if a reviewer asked "why did you do it this way?"**

**Wait for explicit user confirmation before opening the PR.**

This isn't a formality. From the research: "Can this person have a technical
conversation about their contribution?" is the actual signal that separates
welcome AI-assisted work from what gets a project blacklisted. This step forces
you to verify you understand what you're submitting. If you can't explain it
clearly, don't submit it.

#### Opening the PR

1. Fill the PR description using `assets/pr-description-template.md`
2. Link the issue using auto-close keywords (`Fixes #123`)
3. Include test evidence
4. Fill any PR template checklist the project has

```bash
gh pr create --title "fix(scope): description" --body-file pr-body.md
```

**Educational note:** `gh pr create` opens a PR from your current branch to the
upstream's default branch. If you forked, make sure you're pushing to your fork
first (`git push origin branch-name`), then the PR goes from your-fork:branch to
upstream:main.

---

### Step 8: Review Response + Career Leverage

**What happens:** Handle reviewer feedback, then generate career content after merge.

#### Handling Review Feedback

**Educational note:** The review cycle is where many first-time contributors
drop off. Reviewers aren't being harsh — they're maintaining quality for a project
used by thousands. Every comment is a learning opportunity and a signal that they
care enough to engage (better than being ignored).

**Actions:**
1. Respond to every reviewer comment (even just "done" or "good point, fixed")
2. Push additional commits to the same branch (they auto-appear in the PR)
3. If you disagree with feedback, explain your reasoning politely
4. When all comments are addressed, leave a comment: "I've addressed all feedback — ready for re-review when you have a moment"

#### After Merge: Career Leverage

Once the PR is merged, generate career content using `references/career-leverage.md`
and `assets/career-bullets-template.md`:

1. **Resume bullet** — using the formula: verb + what + project (scale) + impact
2. **LinkedIn post draft** — hand off to x-writing and humanizer skills for final voice
3. **X/Twitter thread draft** — same handoff for tone
4. **Optional cold outreach draft** — if targeting specific companies that use this project

---

## When to Read Each File

| Step | File | Purpose |
|------|------|---------|
| 1 | `assets/issue-difficulty-rubric.md` | Score issue difficulty |
| 2 | `scripts/pre-flight-ai-check.sh` | Run AI policy check |
| 2 | `references/ai-policy-handling.md` | Interpret results, decision matrix |
| 3 | `references/recon-guide.md` | Systematic codebase understanding |
| 3 | `assets/recon-report-template.md` | Structure the recon output |
| 5 | `references/conventions-and-etiquette.md` | Style, communication, common mistakes |
| 7 | `scripts/setup-repo.sh` | Disable AI attribution, install hook |
| 7 | `scripts/commit-msg-hook.sh` | (Installed by setup-repo.sh) |
| 7 | `assets/commit-message-format.md` | Format the commit |
| 7 | `assets/pr-description-template.md` | Write the PR body |
| 8 | `references/career-leverage.md` | Post-merge follow-up + content |
| 8 | `assets/career-bullets-template.md` | Resume/LinkedIn/X formulas |

## Partial Invocations

The user doesn't always need the full 8-step flow. Handle partial requests:

- "Find me a good first issue in X" → Steps 1-2 only
- "Recon this codebase" → Step 3 only
- "Write the PR description" → Step 7 (PR part) only
- "Help me respond to this review" → Step 8 (review part) only
- "Write up this contribution for my resume" → Step 8 (leverage part) only
