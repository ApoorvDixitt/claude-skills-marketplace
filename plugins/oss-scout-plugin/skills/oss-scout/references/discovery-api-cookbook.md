# Discovery API Cookbook

Complete reference for programmatic repo discovery. Use these commands and tools
during Step 2 of the oss-scout workflow.

## Table of Contents
1. GitHub Search API (REST)
2. GitHub Search API (GraphQL)
3. gh CLI Commands
4. Detecting Company-Maintained Repos (Company→Org Mapping)
5. Stars Velocity (Growth Rate Detection)
6. Third-Party Discovery Tools

---

## 1. GitHub Search API (REST)

**Endpoint:** `GET https://api.github.com/search/repositories`

**Auth:** `Authorization: Bearer $GITHUB_TOKEN` + `X-GitHub-Api-Version: 2022-11-28`

**Rate limits:** 30 requests/minute (authenticated), 10/min (unauthenticated).
Hard cap: only first 1,000 results accessible per query — subdivide by star
ranges or date windows if you need more.

### Complete Search Qualifiers

| Category | Qualifiers |
|----------|-----------|
| Popularity | `stars:>N`, `stars:N..M`, `forks:>N` |
| Activity | `pushed:>YYYY-MM-DD`, `created:>YYYY-MM-DD` |
| Technical | `language:python`, `topic:machine-learning`, `license:mit` |
| Contributor-friendliness | `good-first-issues:>N`, `help-wanted-issues:>N` |
| Organization | `org:NAME`, `user:NAME`, `archived:false`, `is:public` |
| Text | `in:name,description,topics,readme` |
| Operators | AND (implicit), `OR`, `-` (NOT), range `N..M`, `N..*` |

**Sort options:** `stars`, `forks`, `help-wanted-issues`, `updated`

### Concrete Examples

**Python repos, 1000+ stars, active last 30 days, 5+ good-first-issues:**
```bash
curl -H "Authorization: Bearer $GITHUB_TOKEN" \
     -H "Accept: application/vnd.github+json" \
     "https://api.github.com/search/repositories?q=language:python+stars:>1000+pushed:>$(date -d '30 days ago' +%Y-%m-%d)+good-first-issues:>5&sort=stars&order=desc&per_page=100"
```

**TypeScript repos in Vercel's org with help-wanted issues:**
```bash
curl -H "Authorization: Bearer $GITHUB_TOKEN" \
     "https://api.github.com/search/repositories?q=org:vercel+language:typescript+help-wanted-issues:>0&sort=help-wanted-issues&order=desc"
```

**Fast-growing repos (created last 6 months, already 500+ stars):**
```bash
curl -H "Authorization: Bearer $GITHUB_TOKEN" \
     "https://api.github.com/search/repositories?q=created:>$(date -d '6 months ago' +%Y-%m-%d)+stars:>500+pushed:>$(date -d '7 days ago' +%Y-%m-%d)&sort=stars&order=desc"
```

**AI/agents domain repos with entry-point issues:**
```bash
curl -H "Authorization: Bearer $GITHUB_TOKEN" \
     "https://api.github.com/search/repositories?q=topic:ai-agents+stars:>500+good-first-issues:>2+pushed:>$(date -d '14 days ago' +%Y-%m-%d)&sort=stars&order=desc"
```

### Key Response Fields

```json
{
  "total_count": 227,
  "items": [{
    "full_name": "owner/repo",
    "stargazers_count": 37028,
    "forks_count": 3060,
    "open_issues_count": 4899,
    "language": "Python",
    "topics": ["analytics", "python"],
    "license": {"spdx_id": "MIT"},
    "pushed_at": "2026-07-20T07:37:10Z",
    "archived": false,
    "owner": {"login": "orgname"}
  }]
}
```

---

## 2. GitHub Search API (GraphQL)

Advantages: cursor-based pagination, inline issue label counts, custom field
selection in one request. Rate: 5,000 points/hour.

