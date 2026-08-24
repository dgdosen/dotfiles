#!/usr/bin/env zsh
source ~/.zshrc
#
#mimicing cront nightly update
echo - updating brew components
$HOME/.dotfiles/daily/cronbrew.sh
echo - updating important git repos
$HOME/.dotfiles/daily/cronfetch.sh

# interesting that this stops outuput to the screen
# doing this last... seems to muck with running
echo - updating zsh components
$HOME/.dotfiles/daily/crondot.sh
