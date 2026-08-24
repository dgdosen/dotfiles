# Initial clone of the daily-fetched repositories.
#
# This is first-run bootstrap only. Ongoing freshness for the makerboarding
# project_b repos is ~/.project_b/jobs/project_b_repo_sync.sh
# (com.makerboarding.project_b_repo_sync, nightly at 02:30), which clones any
# that are missing and fast-forwards the rest. Its repo table is derived from
# the makerboarding lines below PLUS every repo a com.makerboarding.* launch
# agent reads or writes — so adding a clone here means adding it there too.

[ ! -d "$HOME/dev" ] && mkdir "$HOME/dev"
git clone git@github.com:dgdosen/dotfiles.git $HOME/.dotfiles

# Alacritty (not available via Homebrew cask - deprecated due to Gatekeeper)
git clone https://github.com/alacritty/alacritty.git $HOME/dev/alacritty

git clone git@github.com:makerboarding/project_b_ai_handicapping.git $HOME/dev/project_b_ai_handicapping
git clone git@github.com:makerboarding/project_b.git $HOME/dev/project_b_api
git clone git@github.com:makerboarding/project_b_audit.git $HOME/dev/project_b_audit
git clone git@github.com:makerboarding/project_b_brisnet_scrape_cli.git $HOME/dev/project_b_brisnet_scrape_cli
git clone git@github.com:makerboarding/project_b_data.git $HOME/dev/project_b_data
git clone git@github.com:makerboarding/project_b_data_2023.git $HOME/dev/project_b_data_2023
git clone git@github.com:makerboarding/project_b_debut.git $HOME/dev/project_b_debut
git clone git@github.com:makerboarding/project_b_drf_debut_scrape_cli.git $HOME/dev/project_b_drf_debut_scrape_cli
git clone git@github.com:makerboarding/project_b_drf_scrape_cli.git $HOME/dev/project_b_drf_scrape_cli
git clone git@github.com:makerboarding/project_b_entity_mapping.git $HOME/dev/project_b_entity_mapping
# git clone git@github.com:makerboarding/project_b_equibase_api.git $HOME/dev/project_b_equibase_api
git clone git@github.com:makerboarding/project_b_equibase_data.git $HOME/dev/project_b_equibase_data
git clone git@github.com:makerboarding/project_b_equibase_program_scrape_cli.git $HOME/dev/project_b_equibase_program_scrape_cli
git clone git@github.com:makerboarding/project_b_equibase_results_scrape_cli.git $HOME/dev/project_b_equibase_results_scrape_cli
git clone git@github.com:makerboarding/project_b_equibase_scrape_cli.git $HOME/dev/project_b_equibase_scrape_cli
# git clone git@github.com:makerboarding/project_b_generic_matching.git $HOME/dev/project_b_generic_matching
git clone git@github.com:makerboarding/project_b_gmax_scrape_cli.git $HOME/dev/project_b_gmax_scrape_cli
git clone git@github.com:makerboarding/project_b_hooks.git $HOME/dev/project_b_hooks
# git clone git@github.com:makerboarding/project_b_matching.git $HOME/dev/project_b_matching
git clone git@github.com:makerboarding/project_b_pars.git $HOME/dev/project_b_pars
git clone git@github.com:makerboarding/project_b_pdf_parsing_cli.git $HOME/dev/project_b_pdf_parsing_cli
git clone git@github.com:makerboarding/project_b_progressive_data.git $HOME/dev/project_b_progressive_data
git clone git@github.com:makerboarding/project_b_query.git $HOME/dev/project_b_query
git clone git@github.com:makerboarding/project_b_racing_form.git $HOME/dev/project_b_racing_form
git clone git@github.com:makerboarding/project_b_sidekick.git $HOME/dev/project_b_sidekick
git clone git@github.com:makerboarding/project_b_slack_notifier.git $HOME/dev/project_b_slack_notifier
git clone git@github.com:makerboarding/project_b_start_query.git $HOME/dev/project_b_start_query
git clone git@github.com:makerboarding/project_b_trackmaster_fetch_cli.git $HOME/dev/project_b_trackmaster_fetch_cli
git clone git@github.com:makerboarding/project_b_tui.git $HOME/dev/project_b_tui
# Renamed to project_b_twinspires_odds_scrape_cli (repo id 298726269). The old
# name still clones — GitHub keeps rename redirects forever — so leaving this
# line in produced a SECOND working tree of the same repo on every fresh
# machine, at a path no launch agent reads. The jobs use the _odds_ path below.
# git clone git@github.com:makerboarding/project_b_twinspires_scrape_cli.git $HOME/dev/project_b_twinspires_scrape_cli
git clone git@github.com:makerboarding/project_b_twinspires_odds_scrape_cli.git $HOME/dev/project_b_twinspires_odds_scrape_cli
git clone git@github.com:makerboarding/project_b_unified_pars.git $HOME/dev/project_b_unified_pars

git clone git@github.com:quantifiedflow/quantified_status.git $HOME/dev/quantified_status

# git clone git@github.com:sessuru-admin/sessuru_material.git $HOME/dev/sessuru_material
# git clone git@github.com:sessuru-admin/sessuru_server.git $HOME/dev/sessuru_server
# git clone git@github.com:sessuru-admin/sessuru_client.git $HOME/dev/sessuru_client
# git clone git@bitbucket.org:sessuru/sessuru_web.git $HOME/dev/sessuru_web
# git clone git@bitbucket.org:sessuru/sessuru_ios.git $HOME/dev/sessuru_ios

[ ! -d "$HOME/dev/exercism" ] && mkdir "$HOME/dev/exercism"

git clone git@github.com:dgdosen/exercism_go.git $HOME/dev/exercism/go
git clone git@github.com:dgdosen/exercism_java.git $HOME/dev/exercism/java
git clone git@github.com:dgdosen/exercism_ruby.git $HOME/dev/exercism/ruby
git clone git@github.com:dgdosen/exercism_javascript.git $HOME/dev/exercism/javascript
git clone git@github.com:dgdosen/exercism_crystal.git $HOME/dev/exercism/crystal
git clone git@github.com:dgdosen/exercism_elm.git $HOME/dev/exercism/elm
git clone git@github.com:dgdosen/exercism_typescript.git $HOME/dev/exercism/typescript
git clone git@github.com:dgdosen/exercism_elixir.git $HOME/dev/exercism/elixir
git clone git@github.com:dgdosen/exercism_swift.git $HOME/dev/exercism/swift
git clone git@github.com:dgdosen/exercism_python.git $HOME/dev/exercism/python
