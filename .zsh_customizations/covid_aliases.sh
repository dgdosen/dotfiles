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

covid-data-refresh() {

  FOO=$PWD

  cd $HOME/dev/covid-tracking-visualized/public
  # rename if you get thumbnails and data?
  node ~/dev/covid-tracking-thumbnail-cli/index.js getData

  cd $HOME/dev/covid-tracking-visualized
  git pull
  git add public/screenshot.png
  git commit -m 'automated update of covid screenshot'
  git push

  cd $FOO

}

covid-post() {

  keybase chat send los_gatos "(From Dan's Bot:) Daily update to WA Covid-19 data from covidtracking.com as shown on https://covid.agidevelopment.com. Feel free to suggest improvments..."

}

covid-postx() {

  keybase chat send danielgdosen "(From Dan's Bot:) Greetings from the ether.... Hey boomer, check out the daily updates to WA Covid data at https://covid.agidevelopment.com.  Feel free to suggest improvments!"

}
