#!/bin/bash
# Usage: notify.sh "title" "message"
TITLE="${1:-Claude Code}"
MESSAGE="${2:-done}"
ICON="$HOME/.dotfiles/.claude/scripts/claude-icon.png"

ACTIVATE_ARGS=()
EXECUTE_ARGS=()
ICON_ARGS=()
[ -f "$ICON" ] && ICON_ARGS=(-appIcon "$ICON")

if [ -n "$TMUX" ] && [ -n "$TMUX_PANE" ]; then
  CONTEXT=$(tmux display-message -p -t "$TMUX_PANE" '#S · #I:#W')
  SESSION=$(tmux display-message -p -t "$TMUX_PANE" '#S')
  WINDOW_IDX=$(tmux display-message -p -t "$TMUX_PANE" '#I')

  FRONT_BUNDLE=$(osascript -e 'id of application (path to frontmost application as text)' 2>/dev/null)
  if [ "$FRONT_BUNDLE" = "org.alacritty" ]; then
    if /opt/homebrew/bin/tmux list-clients -t "$SESSION" -F '#{client_window}' 2>/dev/null \
        | grep -qx "$WINDOW_IDX"; then
      exit 0
    fi
  fi

  ACTIVATE_ARGS=(-activate org.alacritty)
  EXECUTE_ARGS=(-execute "/opt/homebrew/bin/tmux switch-client -t '${SESSION}:${WINDOW_IDX}' || /opt/homebrew/bin/tmux attach -t '${SESSION}'")
else
  CONTEXT="$(basename "$PWD")"
fi

# Try terminal-notifier first (rich: custom icon + click-to-switch-tmux).
# Under tmux it often can't reach NotificationCenter because the tmux server
# lives in the "Background" launchd domain, not "Aqua" — in that case fall
# back to osascript, which dispatches via AppleEvents and works from any
# session. Always exit 0 so the Stop hook never reports a failure.
if ! /opt/homebrew/bin/terminal-notifier \
  -title "$TITLE" \
  -subtitle "$CONTEXT" \
  -message "$MESSAGE" \
  -group "claude:$CONTEXT" \
  "${ICON_ARGS[@]}" \
  "${ACTIVATE_ARGS[@]}" \
  "${EXECUTE_ARGS[@]}" \
  >/dev/null 2>&1
then
  # Escape backslashes and double quotes for safe embedding in AppleScript.
  esc() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }
  osascript -e "display notification \"$(esc "$MESSAGE")\" with title \"$(esc "$TITLE")\" subtitle \"$(esc "$CONTEXT")\"" >/dev/null 2>&1
fi

exit 0
