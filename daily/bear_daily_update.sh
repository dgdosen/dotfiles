#!/usr/bin/env zsh
source ~/.zshrc
date

# Check if the script has already run today
LOG_FILE=~/.cron_support/bear_daily_update.txt
TODAY=$(date +%Y-%m-%d)

if [[ -f "$LOG_FILE" ]]; then
  LAST_RUN=$(date -r "$LOG_FILE" +%Y-%m-%d 2>/dev/null)
  if [[ "$LAST_RUN" == "$TODAY" ]]; then
    echo "bear_daily_update already ran today ($TODAY), skipping..."
    exit 0
  fi
fi

echo "running bear_daily_update"

# Since .zshrc isn't sourced, we need to manually initialize pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Only load virtualenv if available
if command -v pyenv-virtualenv-init >/dev/null 2>&1; then
  eval "$(pyenv virtualenv-init -)"
fi

# Debugging: Print environment variables
echo "Using Python: $(which python)"
echo "Python Version: $(python --version)"

# Run the actual script in an interactive shell
/bin/zsh -i -c 'bear_daily_update'
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
  date
  echo "bear_daily_update completed successfully"
  touch ~/.cron_support/bear_daily_update.txt
else
  date
  echo "bear_daily_update failed with exit code $EXIT_CODE"
  exit 1
fi
