fetchthegits() {

  FOO=$PWD

  cd ~/.dotfiles
  git fetch
  cd ~/dev/project_b_api
  git fetch
  cd ~/dev/project_b_data_2023
  git fetch
  cd ~/dev/project_b_data
  git fetch
  cd ~/dev/project_b_start_query
  git fetch
  cd ~/dev/project_b_query
  git fetch
  cd ~/dev/project_b_racing_form
  git fetch
  cd ~/dev/project_b_equibase_scrape_cli
  git fetch
  cd ~/dev/project_b_gmax_scrape_cli
  git fetch
  cd ~/dev/project_b_drf_scrape_cli
  git fetch
  cd ~/dev/project_b_drf_debut_scrape_cli
  git fetch
  cd ~/dev/project_b_debut
  git fetch
  cd ~/dev/project_b_hooks
  git fetch
  cd ~/dev/project_b_pars
  git fetch
  cd ~/dev/project_b_generic_matching
  git fetch
  cd ~/dev/project_b_matching
  git fetch
  cd ~/dev/sessuru_server
  git fetch
  cd ~/dev/sessuru_client
  git fetch

  cd $FOO

}

