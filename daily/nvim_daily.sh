#!/usr/local/bin/zsh
source ~/.zshrc
# Execute the first command
nvim --headless '+Lazy! sync' +qa
# Execute the second command
nvim --headless '+MasonUpdate' +qa
