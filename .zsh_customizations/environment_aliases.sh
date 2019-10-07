# clean up dotfile submodules
cdot() {
  cd ~/.dotify
  gsm
  gsp
}


# homebrew upgrade
brewup() {
  brew update
  brew upgrade
  brew cleanup
}
