#!/usr/bin/env zsh
# claude_notify: Ping the user when claude code finishes or needs input
#
# Usage:
#   claude_notify done "Finished refactoring auth module"
#   claude_notify input "Which database adapter should I use?"

set -uo pipefail

typeset STATUS="${1:-done}"
typeset MESSAGE="${2:-Claude needs your attention}"

typeset ICON LABEL
case "$STATUS" in
  done)  ICON="✅"; LABEL="Done" ;;
  input) ICON="❓"; LABEL="Input Needed" ;;
  *)     ICON="🔔"; LABEL="Notice" ;;
esac

print '\a'

if [[ -n "${TMUX:-}" ]]; then
  tmux display-message "${ICON} ${LABEL}: ${MESSAGE}" 2>/dev/null || true
fi

if (( $+commands[osascript] )); then
  osascript -e "display notification \"${MESSAGE}\" with title \"Claude: ${LABEL}\"" 2>/dev/null || true
elif (( $+commands[notify-send] )); then
  notify-send --urgency=normal --expire-time=10000 "Claude: ${LABEL}" "$MESSAGE" 2>/dev/null || true
fi

print "${ICON} ${LABEL}: ${MESSAGE}"
