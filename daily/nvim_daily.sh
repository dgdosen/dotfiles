#!/usr/bin/env zsh
source ~/.zshrc

# Run Lazy sync
nvim --headless '+Lazy! sync' +qa

# Update Mason packages, blocking until the async installs actually finish
# (plain '+MasonUpdate +qa' quit before they completed; '+MasonUpdateAll' was
# not a real command). mason_update.lua handles the refresh + reinstall + wait.
nvim --headless -c "luafile $HOME/.config/nvim/mason_update.lua" -c qa
