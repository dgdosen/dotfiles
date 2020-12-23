# path
set -gx PATH /Users/dgdosen/.bin $PATH
set -gx PATH /opt/homebrew/bin $PATH
set -gx PATH /usr/local/var/rbenv/shims $PATH
set -gx PATH $PATH /Applications/Postgres.app/Contents/Versions/latest/bin
# set -gx PATH (brew --prefix)/var/rbenv/shims $PATH

# nodenv
set -gx fish_user_paths $HOME/.nodenv/bin $fish_user_paths
set -gx PATH $HOME/.nodenv/shims $PATH

# alias
alias cc='clear'
alias gh='github'

# cd
function c
  cd $argv
end

complete --command c --arguments '(__fish_complete_directories ~/dev/)'

# set -gx RBENV_ROOT /opt/homebrew/var/rbenv/
set -gx RBENV_ROOT /usr/local/var/rbenv/
set fish_key_bindings fish_user_key_bindings
# set fish_plugins autojump vi-mode

set -g theme_nerd_fonts yes
# theme_gruvbox dark medium
set -g theme_color_scheme gruvbox
set -g theme_date_format "+%Y-%m-%d %H:%M %a"
# set -g theme_color_scheme base16
set -g theme_display_vi yes
set -g theme_display_ruby no
# set -g theme_display_nvm yes

set -g theme_nerd_fonts yes
# set -g theme_powerline_fonts yes
# set -g theme_color_scheme solarized

echo "using dotfiles fish config"
