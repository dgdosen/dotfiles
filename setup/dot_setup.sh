# scripting test - link files based on shell type?
# - link files based on all files?
# - link files based on folders and environment!

# bin (for tmuxinator?)
ln -sv ~/.dotfiles/.bin ~/.bin

# dotfiles
ln -sv ~/.dotfiles/.ackrc  ~/.ackrc
ln -sv ~/.dotfiles/.agignore  ~/.agignore
ln -sv ~/.dotfiles/.androidrc  ~/.androidrc
ln -sv ~/.dotfiles/.bash_profile  ~/.bash_profile
ln -sv ~/.dotfiles/.bashrc  ~/.bashrc
ln -sv ~/.dotfiles/.dotrc ~/.dotrc
ln -sv ~/.dotfiles/.gemrc ~/.gemrc
ln -sv ~/.dotfiles/.gitconfig ~/.gitconfig
ln -sv ~/.dotfiles/.pomorc ~/.pomorc
ln -sv ~/.dotfiles/.prettierrc ~/.prettierrc
ln -sv ~/.dotfiles/.pryrc ~/.pryrc
ln -sv ~/.dotfiles/.rubocop.yml ~/.rubocop.yml
ln -sv ~/.dotfiles/.ruby-version ~/.ruby-version

# tmux
ln -sv ~/.dotfiles/.tmux ~/.tmux
ln -sv ~/.dotfiles/.tmux-theme-gruvbox.conf ~/.tmux-theme-gruvbox.conf
ln -sv ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -sv ~/.dotfiles/.tmuxinator ~/.tmuxinator

# vim/nvim
ln -sv ~/.dotfiles/.vim ~/.vim
ln -sv ~/.dotfiles/.vim_nvim ~/.vim_nvim
ln -sv ~/.dotfiles/.vimrc ~/.vimrc

# zsh
ln -sv ~/.dotfiles/.zsh ~/.zsh
ln -sv ~/.dotfiles/.zsh_customizations ~/.zsh_customizations
ln -sv ~/.dotfiles/.zshrc ~/.zshrc

# testing
mkdir ~/cron_support
ln -sv ~/.dotfiles/foobar.txt ~/cron_support/foobar.txt

# config files
mkdir ~/.config
mkdir ~/.config/karabiner
ln -sv ~/.dotfiles/.vim_nvim ~/.config/nvim
ln -sv ~/.dotfiles/.config/karabiner/karabiner.json ~/.config/karabiner/karabiner.json
ln -sv ~/.dotfiles/.vim_nvim ~/.config/nvim

# project b dropbox
ln -sv ~/Dropbox\ \(makerboarding\) ~/dropboxm

# project b database utils
mkdir ~/.postgres
ln -sv ~/.dotfiles/.postgres/postgres_project_b_reset.sh ~/.postgres/postgres_project_b_reset.sh
ln -sv ~/.dotfiles/.postgres/postgres_project_b_dw_reset.sh ~/.postgres/postgres_project_b_dw_reset.sh
ln -sv ~/.dotfiles/.postgres/postgrestunnel_ssi.pl ~/.postgres/postgrestunnel_ssi.pl
ln -sv ~/.dotfiles/.postgres/postgrestunnel_hendricks.pl ~/.postgres/postgrestunnel_hendricks.pl


# TODO: project b config files
# TODO: is there a way to automate VSCode setup?

