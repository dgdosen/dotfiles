"neovim version

set nocompatible              " be iMproved, required
filetype off                  " required

source $HOME/.config/nvim/config/init.vimrc
source $HOME/.config/nvim/config/general.vimrc
source $HOME/.config/nvim/config/colors.vimrc

" source $HOME/.config/nvim/config/colors_night.vimrc
if ($APPEARANCE != 'light')
  source $HOME/.config/nvim/config/colors_night.vimrc
  " :so $NVIM_DAY
else
  source $HOME/.config/nvim/config/colors_day.vimrc
   " :so $NVIM_NIGHT
endif

source $HOME/.config/nvim/config/keys.vimrc
source $HOME/.config/nvim/config/misc.vimrc
source $HOME/.config/nvim/config/plugins.vimrc
source $HOME/.config/nvim/config/term.vimrc
source $HOME/.config/nvim/config/terminal.vimrc

" NVIM specific
" "DGD: getting ultisnips and youcomplete me
" autocmd! BufWritePost * Neomake


