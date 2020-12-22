# path
set -gx PATH /Users/dgdosen/.bin $PATH
set -gx PATH /opt/homebrew/bin $PATH

# alias
# alias c='clear'
alias gh='github'

# cd
function xd
  cd $argv
end

complete --command xd --arguments '(__fish_complete_directories ~/dev/)'

# set -gx RBENV_ROOT /opt/homebrew/var/rbenv/
set -gx RBENV_ROOT /usr/local/var/rbenv/
set fish_plugins autojump vi-mode

set -g theme_nerd_fonts yes
# theme_gruvbox dark medium
set -g theme_color_scheme gruvbox
set -g theme_date_format "+%Y-%m-%d %H:%M %a"
# set -g theme_color_scheme base16
set -g theme_display_vi yes
set -g theme_display_ruby yes

set -g theme_nerd_fonts yes
set -g theme_powerline_fonts yes
# set -g theme_color_scheme solarized

set -x fish_color_command green --bold
set -x fish_color_autosuggestion white
set -x fish_color_ruby blue

