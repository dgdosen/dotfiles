# clean up dotfile submodules
dotup() {

  FOO=$PWD
  cd ~/.dotfiles
  echo in dotfiles
  gsm
  gsp
  nvim +'PlugInstall --sync' +qa
  nvim +'PlugUpdate --sync' +qa
  nvim +'UpdateRemotePlugins' +qa

  cd $FOO
}

cdot() {
  cd ~/.dotify
}

touchfoo() {
  mkdir ~/.cron_support
  touch ~/.cron_support/foobar.txt
}


# homebrew upgrade
brewup() {
  brew update
  brew upgrade
  brew cleanup
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

# TODO: put this in zshrc?
# Use C-x C-e to edit the current command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

