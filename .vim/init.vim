"neovim version

set nocompatible              " be iMproved, required
filetype off                  " required

runtime bundles/tplugin_vim/macros/tplugin.vim
" set TPlugin! tlib_vim 02tlib
" runtime bundles/vim-tlib/macros/tplugin.vim
call pathogen#infect()
call pathogen#helptags()

source $HOME/.config/nvim/neovim.vimrc

call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
"git@github.com:Shougo/deoplete.nvim.git
Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
Plug 'Shougo/deoplete.nvim'
Plug 'rhysd/vim-crystal'

" " Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
" Plug 'junegunn/vim-easy-align'

" " Any valid git URL is allowed
" Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" " Group dependencies, vim-snippets depends on ultisnips
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" " On-demand loading
" Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" " Using a non-master branch
" Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" " Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
" Plug 'fatih/vim-go', { 'tag': '*' }

" " Plugin options
" Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'

" " Unmanaged plugin (manually installed and updated)
" Plug '~/my-prototype-plugin'

" Add plugins to &runtimepath
call plug#end()

" FORKED STUFF
"
let g:fzf_nvim_statusline = 0
set tags=./tags,.tags

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

let g:fzf_layout = { 'down': '25%' }


" END FORKED

" Allow backgrounding buffers without writing them, and remember marks/undo
" for backgrounded buffers
set hidden

" Remember more commands and search history
set history=10000

" Make tab completion for files/buffers act like bash
set wildmenu

" new vim color support
" set guicolors
" set term=xterm-256color

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

"highlighting search"
set hls


syntax enable
:set t_Co=256 " 256 colors
:set background=dark
" :set background=light
" :color grb256
" :colorscheme  alduin
" :colorscheme sorcerer
" :colorscheme apprentice
" :colorscheme railscasts_dgd
" :colorscheme railscasts
" :colorscheme base16
" :colorscheme base16-railscasts
" :colorscheme solarized
" :colorscheme grb256
:colorscheme gruvbox
" :colorscheme lucius

let g:gruvbox_contrast_dark="medium"

" GRB: use emacs-style tab completion when selecting files, etc
" set wildmode=longest,list

" GRB: Put useful info in status line
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
:hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red

" GRB: clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<cr>
let mapleader="\<Space>"

:hi Visual ctermbg=darkgray guibg=black

" highlight SignColumn ctermbg=lightgrey
" highlight LineNr ctermfg=darkgreen ctermbg=lightgrey
highlight VertSplit ctermfg=white ctermbg=darkgreen
" highlight current line
:set cursorline
" :hi CursorLine ctermbg=darkgrey guibg=black

" highlight current column
:set cc=80
" :hi ColorColumn

set cmdheight=2

" Don't show scroll bars in the GUI
set guioptions-=L
set guioptions-=r

" Use <c-h> for snippets
" let g:NERDSnippets_key = '<c-h>'

augroup myfiletypes
  "clear old autocmds in group
  autocmd!
  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType python set sw=2 sts=2 et
augroup END

set switchbuf=useopen

autocmd BufRead,BufNewFile *.html source ~/.vim/indent/html_grb.vim
autocmd FileType htmldjango source ~/.vim/indent/html_grb.vim

autocmd! BufRead,BufNewFile *.sass setfiletype sass

" DGD: better erb snippet support
" autocmd BufNewFile,BufRead *.html.erb set filetype=html.eruby

" Map ,e and ,v to open files in the same directory as the current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'))
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_nameP
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction

" DGD: Spell Checking
" pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>
"shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sr zw
map <leader>sa zg
map <leader>su zuw
map <leader>s? z=
hi clear SpellBad
hi SpellBad cterm=underline

map <leader>n :call RenameFile()<cr>

set number
set numberwidth=5
set relativenumber

" :au WinEnter * :setlocal number
" :au WinLeave * :setlocal nonumber
if has("gui_running")
    " source ~/proj/vim-complexity/repo/complexity.vim
endif

" Seriously, guys. It's not like :W is bound to anything anyway.
command! W :w

map <leader>rm :BikeExtract<cr>

function! ExtractVariable()
    let name = input("Variable name: ")
    if name == ''
        return
    endif
    " Enter visual mode (not sure why this is needed since we're already in
    " visual mode anyway)
    normal! gv

    " Replace selected text with the variable name
    exec "normal c" . name
    " Define the variable on the line above
    exec "normal! O" . name . " = "
    " Paste the original selected text to be the variable value
    normal! $p
endfunction

