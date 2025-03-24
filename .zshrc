if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p11k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

date
ZSH=$HOME/.oh-my-zsh
# source "$HOME/.vim/plugged/gruvbox/gruvbox_256palette_osx.sh"

export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export ZSH_CUSTOM=$HOME/.zsh_customizations
source $HOME/.zsh_customizations/docker_aliases.sh
source $HOME/.zsh_customizations/working_aliases.sh
source $HOME/.zsh_customizations/pomo_aliases.sh
source $HOME/.zsh_customizations/environment_aliases.sh
source $HOME/.zsh_customizations/git_aliases.sh
source $HOME/.zsh_customizations/color_aliases.sh
source $HOME/.zsh_customizations/covid_aliases.sh
source $HOME/.zsh_customizations/fetch_daily.sh
source $HOME/.zsh_customizations/project_b_aliases.sh
source $HOME/.zsh_customizations/prouductivity_aliases.sh
source $HOME/.zsh_customizations/vim_aliases.sh

export CORS_ORIGN='*'

# # Detect Dropbox Personal and Business locations
if [[ -d "$HOME/Dropbox (Personal)" ]]; then
  export DROPBOX_PERSONAL="$HOME/Dropbox (Personal)"
elif [[ -d "$HOME/Library/CloudStorage/Dropbox-Personal" ]]; then
  export DROPBOX_PERSONAL="$HOME/Library/CloudStorage/Dropbox-Personal"
fi

if [[ -d "$HOME/makerboarding Dropbox" ]]; then
  export DROPBOX_BUSINESS="$HOME/makerboarding Dropbox"
elif [[ -d "$HOME/Library/CloudStorage/Dropbox-makerboarding" ]]; then
  export DROPBOX_BUSINESS="$HOME/Library/CloudStorage/Dropbox-makerboarding"
fi

alias zshconfig="vim ~/.zshrc"

export NVIM_DAY="$HOME/.vim_nvim/config/colors_day.vimrc"
export NVIM_NIGHT="$HOME/.vim_nvim/config/colors_night.vimrc"

export APPEARANCE='dark'
# export APPEARANCE='light'

# if [[ "$APPEARANCE" == "dark" ]]
# then
#   # echo 'appearance defaults to dark'
#   appearance_dark
# else
#   # echo 'appearance set to light'
#   appearance_light
# fi

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

if [[ "`uname`" == "Darwin" ]]
then
  # echo 'darwin oh-my-zsh'
  # NOTE: removing zsh-syntax-highlighting and zsh-autosuggestions here - as they're loaded via homebrew
  plugins=(git git-extras lol powify dgdosen brew docker capistrano gem zeus tmux tmuxinator vi-mode common-aliases )
  # plugins=(git git-extras lol powify dgdosen brew docker capistrano gem zeus tmux tmuxinator vi-mode common-aliases zsh-syntax-highlighting zsh-autosuggestions )
else
  # echo 'linux oh-my-zsh'
  plugins=(git git-extras lol powify dgdosen docker capistrano gem zeus tmux tmuxinator vi-mode common-aliases zsh-syntax-highlighting)
fi

source ~/.bin/tmuxinator.zsh
export DISABLE_AUTO_TITLE=true


source $ZSH/oh-my-zsh.sh
# source ~/.zsh/func/zsh_git_timer.sh

unsetopt correct_all

# Customize to your needs...
# DGD customizations

# set vim as the default editor
export EDITOR='vi'

export CI=false

# SSI data:
export PROJECT_B_BRIS_LOGIN="22schwaeglpe"
export PROJECT_B_BRIS_PASSWORD="ps2042rb"
export PROJECT_B_RAKE_ENVIRONMENT="development"
export PROJECT_B_DEVELOPMENT_CONFIG_LOCATION="$HOME/dev/project_b/config/"
export PROJECT_B_CONFIG_LOCATION="$HOME/dev/project_b/config/"
export PROJECT_B_DOWNLOAD_LOCATION="$HOME/Downloads/download/"
export MB_CONNECTION="{\"adapter\":\"postgresql\", \"encoding\":\"unicode\", \"database\":\"mb_shared_scoreboard_app_development\", \"pool\": \"5\", \"username\":\"postgres\"}"
export MB_DATABASE="mb_shared_scoreboard_app_development"

# homebrew go support
# export GOVERSION=$(brew list go | head -n 1 | cut -d '/' -f 6)
# export GOVERSION="1.16.1"
# export GOROOT=$(go env GOROOT)
# export GOROOT=$(brew --prefix)/Cellar/go/$GOVERSION/libexec
export GOROOT="$(brew --prefix golang)/libexec"
export GOPATH="$HOME/dev/go"
export PATH="$HOME/.cabal/bin:$PATH"
export PATH=$PATH:$GOPATH/bin
# where is GOROOT set?
export PATH=$PATH:$GOROOT/bin

# export GOOGLE_APPLICATION_CREDENTIALS=$HOME/.site-visit-workers-cloud-8706f85a3286.json
# export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.site-visit-workers-cloud-8706f85a3286.json"
export PATH=$PATH:$HOME/dev/flutter/bin
export PATH="$PATH:$HOME/bin"
export PYTHONPATH="$HOME/dev/forecasting"

# Digitial Ocean API (doctl)
export DIGITALOCEAN_ENABLE_BETA=1

# Google Cloud/Kubernetes API (gcloud)
export REGION=us-east1
export MACHINE_TYPE=n1-standard-1

# Setting ag as the default source for fzf
export FZF_DEFAULT_COMMAND='ag -g ""'

# calc time since last commit
# export SINCE_LAST_COMMIT="$(prompt_grb_scm_time_since_commit)"

# add a line to the prompt
# PROMPT=$PROMPT"
# > "

# docker
# eval "$(docker-machine env default)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

test -r /Users/dgdosen/.opam/opam-init/init.zsh && . /Users/dgdosen/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# source platform specific zsh path
source "${HOME}/.zsh/.zshrc-`uname`-`uname -m`-path"
# source platform speicifc zsh (must come last?)
source "${HOME}/.zsh/.zshrc-`uname`"
export PATH="/usr/local/opt/openjdk/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/dgdosen/.pyenv/versions/miniforge3-4.10.3-10/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/dgdosen/.pyenv/versions/miniforge3-4.10.3-10/etc/profile.d/conda.sh" ]; then
        . "/Users/dgdosen/.pyenv/versions/miniforge3-4.10.3-10/etc/profile.d/conda.sh"
    else
        export PATH="/Users/dgdosen/.pyenv/versions/miniforge3-4.10.3-10/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"

# Only source Powerlevel10k if not already sourced
source $ZSH_CUSTOM/themes/powerlevel10k/powerlevel10k.zsh-theme
# [[ ! $P10K_SOURCED ]] && source $ZSH_CUSTOM/themes/powerlevel10k/powerlevel10k.zsh-theme && export P10K_SOURCED=1
export LDFLAGS="-L$(brew --prefix gsl)/lib"
export CPPFLAGS="-I$(brew --prefix gsl)/include"
export PKG_CONFIG_PATH="$(brew --prefix gsl)/lib/pkgconfig"
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Added by Windsurf
export PATH="/Users/dgdosen/.codeium/windsurf/bin:$PATH"
