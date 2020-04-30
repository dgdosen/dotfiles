# scripting test - link files based on shell type?
# - link files based on all files?
# - link files based on folders and environment!

# bin (for tmuxinator?)
[ ! -L "$HOME/.bin" ] && ln -sv ~/.dotfiles/.bin ~/.bin

# dotfiles
ln -sv ~/.dotfiles/.ackrc  ~/.ackrc
ln -sv ~/.dotfiles/.agignore  ~/.agignore
ln -sv ~/.dotfiles/.androidrc  ~/.androidrc
ln -sv ~/.dotfiles/.bash_profile  ~/.bash_profile
ln -sv ~/.dotfiles/.bashrc  ~/.bashrc
ln -sv ~/.dotfiles/.dotrc ~/.dotrc
ln -sv ~/.dotfiles/.gemrc ~/.gemrc
ln -sv ~/.dotfiles/.gitconfig ~/.gitconfig
ln -sv ~/.dotfiles/.p10k.zsh  ~/.p10k.zsh
ln -sv ~/.dotfiles/.pomorc ~/.pomorc
ln -sv ~/.dotfiles/.prettierrc ~/.prettierrc
ln -sv ~/.dotfiles/.pryrc ~/.pryrc
ln -sv ~/.dotfiles/.rubocop.yml ~/.rubocop.yml
ln -sv ~/.dotfiles/.ruby-version ~/.ruby-version

# tmux
[ ! -L "$HOME/.tmux" ] && ln -sv ~/.dotfiles/.tmux ~/.tmux
ln -sv ~/.dotfiles/.tmux-theme-gruvbox.conf ~/.tmux-theme-gruvbox.conf
ln -sv ~/.dotfiles/.tmux.conf ~/.tmux.conf
[ ! -L "$HOME/.tmuxinator" ] && ln -sv ~/.dotfiles/.tmuxinator ~/.tmuxinator

# vim/nvim
[ ! -L "$HOME/.vim" ] && ln -sv ~/.dotfiles/.vim ~/.vim
[ ! -L "$HOME/.vim_nvim" ] && ln -sv ~/.dotfiles/.vim_nvim ~/.vim_nvim
ln -sv ~/.dotfiles/.vimrc ~/.vimrc

# zsh
[ ! -L "$HOME/.zsh" ] && ln -sv ~/.dotfiles/.zsh ~/.zsh
[ ! -L "$HOME/.zsh_customizations" ] && ln -sv ~/.dotfiles/.zsh_customizations ~/.zsh_customizations
ln -sv ~/.dotfiles/.zshrc ~/.zshrc

# testing
[ ! -d "$HOME/.cron_support" ] && mkdir ~/.cron_support
ln -sv ~/.dotfiles/foobar.txt ~/.cron_support/foobar.txt

# config files
[ ! -d "$HOME/.config" ] && mkdir ~/.config
[ ! -d "$HOME/.config/karabiner" ] && mkdir ~/.config/karabiner
[ ! -d "$HOME/.config/alacritty" ] && mkdir ~/.config/alacritty
[ ! -L "$HOME/.config/nvim" ] && ln -sv ~/.dotfiles/.vim_nvim ~/.config/nvim
ln -sv ~/.dotfiles/.config/karabiner/karabiner.json ~/.config/karabiner/karabiner.json
ln -sv ~/.dotfiles/.config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml

# project b dropbox
[ ! -L "$HOME/dropboxm" ] && ln -sv ~/Dropbox\ \(makerboarding\) ~/dropboxm

# project b database utils
[ ! -d "$HOME/.postgres" ] && mkdir ~/.postgres
ln -sv ~/.dotfiles/.postgres/postgres_project_b_reset.sh ~/.postgres/postgres_project_b_reset.sh
ln -sv ~/.dotfiles/.postgres/postgres_project_b_dw_reset.sh ~/.postgres/postgres_project_b_dw_reset.sh
ln -sv ~/.dotfiles/.postgres/postgrestunnel_ssi.pl ~/.postgres/postgrestunnel_ssi.pl
ln -sv ~/.dotfiles/.postgres/postgrestunnel_hendricks.pl ~/.postgres/postgrestunnel_hendricks.pl


# TODO: project b config files
# TODO: is there a way to automate VSCode setup?