function! InlineVariable()
    " Copy the variable under the cursor into the 'a' register
    " XXX: How do I copy into a variable so I don't pollute the registers?
    :normal "ayiw
    " It takes 4 diws to get the variable, equal sign, and surrounding
    " whitespace. I'm not sure why. diw is different from dw in this respect.
    :normal 4diw
    " Delete the expression into the 'b' register
    :normal "bd$
    " Delete the remnants of the line
    :normal dd
    " Go to the end of the previous line so we can start our search for the
    " usage of the variable to replace. Doing '0' instead of 'k$' doesn't
    " work; I'm not sure why.
    normal k$
    " Find the next occurence of the variable
    exec '/\<' . @a . '\>'
    " Replace that occurence with the text we yanked
    exec ':.s/\<' . @a . '\>/' . @b
endfunction

nnoremap <leader>rv :call ExtractVariable()<cr>
nnoremap <leader>ri :call InlineVariable()<cr>

command! KillWhitespace :normal :%s/ *$//g<cr><c-o><cr>

" Always show tab bar
set showtabline=2

augroup mkd
  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;
augroup END

set makeprg=python\ -m\ nose.core\ --machine-out

map <silent> <leader>y :<C-u>silent '<,'>w !pbcopy<CR>

" Make <leader>' switch between ' and "
nnoremap <leader>' ""yls<c-r>={'"': "'", "'": '"'}[@"]<cr><esc>

" Map keys to go to specific files
map <leader>gr :topleft :split config/routes.rb<cr>
function! ShowRoutes()
  " Requires 'scratch' plugin
  :topleft 100 :split __Routes__
  " Make sure Vim doesn't write __Routes__ as a file
  :set buftype=nofile
  " Delete everything
  :normal 1GdG
  " Put routes output in buffer
  :0r! rake -s routes
  " Size window to number of lines (1 plus rake output length)
  :exec ":normal " . line("$") . "_ "
  " Move cursor to bottom
  :normal 1GG
  " Delete empty trailing line
  :normal dd
endfunction

" map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
map <leader>t :CtrlPTag<cr>
map <leader>f :FZF<cr>
map <leader>ga :FZF app/assets<cr>
map <leader>gj :FZF app/assets/javascripts<cr>
map <leader>gy :FZF app/assets/stylesheets<cr>
map <leader>gm :FZF app/models<cr>
map <leader>go :FZF app/objects<cr>
map <leader>gc :FZF app/controllers<cr>
map <leader>gv :FZF app/views<cr>
map <leader>gs :FZF app/services<cr>
map <leader>gx :FZF spec<cr>
map <leader>gz :FZF app/serializers<cr>
map <leader>gg :FZF config<cr>
map <leader>gd :FZF config<cr>

map <leader>w :w<cr>
" let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn|tmp|.idea|DerivedData)$'
" let g:ctrlp_custom_ignore = {
"     \ 'dir':  '\.git$\|\.hg$\|\.svn$\|bower_components$\|dist$\|node_modules$\|project_files$\|test$',
"     \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

" set wildignore+=*/tmp/*,*/.idea/*,*.so,*.swp,*.zip,tags,*.log,*/.idea/*,*/.DS_Store
" :let g:CommandTMaxFiles = 20000
" :let g:CommandTMaxHeight = 10
" :set wildignore+=*.o,*.obj,.git,db/project_b_data/**

" nnoremap <leader><leader> <c-^>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Running tests
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-makegreen binds itself to ,t unless something else is bound to its
" function.
" map <leader>\dontstealmymapsmakegreen :w\|:call MakeGreen('spec')<cr>

function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo
    if filereadable("script/test")
        exec ":!script/test " . a:filename
    else
        exec ":!bundle exec rspec " . a:filename
    end
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_spec_file = match(expand("%"), '_spec.rb$') != -1
    if in_spec_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
:q
:q
"q    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
endfunction

" map <leader>t :call RunTestFile()<cr>
" map <leader>T :call RunNearestTest()<cr>
" map <leader>a :call RunTests('spec')<cr>
"map <leader>c :w\|:!cucumber<cr>
"map <leader>C :w\|:!cucumber --profile wip<cr>

set winwidth=60
" We have to have a winheight bigger than we want to set winminheight. But if
" we set winheight to be huge before winminheight, the winminheight set will
" fail.
set winheight=10
set winminheight=10
set winheight=999


function! ShowColors()
  let num = 255
  while num >= 0
    exec 'hi col_'.num.' ctermbg='.num.' ctermfg=white'
    exec 'syn match col_'.num.' "ctermbg='.num.':...." containedIn=ALL'
    call append(0, 'ctermbg='.num.':....')
    let num = num - 1
  endwhile
endfunction

command! -range Md5 :echo system('echo '.shellescape(join(getline(<line1>, <line2>), '\n')) . '| md5')

