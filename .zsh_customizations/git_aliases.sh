gsm() {
  # git submodule checkout master
  git submodule foreach git checkout master
}

gsp() {
  # git submodule pull
  git submodule foreach git pull origin master
}
