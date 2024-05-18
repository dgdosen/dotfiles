pbd () {

  find ~/Downloads/project_b/data -type f -exec chmod -x {} \;
  # for D in *
  # do
  #   # Do whatever you need with D
  #   echo "hello ${D}"
  #   chmod -x D {} \;
  # done

}

cpb() {
  cd ~/dev/project_b_api
}


cpb() {
  cd ~/dev/project_b_data
}

pbrestore() {
  ~/.dotfiles/daily/cron_project_b_dw.sh
  ~/.dotfiles/daily/cron_project_b.sh
  # sh ~/.dotfiles/.postgres/postgres_project_b_dw_reset.sh
  # sh ~/.dotfiles/.postgres/postgres_project_b_reset.sh
}

pb_new_data() {
  sh ~/.dotfiles/.postgres/sp_data.sh
}

pbs() {
  spring rails s -b 0.0.0.0
}
