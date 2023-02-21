# dotfile submodules
# NOTE: I've been using tokyonights too... Need those colors in alacritty and tmux
# alacritty
# mkdir -p ~/.config/alacritty/themes
# git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
# tmux.conf
# set -g @plugin 'egel/tmux-gruvbox'
# set -g @plugin "janoamaral/tokyo-night-tmux"
#
cd ~/.dotfiles
git submodule add https://github.com/egel/tmux-gruvbox.git .tmux/plugins/tmux-gruvbox
git submodule add https://github.com/tmux-plugins/tpm.git .tmux/plugins/tpm
git submodule add https://github.com/zsh-users/zsh-autosuggestions.git .zsh_customizations/plugins/zsh-autosuggestions
# note = different on linux!
# git submodule add https://github.com/zsh-users/zsh-syntax-highlighting.git .zsh_customizations/plugins/zsh-syntax-highlighting
