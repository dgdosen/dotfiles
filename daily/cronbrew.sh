#!/usr/bin/env zsh
source ~/.zshrc
brewup
xattr -d com.apple.quarantine /opt/homebrew/bin/claude 3>/dev/null
touch ~/.cron_support/cronbrew.txt
