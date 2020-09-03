" omnifuncs
augroup omnifuncs
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup end

" textyank post
if exists('##TextYankPost')
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank('Substitute', 300)
endif

" Allow backgrounding buffers without writing them, and remember marks/undo
" for backgrounded buffers
set hidden

" Remember more commands and search history
set history=10000

" Make tab completion for files/buffers act like bash
set wildmenu

" Make searches case-sensitive only if they contain upper-case characters
set ignorecase
set smartcase

" vim performance hack for the regex engine../
" per stackoverflow.com/questions/16902317
set re=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ARROW KEYS ARE UNACCEPTABLE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" map <Left> :echo "no!"<cr>
" map <Right> :echo "no!"<cr>
" map <Up> :echo "no!"<cr>
" map <Down> :echo "no!"<cr>

" Keep more context when scrolling off the end of a buffer
set scrolloff=3

" Store temporary files in a central spot
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

filetype plugin indent on

" line wrapping
set breakindent
set linebreak
set showbreak=\ \
" set breakat= " "


" GRB: sane editing configuration"
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
" set smartindent
set laststatus=2
set showmatch
set incsearch

set textwidth=80
set wrapmargin=2

" " GRB: Put useful info in status line
" :set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
" :hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red

" " GRB: clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<cr>

let mapleader="\<Space>"

set cmdheight=2

" Don't show scroll bars in the GUI
set guioptions-=L
set guioptions-=r

map <leader>n :call RenameFile()<cr>

set number
set numberwidth=4
set relativenumber

" Always show tab bar
set showtabline=2

set previewheight=20

set ttyfast
" set ttyscroll=3
set lazyredraw

" DGD: autoreload
augroup AutoReloadVimRC
  au!
  " automatically reload vimrc when it's saved
  au BufWritePost $MYVIMRC so $MYVIMRC
augroup END

"DGD: override mac keys
map <D-f> f
map <D-r> x

"DGD: long lines
" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%81v.\+/
highlight Search ctermbg=red ctermfg=lightgrey

"DGD: adding dgd to keywora
" todo: TODO: XXX DGD FIXME: FOO
" syntax keyword myTodo contained BUG REVIEW FIXME FOO TODO DGD NOTE FIXME: DGD:
" syntax keyword potionKeyword FOO DGD NOTE FIXME: DGD:
" autocmd syntax keyword DGD
" syn match   myTodo   contained   "\<\(todo\|fixme\|note\):"
" hi def link myTodo yellow
"
"DGD: save on leaving insert
autocmd InsertLeave * write

" remapping most common keystrokes
nnoremap <Leader>q :q<CR>
nnoremap <Leader>w :w<CR>

" set timeout for escape length
set timeoutlen=1000 ttimeoutlen=0

" mouse support
set mouse=a

let g:clipboard = {
  \ 'name': 'pbcopy',
  \ 'copy': {
  \    '+': 'pbcopy',
  \    '*': 'pbcopy',
  \  },
  \ 'paste': {
  \    '+': 'pbpaste',
  \    '*': 'pbpaste',
  \ },
  \ 'cache_enabled': 0,
  \ }

noremap! <expr> ,t strftime("%H:%M")
noremap! <expr> ,d strftime("%Y-%m-%d")
noremap! <expr> ,l strftime("%Y-%m-%d %H:%M")

noremap! <expr> ,L strftime("%Y-%m-%d %I:%M %p")
noremap! <expr> ,T strftime("%H:%M:%S")

