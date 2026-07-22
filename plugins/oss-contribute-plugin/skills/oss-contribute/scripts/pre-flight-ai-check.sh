#!/bin/bash
# pre-flight-ai-check.sh — Detect AI contribution policies before starting work
# Usage: ./pre-flight-ai-check.sh OWNER/REPO
#
# Checks: CONTRIBUTING.md, dedicated AI policy files, known-ban orgs,
# DCO requirements, issue/discussion mentions, PR templates, commit patterns.
# Outputs a verdict: CLEAR, DISCLOSE, CAUTION, or STOP.

set -euo pipefail

REPO="${1:?Usage: pre-flight-ai-check.sh OWNER/REPO}"
OWNER=$(echo "$REPO" | cut -d'/' -f1)
NAME=$(echo "$REPO" | cut -d'/' -f2)
DEFAULT_BRANCH=$(gh api "repos/$REPO" --jq '.default_branch' 2>/dev/null || echo "main")

VERDICT="CLEAR"
FINDINGS=()

echo "=== AI Policy Pre-Flight Check: $REPO ==="
echo ""

# --- Check 1: CONTRIBUTING.md ---
echo "--- Checking CONTRIBUTING.md ---"
CONTRIBUTING=$(curl -sf "https://raw.githubusercontent.com/$REPO/$DEFAULT_BRANCH/CONTRIBUTING.md" || \
               curl -sf "https://raw.githubusercontent.com/$REPO/$DEFAULT_BRANCH/.github/CONTRIBUTING.md" || \
               curl -sf "https://raw.githubusercontent.com/$REPO/$DEFAULT_BRANCH/docs/CONTRIBUTING.md" || echo "")

if [ -n "$CONTRIBUTING" ]; then
  AI_MENTIONS=$(echo "$CONTRIBUTING" | grep -i -c "ai\|artificial intelligence\|llm\|chatgpt\|copilot\|generated\|machine learning\|assisted-by\|claude\|gpt" || true)
  if [ "$AI_MENTIONS" -gt 0 ]; then
    echo "WARNING: CONTRIBUTING.md mentions AI/LLM ($AI_MENTIONS references)"
    MATCHES=$(echo "$CONTRIBUTING" | grep -i "ai\|artificial intelligence\|llm\|chatgpt\|copilot\|generated\|assisted-by\|claude\|gpt" | head -5)
    echo "$MATCHES"
    # Check for ban language
    if echo "$CONTRIBUTING" | grep -qi "forbidden.*ai\|prohibited.*ai\|ban.*ai\|not accept.*ai.*generat\|must not.*ai"; then
      VERDICT="STOP"
      FINDINGS+=("CONTRIBUTING.md contains ban language for AI contributions")
    elif echo "$CONTRIBUTING" | grep -qi "must.*disclos.*ai\|required.*assisted-by\|indicate.*tool.*used"; then
      VERDICT="DISCLOSE"
      FINDINGS+=("CONTRIBUTING.md requires AI disclosure")
    else
      [ "$VERDICT" = "CLEAR" ] && VERDICT="CAUTION"
      FINDINGS+=("CONTRIBUTING.md mentions AI — review the specific language")
    fi
  else
    echo "OK: CONTRIBUTING.md exists, no AI policy found"
  fi
else
  echo "INFO: No CONTRIBUTING.md found"
fi
echo ""

# --- Check 2: Dedicated AI policy files ---
echo "--- Checking for dedicated AI policy files ---"
for path in "AI_POLICY.md" ".github/AI_POLICY.md" "docs/ai-policy.md" "Documentation/process/coding-assistants.rst"; do
  CONTENT=$(curl -sf "https://raw.githubusercontent.com/$REPO/$DEFAULT_BRANCH/$path" || echo "")
  if [ -n "$CONTENT" ]; then
    echo "FOUND: Dedicated AI policy at $path"
    echo "$CONTENT" | head -10
    [ "$VERDICT" = "CLEAR" ] && VERDICT="DISCLOSE"
    FINDINGS+=("Dedicated AI policy file found: $path")
  fi
done
echo ""

# --- Check 3: Known-ban orgs ---
echo "--- Checking known policy orgs ---"
KNOWN_BANS="gentoo"
KNOWN_DISCLOSURE="torvalds apache"
KNOWN_HOSTILE="curl bagder"

for org in $KNOWN_BANS; do
  if [ "$OWNER" = "$org" ]; then
    VERDICT="STOP"
    FINDINGS+=("Repo is in KNOWN-BAN org: $OWNER (Gentoo bans all AI contributions)")
    echo "BLOCKED: Repo is in known-ban org: $OWNER"
  fi
done

for org in $KNOWN_DISCLOSURE; do
  if [ "$OWNER" = "$org" ]; then
    [ "$VERDICT" = "CLEAR" ] && VERDICT="DISCLOSE"
    FINDINGS+=("Repo is in disclosure-required org: $OWNER (requires Assisted-by: tag)")
    echo "DISCLOSURE REQUIRED: Org $OWNER requires Assisted-by: tag"
  fi
done

for org in $KNOWN_HOSTILE; do
  if [ "$OWNER" = "$org" ]; then
    VERDICT="STOP"
    FINDINGS+=("Repo is maintained by $OWNER — de facto ban on AI contributions (Daniel Stenberg / curl)")
    echo "HOSTILE: Repo owner $OWNER has de facto ban on AI contributions"
  fi
