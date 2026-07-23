#!/bin/bash
# Window renamer: shown in a display-popup so the prompt doesn't get
# drawn over the status-line tabs (tmux >= 3.4 no longer clears the
# status line for command prompts).
# Reads key-by-key so Escape cancels; Enter accepts; empty input keeps
# the current name.

current=$(tmux display-message -p '#W')
printf 'rename window [%s] > ' "$current"

name=""
while IFS= read -rsn1 key; do
  case "$key" in
    $'\e') exit 0 ;;                 # Escape (or any escape sequence) cancels
    "") break ;;                     # Enter accepts
    $'\x7f'|$'\b')                   # Backspace
      if [ -n "$name" ]; then
        name="${name%?}"
        printf '\b \b'
      fi ;;
    *) name+="$key"; printf '%s' "$key" ;;
  esac
done

[ -n "$name" ] && tmux rename-window "$name"
