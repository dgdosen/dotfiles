cc() {
  clear; printf '\e[3J'
}

tm() {
  ~/.dotfiles/.zsh_customizations/tmux-sessionizer.sh
}

# clean up nvim
nvimup() {

  FOO=$PWD
  cd ~/.dotfiles
  nvim --headless -c "Lazy! sync" +qa
  echo " -- Lazy Updated"
  nvim --headless -c "TSUpdate" +qa
  echo " -- TreeSitter Updated"
  nvim --headless -c "MasonUpdateAll"
  # nvim --headless -c 'UpdateRemotePlugins' +qa
  echo " -- Mason Updated"
  cd $FOO
}


# clean up dotfile submodules
dotup() {

  FOO=$PWD
  cd ~/.dotfiles
  echo in dotfiles
  gsm
  gsp

  cd $FOO
}

cdot() {
  cd ~/.dotfiles
}

ch() {
  cd ~
}

touchfoo() {
  mkdir ~/.cron_support
  touch ~/.cron_support/foobar.txt
}

# homebrew upgrade
brewup() {
  brew update
  brew upgrade  --greedy
  brew cleanup
  mas upgrade
}

armify() {
  export PATH=/opt/homebrew/bin:$PATH
  export PATH=/opt/homebrew/sbin:$PATH
}

fzffd() {
 local dir
 dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d \
      -print 2> /dev/null | fzf +m) &&
 cd "$dir"
}

fzfag() {
  local dir
  dir=$(ag --hiden ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"

}

fzfcd() {
    if [[ "$#" != 0 ]]; then
        builtin cd "$@";
        return
    fi
    while true; do
        local lsd=$(echo ".." && ls -p | grep '/$' | sed 's;/$;;')
        local dir="$(printf '%s\n' "${lsd[@]}" |
            fzf --reverse --preview '
                __cd_nxt="$(echo {})";
                __cd_path="$(echo $(pwd)/${__cd_nxt} | sed "s;//;/;")";
                echo $__cd_path;
                echo;
                ls -p --color=always "${__cd_path}";
        ')"
        [[ ${#dir} != 0 ]] || return 0
        builtin cd "$dir" &> /dev/null
    done
}

function reload_agidevelopment_plists2() {
  local plist_dir="${1/#\~/$HOME}"  # Expands ~ to $HOME
  local match_string="com.agidevelopment"

  # Find all plist files in the specified directory that contain 'com.agidevelopment'
  # The -maxdepth 1 option prevents find from searching subdirectories
  find "$plist_dir" -maxdepth 1 -name "*$match_string*.plist" | while read plist_path; do
    echo "Reloading $plist_path"
    local service_name="$(basename "$plist_path" .plist)"
    launchctl unload "$plist_path" 2>/dev/null
    launchctl load "$plist_path"
  done
}

function reload_all_agidevelopment_plists() {
  local plist_dir="$1"

  # Find all plist files in the specified directory that contain 'com.agidevelopment'
  find "$plist_dir" -name "*com.agidevelopment*.plist" | while read plist_path; do
    echo "Setting up monitoring for $plist_path"
    monitor_and_reload_plist "$plist_path" &
  done
}

dltest() {
  date  ## echo the date at start
  # the script contents
  curl https://releases.ubuntu.com/22.04.2/ubuntu-22.04.2-desktop-amd64.iso --output ~/downloads/ubuntutest.iso
  date  ## echo the date at enda
}

# TODO: put this in zshrc?
# Use C-x C-e to edit the current command line
autoload -U edit-command-line
zle -N edit-command-line

bindkey '^x^e' edit-command-line
# bindkey '\C-x\C-e' edit-command-line

# zsh autocomplete accept
bindkey '^ ' autosuggest-accept

# vim key bindings to edit the command line
bindkey -v
