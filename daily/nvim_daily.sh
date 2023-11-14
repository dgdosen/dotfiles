#!/usr/local/bin/zsh
source ~/.zshrc
nvim --headless '+Lazy! sync' +qa
nvim --headless '+MasonUpdate' +qa
nvim --headless '+MasonUpdateAll' +qa
