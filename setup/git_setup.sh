# Initial clone of the repositories this machine needs that are NOT project_b.
#
# project_b repos are deliberately absent. ~/.project_b/jobs/project_b_repo_sync.sh
# (com.makerboarding.project_b_repo_sync, nightly at 02:30) owns them: it clones
# any that are missing and fast-forwards the rest, so on a new machine install
# that agent (or run the script once) instead. Removed from here 2026-10-17 so
# there is ONE project_b repo list — this copy and repo_sync's had already
# needed a hand-kept "adding a clone here means adding it there too" rule.
# The handful of dormant project_b repos repo_sync skips are listed, with how to
# clone them, in that script.

[ ! -d "$HOME/dev" ] && mkdir "$HOME/dev"
git clone git@github.com:dgdosen/dotfiles.git $HOME/.dotfiles

# Alacritty (not available via Homebrew cask - deprecated due to Gatekeeper)
git clone https://github.com/alacritty/alacritty.git $HOME/dev/alacritty

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
