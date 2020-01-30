# clean up dotfile submodules
dotup() {

  FOO=$PWD
  cd ~/.dotfiles
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
  mkdir ~/.cron_support
  touch ~/.cron_support/foobar.txt
}


# homebrew upgrade
brewup() {
  brew update
  brew upgrade
  brew cleanup
}
