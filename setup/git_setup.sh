# intial clone of daily fetched repositories

[ ! -d "$HOME/dev" ] && mkdir "$HOME/dev"
git clone git@github.com:dgdosen/dotfiles.git $HOME/.dotfiles

git clone git@github.com:makerboarding/project_b.git $HOME/dev/project_b
git clone git@github.com:makerboarding/project_b_data.git $HOME/dev/project_b_data
git clone git@github.com:makerboarding/project_b_start_query.git $HOME/dev/project_b_start_query
git clone git@github.com:makerboarding/project_b_query.git $HOME/dev/project_b_query
git clone git@github.com:makerboarding/project_b_racing_form.git $HOME/dev/project_b_racing_form
git clone git@github.com:makerboarding/project_b_debut.git $HOME/dev/project_b_debut
git clone git@github.com:makerboarding/project_b_hooks.git $HOME/dev/project_b_hooks
git clone git@github.com:makerboarding/project_b_pars.git $HOME/dev/project_b_pars
git clone git@github.com:makerboarding/project_b_generic_matching.git $HOME/dev/project_b_generic_matching
git clone git@github.com:makerboarding/project_b_matching.git $HOME/dev/project_b_matching

git clone git@github.com:sessuru-admin/sessuru_material.git $HOME/sessuru_material
git clone git@github.com:sessuru-admin/sessuru_server.git $HOME/sessuru_server
git clone git@github.com:sessuru-admin/sessuru_client.git $HOME/sessuru_client

[ ! -d "$HOME/dev/exercism" ] && mkdir "$HOME/dev/exercism"

git clone git@github.com:dgdosen/exercism_go.git $HOME/dev/exercism/exercism_go
git clone git@github.com:dgdosen/exercism_java.git $HOME/dev/exercism/exercism_java
git clone git@github.com:dgdosen/exercism_ruby.git $HOME/dev/exercism/exercism_ruby
git clone git@github.com:dgdosen/exercism_javascript.git $HOME/dev/exercism/exercism_javascript
git clone git@github.com:dgdosen/exercism_crystal.git $HOME/dev/exercism/exercism_crystal
git clone git@github.com:dgdosen/exercism_elm.git $HOME/dev/exercism/exercism_elm
git clone git@github.com:dgdosen/exercism_typescript.git $HOME/dev/exercism/exercism_typescript
git clone git@github.com:dgdosen/exercism_elixir.git $HOME/dev/exercism/exercism_elixir
git clone git@github.com:dgdosen/exercism_swift.git $HOME/dev/exercism/exercism_swift
git clone git@github.com:dgdosen/exercism_python.git $HOME/dev/exercism/exercism_python
