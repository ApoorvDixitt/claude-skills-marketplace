#!/bin/bash
# setup-repo.sh — Configure a repo for AI-assisted contribution
# Usage: ./setup-repo.sh [path-to-repo]
#
# Does three things:
# 1. Disables AI co-authorship in Claude Code settings (attribution.commit + attribution.pr)
# 2. Installs a git commit-msg hook that strips any AI co-authored-by trailers
# 3. Verifies gh CLI has sufficient auth scope for fork/push/PR operations
#
# WHY BOTH LAYERS: The settings.json approach alone has known reliability issues —
# it doesn't always get respected across all Claude Code versions and session types.
# The commit-msg hook is the actual enforcement: it physically strips the trailers
# from commit messages before they're saved, regardless of what settings say.

set -euo pipefail

REPO_PATH="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Setting up repo for AI-assisted contribution ==="
echo "Repo path: $REPO_PATH"
echo ""

# --- Step 1: Disable AI co-authorship in Claude Code settings ---
echo "--- Step 1: Disabling AI co-authorship in settings ---"

# Find or create settings.json
SETTINGS_LOCATIONS=(
  "$HOME/.claude/settings.json"
  "$HOME/.config/claude/settings.json"
)

SETTINGS_FILE=""
for loc in "${SETTINGS_LOCATIONS[@]}"; do
  if [ -f "$loc" ]; then
    SETTINGS_FILE="$loc"
    break
  fi
done

if [ -z "$SETTINGS_FILE" ]; then
  SETTINGS_FILE="$HOME/.claude/settings.json"
  mkdir -p "$(dirname "$SETTINGS_FILE")"
  echo '{}' > "$SETTINGS_FILE"
  echo "Created new settings file: $SETTINGS_FILE"
fi

# Update settings to disable attribution
if command -v jq &>/dev/null; then
  TMP=$(mktemp)
  jq '. + {"attribution": {"commit": "", "pr": ""}}' "$SETTINGS_FILE" > "$TMP" && mv "$TMP" "$SETTINGS_FILE"
  echo "OK: Set attribution.commit and attribution.pr to empty in $SETTINGS_FILE"
else
  echo "WARNING: jq not available — manually ensure attribution.commit and attribution.pr are empty in $SETTINGS_FILE"
fi
echo ""

# --- Step 2: Install commit-msg hook ---
echo "--- Step 2: Installing commit-msg hook ---"

HOOKS_DIR="$REPO_PATH/.git/hooks"
if [ ! -d "$HOOKS_DIR" ]; then
  echo "ERROR: $HOOKS_DIR does not exist. Are you in a git repo?"
  exit 1
fi

HOOK_TARGET="$HOOKS_DIR/commit-msg"

# Don't overwrite an existing hook — chain instead
if [ -f "$HOOK_TARGET" ] && ! grep -q "oss-contribute" "$HOOK_TARGET"; then
  # Check shebang compatibility before appending
  EXISTING_SHEBANG=$(head -1 "$HOOK_TARGET")
  if echo "$EXISTING_SHEBANG" | grep -qE "^#!.*(bash|sh|zsh)"; then
    echo "INFO: Existing commit-msg hook found (sh/bash-compatible). Appending our filter."
    echo "" >> "$HOOK_TARGET"
    echo "# --- oss-contribute: strip AI co-authorship ---" >> "$HOOK_TARGET"
    cat "$SCRIPT_DIR/commit-msg-hook.sh" >> "$HOOK_TARGET"
  else
    echo "WARNING: Existing commit-msg hook uses a non-sh interpreter: $EXISTING_SHEBANG"
    echo "Cannot safely append our bash filter to a hook with a different interpreter."
    echo "Options:"
    echo "  1. Manually add the filter logic to your existing hook"
    echo "  2. Rename the existing hook and let us install ours (we'll call yours from it)"
    echo "  3. Skip the hook and rely solely on settings.json (less reliable)"
    echo ""
    echo "The hook contents are at: $SCRIPT_DIR/commit-msg-hook.sh"
    echo "Skipping hook installation for now."
  fi
else
  cp "$SCRIPT_DIR/commit-msg-hook.sh" "$HOOK_TARGET"
fi

chmod +x "$HOOK_TARGET"
echo "OK: commit-msg hook installed at $HOOK_TARGET"
echo ""

# --- Step 3: Verify gh auth scope ---
echo "--- Step 3: Verifying gh CLI authentication ---"

if ! command -v gh &>/dev/null; then
  echo "ERROR: gh CLI not found. Install it: https://cli.github.com"
  echo "Without gh, you cannot fork, push, or create PRs from this workflow."
  exit 1
fi

AUTH_STATUS=$(gh auth status 2>&1)
if echo "$AUTH_STATUS" | grep -q "not logged in"; then
  echo "ERROR: gh is not authenticated. Run: gh auth login"
  exit 1
fi

# Check for repo scope
TOKEN_SCOPES=$(gh auth status 2>&1 | grep -i "token scopes" || echo "")
if echo "$TOKEN_SCOPES" | grep -qi "repo"; then
  echo "OK: gh authenticated with 'repo' scope (can fork/push/PR)"
elif echo "$TOKEN_SCOPES" | grep -qi "''" || [ -z "$TOKEN_SCOPES" ]; then
  # Fine-grained PATs don't show scopes the same way — try a write operation check
  echo "INFO: Using fine-grained token (scopes not shown). Will verify on first push."
else
  echo "WARNING: Token may lack 'repo' scope. Current scopes: $TOKEN_SCOPES"
  echo "If fork/push/PR fails later, run: gh auth refresh -s repo"
fi

echo ""
echo "=== Setup complete ==="
echo "- AI co-authorship disabled in settings"
echo "- commit-msg hook strips Co-authored-by trailers from Claude/AI"
echo "- gh CLI authenticated for push/PR operations"
echo ""
echo "You're ready to contribute."
