#!/bin/bash
# commit-msg-hook.sh — Git commit-msg hook that strips AI co-authorship trailers
# Installed by setup-repo.sh as .git/hooks/commit-msg
#
# This is the enforcement layer for Rule 1 (no AI co-authorship on commits).
# It physically removes Co-authored-by lines that reference Claude, AI assistants,
# or any known AI tool patterns from commit messages before they're saved.
#
# WHY THIS EXISTS: Claude Code's settings.json attribution controls don't always
# work reliably. This hook guarantees that even if settings fail, no AI
# co-authorship trailer makes it into the commit history.

COMMIT_MSG_FILE="$1"

if [ ! -f "$COMMIT_MSG_FILE" ]; then
  exit 0
fi

# Patterns to strip (case-insensitive):
# - Co-authored-by: *claude*
# - Co-authored-by: *anthropic*
# - Co-authored-by: *[bot]*
# - Co-authored-by: *AI*assistant*
# - Generated-by: * (we handle this separately via Assisted-by if needed)
# - Any "Co-authored-by" with common AI tool names

TEMP=$(mktemp)

grep -v -i \
  -e "Co-authored-by:.*[Cc]laude" \
  -e "Co-authored-by:.*[Aa]nthropic" \
  -e "Co-authored-by:.*\[bot\]" \
  -e "Co-authored-by:.*AI.*[Aa]ssistant" \
  -e "Co-authored-by:.*[Cc]opilot" \
  -e "Co-authored-by:.*[Cc]ursor" \
  -e "Co-authored-by:.*[Oo]penAI" \
  -e "Co-authored-by:.*[Gg]ithub.*[Cc]opilot" \
  "$COMMIT_MSG_FILE" > "$TEMP" 2>/dev/null || true

# Remove trailing blank lines that might be left after stripping
sed -i.bak -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$TEMP" 2>/dev/null || true
rm -f "$TEMP.bak"

mv "$TEMP" "$COMMIT_MSG_FILE"