" imap <c-l> <space>=><space>

" function! OpenChangedFiles()
"   only " Close all windows, unless they're modified
"   let status = system('git status -s | grep "^ \?\(M\|A\)" | cut -d " " -f 3')
"   let filenames = split(status, "\n")
"   exec "edit " . filenames[0]
"   for filename in filenames[1:]
"     exec "sp " . filename
"   endfor
" endfunction
" command! OpenChangedFiles :call OpenChangedFiles()

" " In these functions, we don't use the count argument, but the map referencing
" " v:count seems to make it work. I don't know why.
" function! ScrollOtherWindowDown(count)
"   normal! 
"   normal! 
"   normal! 
" endfunction
" function! ScrollOtherWindowUp(count)
"   normal! 
"   normal! 
"   normal! 
" endfunction
" nnoremap g<c-y> :call ScrollOtherWindowUp(v:count)<cr>
" nnoremap g<c-e> :call ScrollOtherWindowDown(v:count)<cr>

set shell=bash

" Can't be bothered to understand the difference between ESC and <c-c> in
" insert mode
inoremap <c-c> <esc>

command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<cr>

" DGD: Triying out Flog
" :silent exe "g:flog_enable"
" :silent exe "let g:flog_low_color=#a5c261"
" :silent exe "let g:flog_medium_color=#ffc66d"
" :silent exe "let g:flog_high_color=#cc7833"
" :silent exe "let g:flog_background_color=#323232"
:silent exe "let g:flog_medium_limit=10"
:silent exe "let g:flog_high_limit=20"

" DGD: remap escaped to jk to keep hands on home row
imap jk <esc>
imap kj <C-w>

" DGD: keep swap files off - do I need them?
set noswapfile

" DGD: automatic whitespace removal based on vimtips
autocmd BufWritePre * :%s/\s\+$//e

" DGD: moving more lines
nmap J 5j
nmap K 5k
nmap H 5h
nmap L 5l

" expanding regions
" set iskeyword-=_
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
let g:expand_region_text_objects = {
      \ 'iw'  :0,
      \ 'iW'  :0,
      \ 'i"'  :0,
      \ 'i''' :0,
      \ 'ib'  :1,
      \ 'iB'  :1,
      \ 'il'  :0,
      \ 'ip'  :0,
      \ 'ie'  :0,
      \ }
call expand_region#custom_text_objects('ruby', {
      \ 'im' :0,
      \ 'am' :0,
      \ })

" DGD: compatible text bubbling
"Bubble single lines (kicks butt)
"http://vimcasts.org/episodes/bubbling-text/
nmap <C-k> [e
nmap <C-j> ]e

"Bubble multiple lines
vmap <C-k> [egv
vmap <C-j> ]egv"

"Horizontal bubbling
vnoremap < <gv
vnoremap > >gv

if &term =~ '^screen'
  " tmux will send xterm-style keys when its xterm-keys option is on
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

" vim-tmux navigator
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>
nnoremap <silent> <C-\> :TmuxNavigatePrevious<cr>


" DGD: adding tabularize functionalty from tpope gist
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction
if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
endif

" DGD: adding a bit of autosave - this doesn't work in vim7+
" :au FocusLost * :wa
" :set autowrite
" DGD: makes it easier to move up and down lines
nnoremap j gj
nnoremap k gk

" DGD: support for NERDTree
nmap <silent> <c-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" DGD: incserch
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" DGD: support for easy-motion
hi EasyMotionTarget ctermbg=none ctermfg=red
hi EasyMotionShade  ctermbg=none ctermfg=lightred
hi EasyMotionTarget2First ctermbg=none ctermfg=red
hi EasyMotionTarget2Second ctermbg=none ctermfg=lightred

" let g:EasyMotion_do_mapping " Disable default mappings
" Bi-directional find motion
" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
" nmap s <Plug>(easymotion-s)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
" nmap s <Plug>(easymotion-s2)

" Turn on case sensitive feature
let g:EasyMotion_smartcase = 1
map  <Leader><Leader>f <Plug>(easymotion-bd-w)

" <Leader>f{char} to move to {char}
" map  <Leader>f <Plug>(easymotion-bd-f)
" nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>W <Plug>(easymotion-bd-w)
nmap <Leader>W <Plug>(easymotion-overwin-w)

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

set ttyfast
" set ttyscroll=3
set lazyredraw

" DGD: getting vim-css-color to work with scss
" au BufRead,BufNewFile *.scss set filetype=css
"
" DGD: Trying to make the cursor easier to see:

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