```graphql
query FindContributorFriendlyRepos($cursor: String) {
  search(
    query: "language:python stars:>1000 pushed:>2026-06-20 good-first-issues:>5"
    type: REPOSITORY
    first: 50
    after: $cursor
  ) {
    repositoryCount
    pageInfo { hasNextPage endCursor }
    edges {
      node {
        ... on Repository {
          nameWithOwner
          stargazerCount
          pushedAt
          url
          licenseInfo { spdxId }
          issues(states: OPEN, labels: ["good first issue"]) { totalCount }
          helpWantedIssues: issues(states: OPEN, labels: ["help wanted"]) { totalCount }
          pullRequests(states: OPEN) { totalCount }
          defaultBranchRef {
            target {
              ... on Commit {
                history(first: 1) {
                  nodes { committedDate }
                }
              }
            }
          }
        }
      }
    }
  }
}
```

Use via gh CLI:
```bash
gh api graphql --paginate -f query='...'
```

---

## 3. gh CLI Commands

### Search Repos

```bash
# Python repos with good-first-issues, sorted by help-wanted density
gh search repos --good-first-issues=">5" --language=python --stars=">=500" \
  --sort=help-wanted-issues --limit=50 \
  --json fullName,stargazersCount,description,updatedAt

# Within a specific org
gh search repos --owner=microsoft --language=typescript --stars=">=100" \
  --sort=stars --limit=30 --json fullName,stargazersCount,description

# By topic
gh search repos --topic=cli --topic=golang --stars=">=100" \
  --sort=stars --limit=20 --json fullName,stargazersCount,topics

# Formatted output with jq
gh search repos --language=rust --stars=">=1000" --sort=stars --limit=20 \
  --json fullName,stargazersCount,forksCount \
  --jq '.[] | "\(.fullName) | \(.stargazersCount)★ | \(.forksCount) forks"'
```

### Search Issues (Verify Entry Points Exist)

```bash
# Good first issues in a specific org
gh search issues --label="good first issue" --state=open --owner=facebook \
  --limit=50 --json title,repository,url,createdAt

# Unassigned help-wanted issues (ripe for contribution)
gh search issues --label="help wanted" --state=open --no-assignee \
  --language=rust --sort=created --order=desc --limit=30 \
  --json title,repository,url

# Issues in a specific repo (for entry-point existence check)
gh search issues --repo="vercel/next.js" --label="good first issue" \
  --state=open --sort=created --limit=5 --json title,url
```

### Raw API via `gh api`

```bash
# REST search
gh api search/repositories \
  -f q='language:python stars:>=1000 pushed:>=2026-06-20' \
  -f sort=stars -f order=desc -f per_page=50 \
  --jq '.items[] | {name: .full_name, stars: .stargazers_count, url: .html_url}'

# Commit activity (total commits in last 4 weeks)
gh api repos/OWNER/REPO/stats/commit_activity \
  --jq '.[52-4:] | [.[].total] | add'

# Contributors active in last 90 days (bus factor)
gh api repos/OWNER/REPO/stats/contributors \
  --jq '[.[] | select(.weeks[-13:] | map(.c) | add > 0)] | length'

# Community profile (CONTRIBUTING.md, CODE_OF_CONDUCT, etc.)
gh api repos/OWNER/REPO/community/profile \
  --jq '{contributing: .files.contributing, code_of_conduct: .files.code_of_conduct}'

# Last release date
gh api repos/OWNER/REPO/releases -f per_page=1 --jq '.[0].published_at'

# Cache results
gh api search/repositories \
  -f q='language:rust stars:>=500' -f sort=updated -f per_page=30 \
  --cache 3600s --jq '.items[] | "\(.full_name): \(.stargazers_count) stars"'
```

---

## 4. Detecting Company-Maintained Repos

### Company → GitHub Org Mapping

