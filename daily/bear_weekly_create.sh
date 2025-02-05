#!/usr/bin/env zsh
source ~/.zshrc

# Since .zshrc isn’t sourced, we need to manually initialize pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Only load virtualenv if available
if command -v pyenv-virtualenv-init >/dev/null 2>&1; then
  eval "$(pyenv virtualenv-init -)"
fi

# Debugging: Print environment variables
echo "Using Python: $(which python)"
echo "Python Version: $(python --version)"

zsh -i -c 'bear_weekly_create'
touch ~/.cron_support/bear_weekly_create.txt
