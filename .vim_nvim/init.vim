"neovim version

set nocompatible              " be iMproved, required
filetype off                  " required

source $HOME/.config/nvim/config/init.vimrc
source $HOME/.config/nvim/config/general.vimrc
source $HOME/.config/nvim/config/colors.vimrc
source $HOME/.config/nvim/config/plugins.vimrc
source $HOME/.config/nvim/config/keys.vimrc
" source $HOME/.config/nvim/config/misc.vimrc

" NVIM specific
" "DGD: getting ultisnips and youcomplete me
autocmd! BufWritePost * Neomake


