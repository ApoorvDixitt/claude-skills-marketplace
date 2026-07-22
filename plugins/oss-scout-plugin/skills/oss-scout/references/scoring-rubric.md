# Scoring Rubric: 3-Factor Career-Impact Formula

This rubric defines the oss-scout scoring formula, re-weighted specifically for
the goal of maximizing career impact from a merged contribution.

## The Formula

```
Total Score = Recognizability (35%) + Contributability (35%) + Role/Ecosystem Relevance (30%)
```

Each factor is scored 0-100, then weighted to produce a 0-100 composite.

---

## Factor 1: Recognizability (35% weight)

This measures whether a recruiter, hiring manager, or engineering peer would
recognize the project name on a resume. A contribution to React moves the needle
more than one to someone's personal utility library, regardless of code quality.

### Sub-Metrics

| Metric | Weight | 100 | 75 | 50 | 25 | 0 |
|--------|--------|-----|----|----|----|----|
| **Star tier** | 40% | 50K+ stars | 10K-50K | 2K-10K | 500-2K | <500 |
| **Org prominence** | 35% | Known company org (FAANG/top-tier) | Known company org (mid-tier) | Well-known independent project | Small but respected | Unknown individual |
| **Trending/velocity** | 25% | >100 stars/day last 28d | 20-100/day | 5-20/day | 1-5/day | Flat or declining |

### How to Compute

```bash
# Star count
gh api repos/OWNER/REPO --jq '.stargazers_count'

# Org prominence: check owner against company-org mapping in discovery-api-cookbook.md
gh api repos/OWNER/REPO --jq '.owner.login'
# Then match against the table. If no match, check contributor companies:
gh api repos/OWNER/REPO/contributors -f per_page=5 --jq '.[].login' | \
  while read user; do gh api "users/$user" --jq '"\(.login): \(.company // "none")"'; done

# Star velocity (use binary search method or OSS Insight — see cookbook Section 5)
```

### Scoring Logic

**Star tier scoring:**
- 50K+ stars = 100
- 10K-50K = 75
- 2K-10K = 50
- 500-2K = 25
- <500 = 0

**Org prominence scoring:**
- Repo is in a FAANG/top-tier company org (Google, Meta, Microsoft, Apple, Amazon, Vercel, Cloudflare, Anthropic, OpenAI) = 100
- Repo is in a known mid-tier company org (Stripe, Shopify, Uber, Netflix, Airbnb, Databricks, Grafana, Supabase, Elastic) = 75
- Well-known independent project (e.g., SQLite, curl, Neovim — not in a company org but universally recognized) = 75
- Respected independent project (1K+ stars, active community, recognizable in its niche) = 50
- Small project, not widely known = 25
- Unknown individual's repo = 0

**Trending/velocity scoring:**
- >100 stars/day = 100 (viral, everyone is watching)
- 20-100/day = 75 (actively trending)
- 5-20/day = 50 (steady growth)
- 1-5/day = 25 (healthy but not trending)
- Flat or declining = 0

**Factor 1 total** = (star_tier × 0.40) + (org_prominence × 0.35) + (velocity × 0.25)

---

## Factor 2: Contributability (35% weight)

This measures how likely you are to actually get a PR reviewed, approved, and
merged within a reasonable time. A famous but unresponsive project (PRs sit for
months) scores lower than one that's both recognizable AND actively reviewing
contributions. This factor prevents recommending repos where you'd waste effort.

### Sub-Metrics

| Metric | Weight | 100 | 75 | 50 | 25 | 0 |
|--------|--------|-----|----|----|----|----|
| **Last commit** | 20% | ≤7 days | ≤14 days | ≤30 days | ≤90 days | >90 days |
| **PR review turnaround** | 25% | ≤2 days median | ≤5 days | ≤14 days | ≤30 days | >30 days |
| **PR merge rate** | 20% | >70% | 50-70% | 30-50% | 10-30% | <10% |
| **Release cadence** | 10% | ≤30 days since last | ≤60 days | ≤120 days | ≤365 days | >365 days |
| **Bus factor** | 10% | 5+ active | 4 | 3 | 2 | 1 |
| **Entry-point issues exist** | 10% | 10+ GFI open | 5-9 | 3-4 | 1-2 | 0 |
| **Not archived** | 5% | Active | — | — | — | Archived |

### How to Compute

