#!/usr/local/bin/zsh
source ~/.zshrc
cd $HOME/.dotfiles
echo - in dotfiles
gsm
echo - updated modules
gsp
echo - pulled modules
nvim +'PlugInstall --sync' +qa
echo - installed vim plugs
nvim +'PlugUpdate --sync' +qa
echo - updated vim plugs
# nvim +'UpdateRemotePlugins' +qa
touch ~/.cron_support/crondot.txt
echo - touched dot