done
echo ""

# --- Check 4: DCO requirement ---
echo "--- Checking DCO/sign-off requirements ---"
DCO_FILE=$(curl -sf "https://raw.githubusercontent.com/$REPO/$DEFAULT_BRANCH/.github/dco.yml" || echo "")
RECENT_SIGNOFFS=$(gh api "repos/$REPO/commits" -f per_page=5 --jq '[.[].commit.message | select(test("Signed-off-by"))] | length' 2>/dev/null || echo "0")
if [ -n "$DCO_FILE" ] || [ "$RECENT_SIGNOFFS" -gt 3 ]; then
  echo "INFO: DCO (Developer Certificate of Origin) required"
  echo "  Use: git commit -s (adds Signed-off-by automatically)"
  echo "  Note: YOU are certifying authorship by signing."
  FINDINGS+=("DCO required — use git commit -s")
fi
echo ""

# --- Check 5: Search issues for AI policy ---
echo "--- Searching issues for AI policy mentions ---"
AI_ISSUES=$(gh api search/issues \
  -f q="repo:$REPO \"AI policy\" OR \"AI contribution\" OR \"LLM\" OR \"copilot ban\" in:title" \
  --jq '.total_count' 2>/dev/null || echo "0")
if [ "$AI_ISSUES" -gt 0 ]; then
  echo "FOUND: $AI_ISSUES issues/PRs mentioning AI policy"
  gh api search/issues \
    -f q="repo:$REPO \"AI policy\" OR \"AI contribution\" in:title" \
    -f per_page=3 \
    --jq '.items[] | "  - \(.title) (\(.html_url))"' 2>/dev/null || true
  [ "$VERDICT" = "CLEAR" ] && VERDICT="CAUTION"
  FINDINGS+=("Found $AI_ISSUES issues discussing AI policy — read them before proceeding")
fi
echo ""

# --- Check 6: PR template ---
echo "--- Checking PR template ---"
PR_TEMPLATE=$(curl -sf "https://raw.githubusercontent.com/$REPO/$DEFAULT_BRANCH/.github/PULL_REQUEST_TEMPLATE.md" || \
              curl -sf "https://raw.githubusercontent.com/$REPO/$DEFAULT_BRANCH/.github/pull_request_template.md" || \
              curl -sf "https://raw.githubusercontent.com/$REPO/$DEFAULT_BRANCH/PULL_REQUEST_TEMPLATE.md" || echo "")

if [ -n "$PR_TEMPLATE" ]; then
  AI_IN_PR=$(echo "$PR_TEMPLATE" | grep -i -c "ai\|generated\|assisted\|copilot\|llm" || true)
  if [ "$AI_IN_PR" -gt 0 ]; then
    echo "WARNING: PR template mentions AI/generated content"
    echo "$PR_TEMPLATE" | grep -i "ai\|generated\|assisted\|copilot\|llm"
    [ "$VERDICT" = "CLEAR" ] && VERDICT="DISCLOSE"
    FINDINGS+=("PR template has AI-related fields — fill them honestly")
  else
    echo "OK: PR template exists, no AI disclosure field"
  fi
else
  echo "INFO: No PR template found"
fi
echo ""

# --- Check 7: Recent Assisted-by tags ---
echo "--- Checking recent commits for Assisted-by tags ---"
ASSISTED=$(gh api "repos/$REPO/commits" -f per_page=50 \
  --jq '[.[] | select(.commit.message | test("Assisted-by|Generated-by"; "i"))] | length' 2>/dev/null || echo "0")
if [ "$ASSISTED" -gt 0 ]; then
  echo "INFO: Found $ASSISTED recent commits with Assisted-by/Generated-by tags"
  echo "  This project accepts AI-assisted contributions with disclosure."
  FINDINGS+=("Existing Assisted-by tags found — project accepts disclosed AI contributions")
fi
echo ""

# --- Output verdict ---
echo "==============================="
echo "VERDICT: $VERDICT"
echo "==============================="
echo ""

case $VERDICT in
  CLEAR)
    echo "No AI policy detected. Proceed with standard quality practices."
    echo "If asked, disclose AI assistance. Focus on passing the 'can you discuss this technically?' test."
    ;;
  DISCLOSE)
    echo "Disclosure required or recommended. Add Assisted-by: tag to commits."
    echo "Format: Assisted-by: Claude:claude-opus-4 [tools used]"
    ;;
  CAUTION)
    echo "Ambiguous signals found. Read the findings below carefully."
    echo "Recommendation: disclose proactively and be prepared to explain your code."
    ;;
  STOP)
    echo "THIS PROJECT BANS OR STRONGLY OPPOSES AI-ASSISTED CONTRIBUTIONS."
    echo "If you proceed, contribute MANUALLY without AI assistance, or choose another project."
    ;;
esac

echo ""
if [ ${#FINDINGS[@]} -gt 0 ]; then
  echo "Findings:"
  for f in "${FINDINGS[@]}"; do
    echo "  - $f"
  done
fi

# Output machine-readable result
echo ""
echo "---JSON---"
echo "{\"verdict\": \"$VERDICT\", \"repo\": \"$REPO\", \"findings_count\": ${#FINDINGS[@]}}"
