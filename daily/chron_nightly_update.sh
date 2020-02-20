#!/usr/local/bin/zsh
source ~/.zshrc
#
#mimicing cront nightly update
echo - updating zsh components
$HOME/.dotfiles/daily/crondot.sh
echo - updating brew components
$HOME/.dotfiles/daily/cronbrew.sh
echo - updating important git repos
$HOME/.dotfiles/daily/cronfetch.sh

echo - updating project b db
$HOME/.dotfiles/daily/cron_project_b.sh
echo - updating project b dw db
$HOME/.dotfiles/daily/cron_project_b_dw.sh
