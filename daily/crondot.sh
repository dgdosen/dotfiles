#!/usr/bin/env zsh
source ~/.zshrc
cd $HOME/.dotfiles
echo - in dotfiles
gsm
echo - updated modules
gsp
echo - pulled modules
nvim_up
# echo - updated vim plugs
touch ~/.cron_support/crondot.txt
echo - touched dot
