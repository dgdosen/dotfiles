#!/bin/bash
if [ -n "$TMUX" ]; then
    /opt/homebrew/bin/tmux previous-window
else
    echo "Not in tmux session"
fi
