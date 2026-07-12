#!/usr/bin/env bash
# Publish a created skill to this GitHub marketplace.
#
#   ./publish-skill.sh <path-to-skill-dir>
#
# If the skill has more than just SKILL.md, it is packaged as a plugin, added to
# .claude-plugin/marketplace.json, committed, and pushed. Single-file skills are
# skipped (use Customize > Skills for those).
set -euo pipefail

SKILL_SRC="${1:-}"
if [ -z "$SKILL_SRC" ]; then
  echo "usage: ./publish-skill.sh <path-to-skill-dir>" >&2
  exit 2
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PLUGIN="$(python3 "$REPO_ROOT/tools/package_skill.py" "$SKILL_SRC" "$REPO_ROOT")"
if [ -z "$PLUGIN" ]; then
  exit 0  # SKILL.md-only or nothing to do; package_skill.py already explained why
fi

cd "$REPO_ROOT"
git add -A
if git diff --cached --quiet; then
  echo "Nothing changed for $PLUGIN (already up to date)."
  exit 0
fi
# Use existing git identity if set, else a fallback (Cowork's VM has none configured).
CE="$(git config user.email 2>/dev/null || true)"
CN="$(git config user.name 2>/dev/null || true)"
git -c user.email="${CE:-skill-publisher@users.noreply.github.com}" \
    -c user.name="${CN:-skill-publisher}" \
    commit -m "Add/update plugin: $PLUGIN" >/dev/null

# Push. On the host (Claude Code) gh's credential helper handles auth. Inside
# Cowork's sandbox VM, supply a GitHub token via GITHUB_TOKEN/GH_TOKEN env or a
# gitignored .github-token file in this repo (the token is never committed).
TOKEN="${GITHUB_TOKEN:-${GH_TOKEN:-}}"
if [ -z "$TOKEN" ] && [ -f "$REPO_ROOT/.github-token" ]; then
  TOKEN="$(tr -d '[:space:]' < "$REPO_ROOT/.github-token")"
fi
if [ -n "$TOKEN" ]; then
  SLUG="$(git remote get-url origin | sed -E 's#.*github\.com[:/]##; s#\.git$##')"
  git push "https://x-access-token:${TOKEN}@github.com/${SLUG}.git" HEAD:main
else
  git push
fi
MARKET="$(python3 -c "import json;print(json.load(open('$REPO_ROOT/.claude-plugin/marketplace.json'))['name'])")"
echo "✅ Pushed '$PLUGIN'."
echo "   In Cowork/Desktop:  /plugin marketplace update $MARKET   then   /plugin install $PLUGIN@$MARKET"
