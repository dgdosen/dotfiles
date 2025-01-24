# intial clone of daily fetched repositories

[ ! -d "$HOME/dev" ] && mkdir "$HOME/dev"
git clone git@github.com:dgdosen/dotfiles.git $HOME/.dotfiles

git clone git@github.com:makerboarding/project_b.git $HOME/dev/project_b_api
git clone git@github.com:makerboarding/project_b_data.git $HOME/dev/project_b_data
git clone git@github.com:makerboarding/project_b_data_2023.git $HOME/dev/project_b_data_2023
git clone git@github.com:makerboarding/project_b_start_query.git $HOME/dev/project_b_start_query
git clone git@github.com:makerboarding/project_b_query.git $HOME/dev/project_b_query
git clone git@github.com:makerboarding/project_b_racing_form.git $HOME/dev/project_b_racing_form
git clone git@github.com:makerboarding/project_b_debut.git $HOME/dev/project_b_debut
git clone git@github.com:makerboarding/project_b_hooks.git $HOME/dev/project_b_hooks
git clone git@github.com:makerboarding/project_b_pars.git $HOME/dev/project_b_pars
git clone git@github.com:makerboarding/project_b_generic_matching.git $HOME/dev/project_b_generic_matching
git clone git@github.com:makerboarding/project_b_matching.git $HOME/dev/project_b_matching
git clone git@github.com:makerboarding/project_b_sidekick.git $HOME/dev/project_b_sidekick

git clone git@github.com:sessuru-admin/sessuru_material.git $HOME/dev/sessuru_material
git clone git@github.com:sessuru-admin/sessuru_server.git $HOME/dev/sessuru_server
git clone git@github.com:sessuru-admin/sessuru_client.git $HOME/dev/sessuru_client
git clone git@bitbucket.org:sessuru/sessuru_web.git $HOME/dev/sessuru_web
git clone git@bitbucket.org:sessuru/sessuru_ios.git $HOME/dev/sessuru_ios

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
