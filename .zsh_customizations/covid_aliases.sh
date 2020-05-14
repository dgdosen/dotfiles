covid-update() {

  FOO=$PWD

  cd $HOME/dev/covid-tracking-visualized/public
  node ~/dev/covid-tracking-thumbnail-cli/index.js getScreen foobar

  cd $HOME/dev/covid-tracking-visualized
  git pull
  git add public/screenshot.png
  git commit -m 'automated update of covid screenshot'
  git push

  cd $FOO

}
