# scripting test - link files based on shell type?
# - link files based on all files?
# - link files based on folders and environment!
ln -sv ~/.dotfiles/foobar.txt ~/.foobar.txt

ln -sv ~/.dotfiles/.zsh ~/.zsh
ln -sv ~/.dotfiles/.zshrc ~/.zshrc
ln -sv ~/.dotfiles/.zsh_customizations ~/.zsh_customizations

ln -sv ~/.dotfiles/.vimrc ~/.vimrc
ln -sv ~/.dotfiles/.vim_nvim ~/.vim_nvim
ln -sv ~/.dotfiles/.vim ~/.vim

ln -sv ~/.dotfiles/.tmux ~/.tmux
ln -sv ~/.dotfiles/.tmuxinator ~/.tmuxinator
ln -sv ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -sv ~/.dotfiles/.tmux-theme-gruvbox.conf ~/.tmux-theme-gruvbox.conf

ln -sv ~/.dotfiles/.ruby-version ~/.ruby-version
ln -sv ~/.dotfiles/.gemrc ~/.gemrc
ln -sv ~/.dotfiles/.pryrc ~/.pryrc
ln -sv ~/.dotfiles/.prettierrc ~/.prettierrc

ln -sv ~/.dotfiles/.gitconfig ~/.gitconfig
ln -sv ~/.dotfiles/.bin ~/.bin

# config files
ln -sv ~/.dotfiles/.vim_nvim ~/.config/nvim
ln -sv ~/.dotfiles/.config/karabiner/karabiner.json ~/.config/karabiner/karabiner.json
# deprecated - key in json
# ln -sv ~/.dotfiles/.config/exercism/user.json ~/.config/exercism/user.json

# project b dropbox
ln -sv ~/Dropbox\ \(makerboarding\) ~/dropboxm
# project b database utils
ln -sv ~/.dotfiles/postgres_project_b_reset.sh ~/.postgres_project_b_reset.sh
ln -sv ~/.dotfiles/postgres_project_b_dw_reset.sh ~/.postgres_project_b_dw_reset.sh

# TODO: project b config files
# TODO: is there a way to automate VSCode setup?

