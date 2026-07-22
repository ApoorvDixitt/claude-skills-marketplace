#!/bin/bash
# score-repo.sh — Score a repo using the 3-factor career-impact formula
# Usage: ./score-repo.sh OWNER/REPO
#
# Outputs JSON with raw metrics and computed scores for each factor.
# Requires: gh CLI (authenticated), jq, curl
#
# Formula:
#   Total = Recognizability (35%) + Contributability (35%) + Role/Ecosystem Relevance (30%)

set -euo pipefail

REPO="${1:?Usage: score-repo.sh OWNER/REPO}"
OWNER=$(echo "$REPO" | cut -d'/' -f1)
NAME=$(echo "$REPO" | cut -d'/' -f2)

# --- Collect raw metrics ---

echo "Scoring $REPO..." >&2

# Basic repo data (single API call)
REPO_DATA=$(gh api "repos/$REPO" --jq '{
  stars: .stargazers_count,
  pushed_at: .pushed_at,
  archived: .archived,
  language: .language,
  topics: .topics,
  description: .description,
  owner: .owner.login,
  license: (.license.spdx_id // "none")
}')

STARS=$(echo "$REPO_DATA" | jq -r '.stars')
PUSHED_AT=$(echo "$REPO_DATA" | jq -r '.pushed_at')
ARCHIVED=$(echo "$REPO_DATA" | jq -r '.archived')
LANGUAGE=$(echo "$REPO_DATA" | jq -r '.language')
TOPICS=$(echo "$REPO_DATA" | jq -r '.topics | join(",")')
DESCRIPTION=$(echo "$REPO_DATA" | jq -r '.description // ""')
REPO_OWNER=$(echo "$REPO_DATA" | jq -r '.owner')

# Good-first-issue count
GFI_COUNT=$(gh api search/issues -f q="repo:$REPO label:\"good first issue\" state:open" --jq '.total_count' 2>/dev/null || echo "0")

# Last release date
LAST_RELEASE=$(gh api "repos/$REPO/releases" -f per_page=1 --jq '.[0].published_at // "none"' 2>/dev/null || echo "none")

# Bus factor (active contributors in last 90 days)
BUS_FACTOR=$(gh api "repos/$REPO/stats/contributors" --jq '[.[] | select(.weeks[-13:] | map(.c) | add > 0)] | length' 2>/dev/null || echo "1")

# --- Score Factor 1: Recognizability ---

# Star tier
if [ "$STARS" -ge 50000 ]; then STAR_SCORE=100
elif [ "$STARS" -ge 10000 ]; then STAR_SCORE=75
elif [ "$STARS" -ge 2000 ]; then STAR_SCORE=50
elif [ "$STARS" -ge 500 ]; then STAR_SCORE=25
else STAR_SCORE=0; fi

# Org prominence — check against known company orgs
KNOWN_TOP_TIER="google googleapis GoogleCloudPlatform google-deepmind angular firebase grpc kubernetes chromium facebook facebookresearch meta-llama pytorch reactjs microsoft Azure dotnet TypeScript vscode aspnet aws awslabs amazon apple swiftlang WebKit vercel cloudflare anthropics openai"
KNOWN_MID_TIER="hashicorp Netflix uber uber-go stripe airbnb Shopify databricks huggingface grafana supabase elastic JetBrains redhat-developer salesforce adobe DataDog spotify square cashapp"

ORG_SCORE=0
if echo "$KNOWN_TOP_TIER" | grep -qw "$REPO_OWNER"; then
  ORG_SCORE=100
elif echo "$KNOWN_MID_TIER" | grep -qw "$REPO_OWNER"; then
  ORG_SCORE=75
elif [ "$STARS" -ge 10000 ]; then
  ORG_SCORE=50  # Well-known independent project
elif [ "$STARS" -ge 1000 ]; then
  ORG_SCORE=25
fi

# Velocity — simplified (use star count as proxy if API budget is limited)
# For a full velocity check, use the binary search method in the cookbook
if [ "$STARS" -ge 50000 ]; then VELOCITY_SCORE=50  # Likely steady growth at least
elif [ "$STARS" -ge 10000 ]; then VELOCITY_SCORE=25
else VELOCITY_SCORE=0; fi
# Override: if pushed in last 7 days AND stars > 5000, assume active growth
DAYS_SINCE_PUSH=$(( ($(date +%s) - $(date -d "$PUSHED_AT" +%s 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%SZ" "$PUSHED_AT" +%s 2>/dev/null || echo "$(date +%s)")) / 86400 ))
if [ "$DAYS_SINCE_PUSH" -le 7 ] && [ "$STARS" -ge 5000 ]; then
  VELOCITY_SCORE=$((VELOCITY_SCORE + 25))
  [ "$VELOCITY_SCORE" -gt 100 ] && VELOCITY_SCORE=100
fi

FACTOR1=$(( (STAR_SCORE * 40 + ORG_SCORE * 35 + VELOCITY_SCORE * 25) / 100 ))

# --- Score Factor 2: Contributability ---

if [ "$ARCHIVED" = "true" ]; then
  FACTOR2=0
else
  # Last commit recency
  if [ "$DAYS_SINCE_PUSH" -le 7 ]; then COMMIT_SCORE=100
  elif [ "$DAYS_SINCE_PUSH" -le 14 ]; then COMMIT_SCORE=75
  elif [ "$DAYS_SINCE_PUSH" -le 30 ]; then COMMIT_SCORE=50
  elif [ "$DAYS_SINCE_PUSH" -le 90 ]; then COMMIT_SCORE=25
  else COMMIT_SCORE=0; fi

  # GFI count
  if [ "$GFI_COUNT" -ge 10 ]; then GFI_SCORE=100
  elif [ "$GFI_COUNT" -ge 5 ]; then GFI_SCORE=75
  elif [ "$GFI_COUNT" -ge 3 ]; then GFI_SCORE=50
  elif [ "$GFI_COUNT" -ge 1 ]; then GFI_SCORE=25
  else GFI_SCORE=0; fi

  # Bus factor
  if [ "$BUS_FACTOR" -ge 5 ]; then BUS_SCORE=100
  elif [ "$BUS_FACTOR" -ge 4 ]; then BUS_SCORE=75
  elif [ "$BUS_FACTOR" -ge 3 ]; then BUS_SCORE=50
  elif [ "$BUS_FACTOR" -ge 2 ]; then BUS_SCORE=25
  else BUS_SCORE=0; fi

  # Release cadence
  if [ "$LAST_RELEASE" = "none" ]; then
    RELEASE_SCORE=25  # No releases isn't necessarily bad (some use rolling)
  else
    DAYS_SINCE_RELEASE=$(( ($(date +%s) - $(date -d "$LAST_RELEASE" +%s 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%SZ" "$LAST_RELEASE" +%s 2>/dev/null || echo "$(date +%s)")) / 86400 ))
    if [ "$DAYS_SINCE_RELEASE" -le 30 ]; then RELEASE_SCORE=100
    elif [ "$DAYS_SINCE_RELEASE" -le 60 ]; then RELEASE_SCORE=75
    elif [ "$DAYS_SINCE_RELEASE" -le 120 ]; then RELEASE_SCORE=50
    elif [ "$DAYS_SINCE_RELEASE" -le 365 ]; then RELEASE_SCORE=25
    else RELEASE_SCORE=0; fi
  fi

  # PR review turnaround and merge rate require GraphQL — approximate from other signals
  # High bus factor + recent commits + GFIs = likely responsive
  REVIEW_PROXY=$(( (COMMIT_SCORE + BUS_SCORE + GFI_SCORE) / 3 ))

  FACTOR2=$(( (COMMIT_SCORE * 20 + REVIEW_PROXY * 25 + REVIEW_PROXY * 20 + RELEASE_SCORE * 10 + BUS_SCORE * 10 + GFI_SCORE * 10 + 100 * 5) / 100 ))
fi

# --- Score Factor 3: Role/Ecosystem Relevance ---

# Domain alignment from topics and description
DOMAIN_KEYWORDS="ai agent llm machine-learning backend api server fullstack web-framework database orm"
ADJACENT_KEYWORDS="devops ci-cd cloud infrastructure data-pipeline monitoring ml-ops"
GENERAL_DEV="cli testing linting bundler package-manager developer-tools"

DOMAIN_SCORE=0
for kw in $DOMAIN_KEYWORDS; do
  if echo "$TOPICS,$DESCRIPTION" | grep -qi "$kw"; then
    DOMAIN_SCORE=100
    break
  fi
done
if [ "$DOMAIN_SCORE" -eq 0 ]; then
  for kw in $ADJACENT_KEYWORDS; do
    if echo "$TOPICS,$DESCRIPTION" | grep -qi "$kw"; then
      DOMAIN_SCORE=75
      break
    fi
  done
fi
if [ "$DOMAIN_SCORE" -eq 0 ]; then
  for kw in $GENERAL_DEV; do
    if echo "$TOPICS,$DESCRIPTION" | grep -qi "$kw"; then
      DOMAIN_SCORE=50
      break
    fi
  done
fi
# Fallback: if language is Python/TypeScript/Go/Rust and stars > 2K, at least 25
if [ "$DOMAIN_SCORE" -eq 0 ]; then
  if echo "Python TypeScript JavaScript Go Rust" | grep -qw "$LANGUAGE" && [ "$STARS" -ge 2000 ]; then
    DOMAIN_SCORE=25
  fi
fi

# Foundational infra — approximate from star count (proper check needs Libraries.io)
if [ "$STARS" -ge 50000 ]; then INFRA_SCORE=75  # Likely foundational at this size
elif [ "$STARS" -ge 10000 ]; then INFRA_SCORE=50
elif [ "$STARS" -ge 2000 ]; then INFRA_SCORE=25
else INFRA_SCORE=0; fi

FACTOR3=$(( (DOMAIN_SCORE * 60 + INFRA_SCORE * 40) / 100 ))

# --- Compute Total ---

TOTAL=$(( (FACTOR1 * 35 + FACTOR2 * 35 + FACTOR3 * 30) / 100 ))

# --- Output ---

cat <<EOF
{
  "repo": "$REPO",
  "total_score": $TOTAL,
  "factors": {
    "recognizability": $FACTOR1,
    "contributability": $FACTOR2,
    "role_relevance": $FACTOR3
  },
  "raw_metrics": {
    "stars": $STARS,
    "days_since_push": $DAYS_SINCE_PUSH,
    "archived": $ARCHIVED,
    "language": "$LANGUAGE",
    "topics": "$TOPICS",
    "gfi_count": $GFI_COUNT,
    "bus_factor": $BUS_FACTOR,
    "last_release": "$LAST_RELEASE",
    "owner": "$REPO_OWNER",
    "org_tier": "$([ $ORG_SCORE -ge 100 ] && echo 'top' || ([ $ORG_SCORE -ge 75 ] && echo 'mid' || echo 'indie'))"
  },
  "sub_scores": {
    "star_tier": $STAR_SCORE,
    "org_prominence": $ORG_SCORE,
    "velocity": $VELOCITY_SCORE,
    "commit_recency": ${COMMIT_SCORE:-0},
    "gfi_score": ${GFI_SCORE:-0},
    "bus_factor_score": ${BUS_SCORE:-0},
    "release_cadence": ${RELEASE_SCORE:-0},
    "domain_alignment": $DOMAIN_SCORE,
    "infra_score": $INFRA_SCORE
  }
}
EOF
