# scripting test - link files based on shell type?
# - link files based on all files?
# - link files based on folders and environment!

# bin (for tmuxinator?)
[ ! -L "$HOME/.bin" ] && ln -sfnv ~/.dotfiles/.bin ~/.bin

# dotfiles
ln -sfnv ~/.dotfiles/.ackrc  ~/.ackrc
ln -sfnv ~/.dotfiles/.agignore  ~/.agignore
ln -sfnv ~/.dotfiles/.androidrc  ~/.androidrc
ln -sfnv ~/.dotfiles/.bash_profile  ~/.bash_profile
ln -sfnv ~/.dotfiles/.bashrc  ~/.bashrc
ln -sfnv ~/.dotfiles/.dotrc ~/.dotrc
ln -sfnv ~/.dotfiles/.gemrc ~/.gemrc
ln -sfnv ~/.dotfiles/.gitconfig ~/.gitconfig
ln -sfnv ~/.dotfiles/.p10k.zsh  ~/.p10k.zsh
ln -sfnv ~/.dotfiles/phoenix.js  ~/.phoenix.js
ln -sfnv ~/.dotfiles/.pomorc ~/.pomorc
ln -sfnv ~/.dotfiles/.prettierrc ~/.prettierrc
ln -sfnv ~/.dotfiles/.pryrc ~/.pryrc
ln -sfnv ~/.dotfiles/.rubocop.yml ~/.rubocop.yml
ln -sfnv ~/.dotfiles/.ruby-version ~/.ruby-version

# database support in neovim
DB_SOURCE="$HOME/.dotfiles/local/share/nvim/sqlua"
ln -sfnv "$DB_SOURCE" "$HOME/.local/share/nvim/sqlua"
ln -sfnv "$DB_SOURCE" "$HOME/.local/share/db_ui"

# tmux
[ ! -L "$HOME/.tmux" ] && ln -sfnv ~/.dotfiles/.tmux ~/.tmux
# ln -sfnv ~/.dotfiles/.tmux-theme-gruvbox.conf ~/.tmux-theme-gruvbox.conf
ln -sfnv ~/.dotfiles/.tmux.conf ~/.tmux.conf
[ ! -L "$HOME/.tmuxinator" ] && ln -sfnv ~/.dotfiles/.tmuxinator ~/.tmuxinator

# vim/nvim
[ ! -L "$HOME/.vim" ] && ln -sfnv ~/.dotfiles/.vim ~/.vim
[ ! -L "$HOME/.vim_nvim" ] && ln -sfnv ~/.dotfiles/.vim_nvim ~/.vim_nvim
[ ! -L "$HOME/.nvim" ] && ln -sfnv ~/.dotfiles/.nvim ~/.nvim
ln -sfnv ~/.dotfiles/.vimrc ~/.vimrc

# zsh
[ ! -L "$HOME/.zsh" ] && ln -sfnv ~/.dotfiles/.zsh ~/.zsh
[ ! -L "$HOME/.zsh_customizations" ] && ln -sfnv ~/.dotfiles/.zsh_customizations ~/.zsh_customizations
ln -sfnv ~/.dotfiles/.zshrc ~/.zshrc

# testing
[ ! -d "$HOME/.cron_support" ] && mkdir ~/.cron_support
ln -sfnv ~/.dotfiles/foobar.txt ~/.cron_support/foobar.txt

# config files
[ ! -d "$HOME/.config" ] && mkdir ~/.config
[ ! -d "$HOME/.config/fish" ] && mkdir ~/.config/fish
[ ! -d "$HOME/.config/fish/functions" ] && mkdir ~/.config/fish/functions
[ ! -d "$HOME/.config/karabiner" ] && mkdir ~/.config/karabiner
[ ! -d "$HOME/.config/alacritty" ] && mkdir ~/.config/alacritty
[ ! -L "$HOME/.config/nvim" ] && ln -sfnv ~/.dotfiles/nvim_dgd ~/.config/nvim
[ ! -L "$HOME/.config/smug" ] && ln -sfnv ~/.dotfiles/.config/smug ~/.config/smug
[ ! -L "$HOME/.config/lazygit" ] && ln -sfnv ~/.dotfiles/.config/lazygit ~/.config/lazygit
ln -sfnv ~/.dotfiles/.config/karabiner/karabiner.json ~/.config/karabiner/karabiner.json
ln -sfnv ~/.dotfiles/.config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
ln -sfnv ~/.dotfiles/.config/fish/config.fish ~/.config/fish/config.fish
ln -sfnv ~/.dotfiles/.config/fish/functions/fish_user_key_bindigs.fish ~/.config/fish/functions/fish_user_key_bindings.fish
ln -sfnv ~/.dotfiles/.config/fish/fish_variables ~/.config/fish/fish_variables

# project b dropbox
[ ! -L "$HOME/dropboxm" ] && ln -sfnv ~/Dropbox\ \(makerboarding\) ~/dropboxm

# project b database utils
[ ! -d "$HOME/.postgres" ] && mkdir ~/.postgres
# ln -sfnv ~/.dotfiles/.postgres/postgres_project_b_reset.sh ~/.postgres/postgres_project_b_reset.sh
# ln -sfnv ~/.dotfiles/.postgres/postgres_project_b_dw_reset.sh ~/.postgres/postgres_project_b_dw_reset.sh
# ln -sfnv ~/.dotfiles/.postgres/postgrestunnel_ssi.pl ~/.postgres/postgrestunnel_ssi.pl
# ln -sfnv ~/.dotfiles/.postgres/postgrestunnel_hendricks.pl ~/.postgres/postgrestunnel_hendricks.pl


# TODO: project b config files
# TODO: is there a way to automate VSCode setup?

