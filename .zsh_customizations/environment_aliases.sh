# clean up dotfile submodules
dotup() {
  cd ~/.dotify
  gsm
  gsp
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
