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
  cd ~/dev/project_b
}


cpb() {
  cd ~/dev/project_b_data
}

pbrestore() {
  sh ~/.postgres/postgres_project_b_dw_reset.sh
  sh ~/.postgres/postgres_project_b_reset.sh
}