| Company | GitHub Orgs |
|---------|------------|
| **Google** | `google`, `googleapis`, `GoogleCloudPlatform`, `google-deepmind`, `google-research`, `angular`, `firebase`, `grpc`, `protocolbuffers`, `bazelbuild`, `istio`, `kubernetes`, `chromium` |
| **Meta** | `facebook`, `facebookresearch`, `facebookincubator`, `meta-llama`, `pytorch`, `reactjs` |
| **Microsoft** | `microsoft`, `Azure`, `dotnet`, `MicrosoftDocs`, `PowerShell`, `TypeScript`, `vscode`, `aspnet` |
| **Amazon/AWS** | `aws`, `awslabs`, `amazon`, `amzn`, `aws-amplify`, `aws-samples` |
| **Apple** | `apple`, `apple-oss-distributions`, `swiftlang`, `WebKit` |
| **Vercel** | `vercel` |
| **Cloudflare** | `cloudflare` |
| **HashiCorp** | `hashicorp` |
| **Netflix** | `Netflix` |
| **Uber** | `uber`, `uber-go` |
| **Stripe** | `stripe` |
| **Airbnb** | `airbnb` |
| **Shopify** | `Shopify` |
| **Databricks** | `databricks` |
| **Anthropic** | `anthropics` |
| **OpenAI** | `openai` |
| **Hugging Face** | `huggingface` |
| **Grafana Labs** | `grafana` |
| **Supabase** | `supabase` |
| **Elastic** | `elastic` |
| **JetBrains** | `JetBrains` |
| **Red Hat** | `redhat-developer`, `openshift` |
| **Salesforce** | `salesforce`, `forcedotcom` |
| **Adobe** | `adobe` |
| **Datadog** | `DataDog` |
| **Spotify** | `spotify` |
| **Square/Block** | `square`, `cashapp` |

### API-Based Company Detection

```bash
# 1. Direct org search
gh api search/repositories -f q='org:google language:go stars:>500' \
  --jq '.items[] | "\(.full_name) | \(.stargazers_count)★"'

# 2. Check top contributors' company fields (for repos NOT in official orgs)
gh api repos/OWNER/REPO/contributors -f per_page=10 \
  --jq '.[].login' | while read user; do
    gh api "users/$user" --jq '"\(.login): \(.company // "none")"'
  done

# 3. Check LICENSE for corporate copyright
curl -s "https://raw.githubusercontent.com/OWNER/REPO/main/LICENSE" | grep -i "copyright"

# 4. Check CODEOWNERS for corporate email domains
curl -s "https://raw.githubusercontent.com/OWNER/REPO/main/.github/CODEOWNERS"
```

### GraphQL: Contributor Org Membership

```graphql
query {
  repository(owner: "OWNER", name: "REPO") {
    defaultBranchRef {
      target {
        ... on Commit {
          history(first: 50) {
            nodes {
              author {
                user {
                  login
                  company
                  organizations(first: 5) {
                    nodes { login name }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
```

### Heuristic Scoring for Company Affiliation

| Signal | Confidence |
|--------|-----------|
| Repo in known company org | Certain (100%) |
| Majority of top 10 contributors list same company | High (80%) |
| LICENSE contains corporate copyright | Good (60%) |
| CODEOWNERS references company email domain | Good (50%) |

---

## 5. Stars Velocity (Growth Rate Detection)

GitHub doesn't expose "stars gained in last N days" directly. Three approaches:

### Approach A: Binary Search on Stargazers (Best for Individual Repos)

Use the custom Accept header to get star timestamps:

```bash
gh api repos/OWNER/REPO/stargazers \
  -H "Accept: application/vnd.github.star+json" \
  -f per_page=100 -f page=1 \
  --jq '.[0].starred_at'
```

Stargazers are returned chronologically. Binary search across pages to find
where stars from N days ago begin. Cost: ~13 API calls for any repo size.

```python
import requests, math
from datetime import datetime, timedelta

def star_velocity(owner, repo, days=30, token=None):
    headers = {"Accept": "application/vnd.github.star+json",
               "Authorization": f"Bearer {token}"}
    
    r = requests.get(f"https://api.github.com/repos/{owner}/{repo}",
                     headers={"Authorization": f"Bearer {token}"})
    total = r.json()["stargazers_count"]
    total_pages = math.ceil(total / 100)
    cutoff = datetime.utcnow() - timedelta(days=days)
    
    lo, hi = 1, total_pages
    while lo < hi:
        mid = (lo + hi) // 2
        r = requests.get(
            f"https://api.github.com/repos/{owner}/{repo}/stargazers?per_page=100&page={mid}",
            headers=headers)
        page = r.json()
        first_date = datetime.fromisoformat(page[0]["starred_at"].replace("Z", "+00:00")).replace(tzinfo=None)
        if first_date < cutoff:
            lo = mid + 1
        else:
            hi = mid
    
    r = requests.get(
        f"https://api.github.com/repos/{owner}/{repo}/stargazers?per_page=100&page={lo}",
        headers=headers)
    page = r.json()
    idx = next((i for i, s in enumerate(page)
                if datetime.fromisoformat(s["starred_at"].replace("Z", "+00:00")).replace(tzinfo=None) >= cutoff), len(page))
    
    stars_before = (lo - 1) * 100 + idx
    recent = total - stars_before
    return {"total": total, f"stars_last_{days}d": recent, "per_day": round(recent/days, 1)}
```

