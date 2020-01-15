# clean up dotfile submodules
dotup() {
  FOO=$PWD
  cd ~/.dotify
  echo in dotfiles
  gsm
  gsp
  nvim +'PlugInstall --sync' +qa
  nvim +'PlugUpdate --sync' +qa
  nvim +'UpdateRemotePlugins' +qa
  cd $FOO
}

cdot() {
  cd ~/.dotify
}

touchfoo() {
  touch ~/foozsh.txt
}


# homebrew upgrade
brewup() {
  brew update
  brew upgrade
  brew cleanup
}
