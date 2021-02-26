# path
set -gx PATH /Users/dgdosen/.bin $PATH
set -gx PATH /opt/homebrew/bin $PATH
set -gx PATH /usr/local/var/rbenv/shims $PATH
set -g fish_user_paths "/opt/homebrew/sbin" $fish_user_paths
set -gx PATH $PATH /Applications/Postgres.app/Contents/Versions/latest/bin
# set -gx PATH (brew --prefix)/var/rbenv/shims $PATH

# rust - cargo
set -gx PATH "$HOME/.cargo/bin" $PATH

# nodenv
set -gx fish_user_paths $HOME/.nodenv/bin $fish_user_paths
set -gx PATH $HOME/.nodenv/shims $PATH
set -gx EDITOR nvim
# alias
alias cc clear
alias gh github
alias tkss 'tmux kill-session -t'
# why isn't this alias loaded in comletions?
alias mux tmuxinator

# cd
function c
  cd $argv
end

complete --command c --arguments '(__fish_complete_directories ~/dev/)'

switch (uname -m)
  case arm64
    echo 'fish config uname: arm64'
    set -gx RBENV_ROOT /opt/homebrew/var/rbenv/
  case x86_64
    echo 'fish config uname: x86_64'
    set -gx RBENV_ROOT /usr/local/var/rbenv/
  case '*'
    echo 'on dunno'
end
status --is-interactive; and source (rbenv init -|psub)

# set fish_key_bindings fish_user_key_bindings
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

# opam configuration
source /Users/dgdosen/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
