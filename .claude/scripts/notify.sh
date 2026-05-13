#!/bin/bash
# Usage: notify.sh "title" "message"
TITLE="${1:-Claude Code}"
MESSAGE="${2:-done}"

ACTIVATE_ARGS=()
EXECUTE_ARGS=()

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

/opt/homebrew/bin/terminal-notifier \
  -title "$TITLE" \
  -subtitle "$CONTEXT" \
  -message "$MESSAGE" \
  -group "claude:$CONTEXT" \
  "${ACTIVATE_ARGS[@]}" \
  "${EXECUTE_ARGS[@]}" \
  >/dev/null