autocmd BufNewFile,BufRead *.hbs set filetype=hbs.html
" let g:snipMate = {}
" let g:snipMate.scope_aliases = {}
" let g:snipMate.scope_aliases['jst.hbs'] = 'html'

"DGD: adding dgd to keywora
" todo: TODO: XXX DGD FIXME: FOO
" syntax keyword myTodo contained BUG REVIEW FIXME FOO TODO DGD NOTE FIXME: DGD:
" syntax keyword potionKeyword FOO DGD NOTE FIXME: DGD:
" autocmd syntax keyword DGD
" syn match   myTodo   contained   "\<\(todo\|fixme\|note\):"
" hi def link myTodo yellow
syn match  coffeeTodo contained   "\<\(FOO\|DGD\):"
" hi def link myTodo Todo


"DGD: axlsx files

au BufNewFile,BufRead *.axlsx setlocal ft=ruby
nmap <leader>v :e ~/.vimrc<CR>

" "DGD: getting ultisnips and youcomplete me
" function! g:UltiSnips_Complete()
"     call UltiSnips#ExpandSnippet()
"     if g:ulti_expand_res == 0
"         if pumvisible()
"             return "\<C-n>"
"         else
"             call UltiSnips#JumpForwards()
"             if g:ulti_jump_forwards_res == 0
"                return "\<TAB>"
"             endif
"         endif
"     endif
"     return ""
" endfunction

" au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
let g:UltiSnipsExpandTrigger="<c-t>"
" let g:UltiSnipsJumpForwardTrigger="<c-b>"
" let g:UltiSnipsJumpBackwardTrigger="<c-t>"
let g:UltiSnipsJumpForwardTrigger="<c-t>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

" TODO: code folding:
set foldmethod=indent
map <leader>zi :setlocal foldmethod=indent<cr>
map <leader>zs :setlocal foldmethod=syntax<cr>
" set foldnestmax=10
" set nofoldenable
set foldlevelstart=99
" set foldlevel=1
" nnoremap <Leader>w :w<CR>

nnoremap <Leader>, za
vnoremap <Leader>, za
nnoremap zO zCzO

"DGD: trailing white space
set listchars=trail:·,precedes:«,extends:»,eol:↲,tab:▸\

"DGD: working with haskell
" Configure browser for haskell_doc.vim
let g:haddock_browser = "open"
let g:haddock_browser_callformat = "%s %s"

nmap <c-w>- :vertical res +20<cr>
nmap <c-w>+ :vertical res -20<cr>
" nnoremap <c-[> <c-w>[
" nnoremap <c-]> <c-w>]

"clipboard
set clipboard=unnamed

"DGD: clojure syntax
"
"DGD: vim-expand-region
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" " Make a simple "search" text object.
" vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
"     \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
" omap s :normal vs<CR>

"DGD: from 12 vim tips on reddit
" NOTE: commenting this out - I want some ignored files searchable (app.yml)
" let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co', 'find %s -type f']
let g:ctrlp_use_caching = 0
let g:ctrlp_show_hidden = 1
"DGD: tagbar
nmap <F8> :TagbarToggle<CR>

"DGD: save on leaving insert
autocmd InsertLeave * write

" "DGD: neocomplete
" " let g:acp_enableAtStartup = 0
" " Use neocomplete.
" let g:neocomplete#enable_at_startup = 1
" " " Use smartcase.
" let g:neocomplete#enable_smart_case = 1
" " " Set minimum syntax keyword length.
" let g:neocomplete#sources#syntax#min_keyword_length = 3
" let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" " " let g:neocomplete#enable_at_startup = 1
" " inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" remapping most common keystrokes
nnoremap <Leader>w :w<CR>

" set timeout for escape length
set timeoutlen=1000 ttimeoutlen=0

" evaluate expressions - a macro
iab <expr> ddate strftime("%Y-%B-%d - %a:")

" automatic spell checking
iabbrev teh the

nmap <silent> <c-t> :TagbarToggle<CR>
" nmap <leader>8 :TagbarToggle<CR>

:iabbrev </ </<C-X><C-O>
imap <C-Space> <C-X><C-O>

"airline or popwerline?
let g:airline_theme='gruvbox'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tmuxline#enabled = 0
let g:airline#extensions#tmuxline#enabled = 1
let g:airline_powerline_fonts=1
let g:tmuxline_separators = {
    \ 'left' : '',
    \ 'left_alt': '>',
    \ 'right' : '',
    \ 'right_alt' : '<',
    \ 'space' : ' '}

" python from powerline.vim import setup as powerline_setup
" python powerline_setup()
" python del powerline_setup
  set rtp+=/usr/local/opt/fzf