### Approach B: OSS Insight API (Best for Curated Collections, Zero Auth)

```bash
# Star velocity for AI Agent Frameworks collection
curl "https://ossinsight.io/api/mcp?action=ranking&collectionId=10098&metric=stars&range=last-28-days"

# Returns: last_period_total (stars gained), total_pop (% change), rank_pop (rank change)

# Key collection IDs:
# 10098 = AI Agent Frameworks
# 10076 = LLM Tools
# 10087 = LLM DevTools
# 10094 = Vector Database
# 10099 = MCP Clients

# List all collections
curl "https://ossinsight.io/api/mcp?action=collections"

# Compare two repos
curl "https://ossinsight.io/api/mcp?action=compare&repo1=facebook/react&repo2=vuejs/vue"
```

### Approach C: Alternative Growth Signals

```bash
# Fork velocity (recent forks)
gh api repos/OWNER/REPO/forks -f sort=newest -f per_page=100 \
  --jq '[.[] | select(.created_at > "2026-06-20")] | length'

# Issue velocity (issues opened in last 30 days)
gh api search/issues -f q='repo:OWNER/REPO created:>=2026-06-20' -f per_page=1 \
  --jq '.total_count'

# Commit frequency (last 4 weeks)
gh api repos/OWNER/REPO/stats/commit_activity \
  --jq '.[52-4:] | [.[].total] | add'
```

---

## 6. Third-Party Discovery Tools

| Tool | URL | Auth | Best For |
|------|-----|------|----------|
| **OSS Insight** | ossinsight.io/api/mcp | None | Pre-computed rankings, star velocity, collections |
| **github-trending-api** | ghapi.huchen.dev | None | Trending repos (daily/weekly/monthly) |
| **Libraries.io** | libraries.io/api | API key (free) | Dependency graph, "who depends on this?", SourceRank |
| **ecosyste.ms** | repos.ecosyste.ms/api/v1 | None | Cross-host data, OpenSSF Scorecard |

### github-trending-api (Trending Mirror)

```bash
# Trending Python repos this week
curl "https://ghapi.huchen.dev/repositories?language=python&since=weekly"

# Response includes currentPeriodStars (stars gained this period)
```

### Libraries.io (Dependency Impact — Foundational Infra Signal)

```bash
# Search packages sorted by dependents (who depends on this = how foundational it is)
curl "https://libraries.io/api/search?q=react&platforms=npm&sort=dependents_count&api_key=$KEY"

# How many packages depend on this?
curl "https://libraries.io/api/npm/express/dependents?api_key=$KEY"

# Repo SourceRank (composite quality score)
curl "https://libraries.io/api/github/facebook/react?api_key=$KEY"
```

Sort options: `rank`, `stars`, `dependents_count`, `dependent_repos_count`,
`latest_release_published_at`, `contributions_count`

### ecosyste.ms

```bash
# Org-level stats (total stars, repo count)
curl "https://repos.ecosyste.ms/api/v1/hosts/GitHub/owners/google"

# Specific repo metadata
curl "https://repos.ecosyste.ms/api/v1/hosts/GitHub/repositories/facebook%2Freact"
```

---

## Quick Reference: Best Tool for Each Task

| Task | Best Tool | Auth |
|------|-----------|------|
| Search repos by criteria | `gh search repos` or REST API | PAT |
| Inline issue label counts | GraphQL query | PAT |
| Trending repos (daily/weekly) | github-trending-api | None |
| Star velocity (curated) | OSS Insight | None |
| Star velocity (any repo) | Binary search on stargazers | PAT |
| Dependency impact / foundational | Libraries.io | API key |
| Company-backed repo detection | org: qualifier + contributor fields | PAT |
| Cross-ecosystem metadata | ecosyste.ms | None |