```bash
# Last commit date
gh api repos/OWNER/REPO --jq '.pushed_at'

# PR review turnaround (time from open to first review on last 10 merged PRs)
gh api graphql -f query='
{
  repository(owner:"OWNER", name:"REPO") {
    pullRequests(states:MERGED, last:10, orderBy:{field:UPDATED_AT, direction:DESC}) {
      nodes {
        createdAt
        reviews(first:1) { nodes { createdAt } }
      }
    }
  }
}'

# PR merge rate
gh api graphql -f query='
{
  repository(owner:"OWNER", name:"REPO") {
    merged: pullRequests(states:MERGED, last:100) { totalCount }
    closed: pullRequests(states:CLOSED, last:100) { totalCount }
  }
}'
# merge_rate = merged / (merged + closed)

# Last release date
gh api repos/OWNER/REPO/releases -f per_page=1 --jq '.[0].published_at'

# Bus factor (contributors with commits in last 90 days)
gh api repos/OWNER/REPO/stats/contributors \
  --jq '[.[] | select(.weeks[-13:] | map(.c) | add > 0)] | length'

# Good-first-issue count
gh api search/issues \
  -f q='repo:OWNER/REPO label:"good first issue" state:open' --jq '.total_count'

# Archived status
gh api repos/OWNER/REPO --jq '.archived'
```

### Scoring Logic

**Factor 2 total** = sum of (each metric_score × weight)

If the repo is archived, the entire Contributability score = 0 regardless of
other metrics (it's a hard disqualifier for contribution).

---

## Factor 3: Role/Ecosystem Relevance (30% weight)

This measures whether the repo's domain is relevant to the user's career
positioning. For oss-scout's default profile (fullstack/backend/AI/agents), we
score broadly — any project touching these domains counts, plus "foundational
worldwide infrastructure" (Postgres-tier projects that every engineer knows
regardless of stack).

### Sub-Metrics

| Metric | Weight | 100 | 75 | 50 | 25 | 0 |
|--------|--------|-----|----|----|----|----|
| **Domain alignment** | 60% | Core AI/agents/backend/fullstack tool | Adjacent (DevOps, data, ML infra) | General developer tooling | Specialized niche | Unrelated (gaming, embedded, etc.) |
| **Foundational infra** | 40% | Worldwide critical infra (Postgres/Linux/nginx tier) | Major ecosystem tool (Express/Django/Rails tier) | Popular in niche (Prisma/Drizzle tier) | Useful but small | Not foundational |

### How to Compute

```bash
# Topics and language (proxy for domain alignment)
gh api repos/OWNER/REPO --jq '{language: .language, topics: .topics, description: .description}'

# Dependents count (foundational infra signal via Libraries.io)
curl "https://libraries.io/api/github/OWNER/REPO?api_key=$LIBRARIES_IO_KEY" | jq '.dependents_count'
# OR for npm packages specifically:
curl "https://libraries.io/api/npm/PACKAGE_NAME?api_key=$LIBRARIES_IO_KEY" | jq '.dependents_count'
```

### Scoring Logic

**Domain alignment scoring:**
- Topics/description contain: `ai`, `agent`, `llm`, `machine-learning`, `backend`,
  `api`, `server`, `fullstack`, `web-framework`, `database`, `orm` = 100
- Topics contain: `devops`, `ci-cd`, `cloud`, `infrastructure`, `data-pipeline`,
  `ml-ops`, `monitoring` = 75
- General developer tools: `cli`, `testing`, `linting`, `bundler`, `package-manager` = 50
- Specialized niche: `game-engine`, `embedded`, `mobile-only`, `desktop-gui` = 25
- Completely unrelated to software engineering = 0

**Foundational infra scoring:**
- 100K+ dependents (worldwide critical: express, lodash, react, django) = 100
- 10K-100K dependents (major ecosystem) = 75
- 1K-10K dependents (popular in niche) = 50
- 100-1K dependents = 25
- <100 or not a library/framework = scored on other merits (use domain alignment only)

When Libraries.io data isn't available, estimate from: star count + breadth of
use (is this something every engineer in the domain would recognize?).

**Factor 3 total** = (domain_alignment × 0.60) + (foundational_infra × 0.40)

---

## Final Score Calculation

```
TOTAL = (Factor1 × 0.35) + (Factor2 × 0.35) + (Factor3 × 0.30)
```

### Interpretation

| Score | Recommendation |
|-------|---------------|
| 80-100 | Excellent — actively pursue, this is resume gold |
| 65-79 | Strong — high-impact opportunity worth investigating |
| 50-64 | Good — solid option if the available issues are compelling |
| 35-49 | Moderate — consider only if you have specific interest |
| 20-34 | Weak — low visibility or unlikely to merge |
| 0-19 | Skip — dead, archived, or completely misaligned |

---

## Edge Cases and Adjustments

**Bonus: +5 points** if the repo's primary maintainer has publicly hired
past contributors (documented pattern for React, Kubernetes, Rust teams).

**Penalty: -10 points** if the repo has a documented AI contribution ban
(still show it in results, but note the restriction).

**Override: cap at 30** if the repo is archived (technically score should be 0
on Contributability, but just in case partial data makes it through).
