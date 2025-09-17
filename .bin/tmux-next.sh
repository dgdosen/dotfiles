#!/bin/bash
if [ -n "$TMUX" ]; then
    /opt/homebrew/bin/tmux next-window
else
    echo "Not in tmux session"
fi
