# Career Leverage from OSS Contributions

Post-merge follow-up and resume/LinkedIn/X content generation.
This is the reference for Step 8 of the oss-contribute workflow.

## Post-Merge Follow-Up

Immediately after merge:
1. Delete the remote branch (GitHub offers a button)
2. Delete local branch: `git branch -D branch-name`
3. Sync fork: `git pull upstream main` then `git push origin main`
4. Watch the repository for issues related to your change
5. Respond quickly if anyone reports a regression

## Building Ongoing Reputation

The contributor funnel (Mike McQuaid, Homebrew):
Users (millions) → Contributors (thousands) → Maintainers (tens)

**Progression path after first merge:**
- Help triage other issues in the same area of code
- Submit follow-up PRs building on your understanding
- Participate in design discussions and RFC processes
- Offer to help with maintenance (CI, deps, releases)
- Demonstrate judgment by knowing when to say "no"

## Resume Bullets

**Formula:** [Action verb] + [specific thing] + [quantified impact] + [PR reference]

**Examples:**
- "Implemented lazy-loading optimization for Next.js (100K+ stars), reducing initial bundle size by 34% (PR #8901)"
- "Fixed critical race condition in Kubernetes scheduler (CNCF graduated), preventing pod failures in 500+ node clusters"
- "Authored authentication docs for FastAPI (65K+ stars), referenced in 12 Stack Overflow answers"

**Action verbs (ranked by impact):**
Architected, Implemented, Redesigned, Optimized, Fixed, Authored, Maintained,
Contributed, Migrated, Refactored

**Where to put it:** Dedicated "Open Source Contributions" section on resume,
not buried under generic "Projects."

## LinkedIn Post

**Formula:**
```
Just got a PR merged into [Project]!

The problem: [1-2 sentences on what was broken/missing]

My approach: [1-2 sentences on what you did]

What I learned: [1-2 sentences — the interesting technical or process insight]

[Link to PR]

#opensource #[language] #[project]
```

**Note:** Hand off to x-writing and humanizer skills for final tone/voice.

## X/Twitter Thread

**Formula:**
```
Tweet 1: [Hook + announcement]
"Just shipped my first contribution to [Project] — here's how a [duration]
investigation turned into a [X]-line fix"

Tweet 2: [The problem]
"The issue: [concise description]. This affected [who/what]."

Tweet 3: [The approach]
"My approach: [what you did]. The tricky part was [challenge]."

Tweet 4: [The learning]
"Biggest takeaway: [insight about the codebase/process/review]"

Tweet 5: [The link]
"PR: [link]. If you're looking to contribute to [Project], [tip for others]."
```

**Note:** Hand off to x-writing skill for voice, then humanizer for final polish.

## Cold Outreach Formula

```
Subject: [Project] contributor — thoughts on [observation about their stack]

Hi [Name],

I noticed [Company] uses [Project] in [specific context]. I've been contributing
to [Project] for [duration] — most recently [contribution + link].

[One technical insight relevant to how they use it.]

Would love to chat about [mutual interest]. [Low-commitment ask.]
```

## Key Principles

- Quantify everything possible (lines changed, performance improvement, users affected)
- Always link to the actual PR — it's verifiable proof
- Frame in terms the audience cares about (recruiters want impact, engineers want technical depth)
- Show progression over time (first PR → regular contributor → area expert)
- Mention the review process: "received feedback on X, iterated to Y" shows collaboration
