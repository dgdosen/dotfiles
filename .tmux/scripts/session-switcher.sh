#!/bin/bash
# Session switcher: select existing or create new by typing a name

session=$(tmux list-sessions -F '#{session_name}' | fzf --prompt='session > ' --print-query --bind 'esc:abort' | tail -1)

if [ -n "$session" ]; then
  if tmux has-session -t "$session" 2>/dev/null; then
    tmux switch-client -t "$session"
  else
    tmux new-session -d -s "$session" && tmux switch-client -t "$session"
  fi
fi
