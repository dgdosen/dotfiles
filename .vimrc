set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/vim-vundle/
call vundle#begin()
" alternatively, pass a path where Vundle should install bundles
"let path = '~/some/path/here'

" let Vundle manage Vundle, required
Plugin '~/.vim/bundle/vundle'
Plugin '~/.vim/bundle/vim-server-ultisnips'
Plugin '~/.vim/bundle/vim-snippets'
Plugin '~/.vim/bundle/vim-youcompleteme'
call vundle#end()

filetype plugin indent on     " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install (update) bundles
" :BundleSearch(!) foo - search (or refresh cache first) for foo
" :BundleClean(!)      - confirm (or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle commands are not allowed.
" Put your stuff after this line
set completeopt-=preview

" end vundle...

runtime bundles/tplugin_vim/macros/tplugin.vim
" set TPlugin! tlib_vim 02tlib
" runtime bundles/vim-tlib/macros/tplugin.vim
call pathogen#infect()
call pathogen#helptags()

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

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

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
" vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  " set guifont=Monaco:h14
  set guifont=Inconsolata-dz:h14
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")


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

" GRB: Highlight long lines
" Turn long-line highlighting off when entering all files, then on when
" entering certain files. I don't understand why :match is so stupid that
" setting highlighting when entering a .rb file will cause e.g. a quickfix
" window opened later to have the same match. There doesn't seem to be any way
" to localize it to a file type.
" function! HighlightLongLines()
"   hi LongLine guifg=NONE guibg=NONE gui=undercurl ctermfg=white ctermbg=red cterm=NONE guisp=#FF6C60 " undercurl color
" endfunction
" function! StopHighlightingLongLines()
"   hi LongLine guifg=NONE guibg=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guisp=NONE
" endfunction
" autocmd TabEnter,WinEnter,BufWinEnter * call StopHighlightingLongLines()
" autocmd TabEnter,WinEnter,BufWinEnter *.rb,*.py call HighlightLongLines()
" hi LongLine guifg=NONE
" match LongLine '\%>78v.\+'

" GRB: highlighting search"
set hls

if has("gui_running")
  " GRB: set font"
  ":set nomacatsui anti enc=utf-8 gfn=Monaco:h12

  " GRB: set window size"
  :set lines=100
  :set columns=171

  " GRB: highlight current line"
  " :set cursorline
endif

" GRB: set the color scheme
" solarized options
syntax enable
" :let g:solarized_termcolors
" :let g:solarized_termcolors = 256
" :let g:solarized_visibility = "high"
" :let g:solarized_contrast = "high"
:set t_Co=256 " 256 colors
" :set background=dark
" :set background=light
" :color grb256
" :color solarized
" :color codeschool
" :color railscasts
" :color github
" :colorscheme railscasts_jpo
" :colorscheme railscasts_dgd
" :colorscheme railscasts
" :colorscheme solarized
:colorscheme grb256

" GRB: hide the toolbar in GUI mode
if has("gui_running")
    set go-=T
end

" GRB: add pydoc command
:command! -nargs=+ Pydoc :call ShowPydoc("<args>")
function! ShowPydoc(module, ...)
    let fPath = "/tmp/pyHelp_" . a:module . ".pydoc"
    :execute ":!pydoc " . a:module . " > " . fPath
    :execute ":sp ".fPath
endfunction

" GRB: use emacs-style tab completion when selecting files, etc
" set wildmode=longest,list

" GRB: Put useful info in status line
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
:hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red

" GRB: clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<cr>

function! RedBar()
    hi RedBar ctermfg=white ctermbg=red guibg=red
    echohl RedBar
    echon repeat(" ",&columns - 1)
    echohl
endfunction

function! GreenBar()
    hi GreenBar ctermfg=white ctermbg=green guibg=green
    echohl GreenBar
    echon repeat(" ",&columns - 1)
    echohl
endfunction

" function! JumpToTestsForClass()
"     exec 'e ' . TestFileForCurrentClass()
" endfunction

let mapleader=","
" let mapleader="\<Space>"

" highlight current line
set cursorline

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
  autocmd FileType python set sw=4 sts=4 et
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
map <leader>f :CtrlP<cr>
map <leader>gj :CtrlP app/assets/javascripts<cr>
map <leader>gy :CtrlP app/assets/stylesheets<cr>
map <leader>gm :CtrlP app/models<cr>
map <leader>gc :CtrlP app/controllers<cr>
map <leader>gv :CtrlP app/views<cr>
map <leader>gs :CtrlP app/services<cr>
map <leader>gk :CtrlP spec<cr>
map <leader>gg :CtrlP config<cr>
map <leader>gd :CtrlP config<cr>

map <leader>w :w<cr>
let g:ctrlp_custom_ignore = "tmp"
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,tags,*.log
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

nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
nnoremap <c-n> :let &wh = (&wh == 999 ? 10 : 999)<CR><C-W>=

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

function! OpenChangedFiles()
  only " Close all windows, unless they're modified
  let status = system('git status -s | grep "^ \?\(M\|A\)" | cut -d " " -f 3')
  let filenames = split(status, "\n")
  exec "edit " . filenames[0]
  for filename in filenames[1:]
    exec "sp " . filename
  endfor
endfunction
command! OpenChangedFiles :call OpenChangedFiles()

if &diff
  nmap <c-h> :diffget 1<cr>
  nmap <c-l> :diffget 3<cr>
  nmap <c-k> [cz.
  nmap <c-j> ]cz.
  set nonumber
endif

" In these functions, we don't use the count argument, but the map referencing
" v:count seems to make it work. I don't know why.
function! ScrollOtherWindowDown(count)
  normal! 
  normal! 
  normal! 
endfunction
function! ScrollOtherWindowUp(count)
  normal! 
  normal! 
  normal! 
endfunction
nnoremap g<c-y> :call ScrollOtherWindowUp(v:count)<cr>
nnoremap g<c-e> :call ScrollOtherWindowDown(v:count)<cr>

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

" DGD: additions
imap jj <esc>

" DGD: keep swap files off - do I need them?
set noswapfile

" DGD: whitespace removal (I hate that!)
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" DGD: moving more lines
nmap J 10j
nmap K 10k
nmap H 10h
nmap L 10l

" DGD: compatible text bubbling
"Bubble single lines (kicks butt)
"http://vimcasts.org/episodes/bubbling-text/
nmap <C-Up> ddkP
nmap <C-Down> ddp
nmap <C-Left> <<
nmap <C-Right> >>

"Horizontal bubbling
vnoremap < <gv
vnoremap > >gv

"Keep selection
nmap gV `[v`]

"Bubble multiple lines
vmap <C-Up> xkP`[V`]
vmap <C-Down> xp`[V`]
vmap <C-Right> >gv
vmap <C-Left> <gv

if &term =~ '^screen'
  " tmux will send xterm-style keys when its xterm-keys option is on
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif


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

" DGD: Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" DGD: support for NERDTree
nmap <silent> <c-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" DGD: support for easy-motion
" let g:EasyMotion_mapping_w = 'f'
" let g:EasyMotion_mapping_b = 'F'
" let g:EasyMotion_leader_key='<leader>m'
hi EasyMotionTarget ctermbg=none ctermfg=red
hi EasyMotionShade  ctermbg=none ctermfg=green
hi EasyMotionTarget2First ctermbg=none ctermfg=red
hi EasyMotionTarget2Second ctermbg=none ctermfg=lightred

" let g:EasyMotion_do_mapping " Disable default mappings
" Bi-directional find motion
" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-s)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
" nmap s <Plug>(easymotion-s2)

" Turn on case sensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

set ttyfast

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
highlight Search ctermbg=red ctermfg=black

autocmd BufNewFile,BufRead *.hbs set filetype=hbs.html
" let g:snipMate = {}
" let g:snipMate.scope_aliases = {}
" let g:snipMate.scope_aliases['jst.hbs'] = 'html'

"DGD: adding dgd to keyword
" highlight DGD ErrorMsg
syn match   myTodo   contained   "\<\(TODO\|FIXME\|NOTE\):"
hi def link myTodo Todo
"DGD: axlsx files

au BufNewFile,BufRead *.axlsx setlocal ft=ruby
nmap <leader>v :e ~/.vimrc<CR>

"DGD: getting ultisnips and youcomplete me
function! g:UltiSnips_Complete()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 0
        if pumvisible()
            return "\<C-n>"
        else
            call UltiSnips#JumpForwards()
            if g:ulti_jump_forwards_res == 0
               return "\<TAB>"
            endif
        endif
    endif
    return ""
endfunction

" au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
" let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsListSnippets="<c-e>"
let g:UltiSnipsExpandTrigger="<c-t>"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

" TODO: code folding:
set foldmethod=indent
map <leader>zi :setlocal foldmethod=indent<cr>
map <leader>zs :setlocal foldmethod=syntax<cr>
" set foldnestmax=10
set nofoldenable
set foldlevelstart=99
" set foldlevel=1
nnoremap <Space> za
vnoremap <Space> za
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

" column width stuff:
:set cc=80
:hi ColorColumn ctermbg=darkgrey guibg=lightgrey
"
"DGD: rainbow parens for cloure
" :RainbowParenthesesToggle
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound

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
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
let g:ctrlp_use_caching = 0
let g:ctrlp_show_hidden = 1
"DGD: tagbar
nmap <F8> :TagbarToggle<CR>

"DGD: save on leaving insert
autocmd InsertLeave * write

"DGD: neocomplete
" let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" " Use smartcase.
" let g:neocomplete#enable_smart_case = 1
" " Set minimum syntax keyword length.
" let g:neocomplete#sources#syntax#min_keyword_length = 3
" let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" " let g:neocomplete#enable_at_startup = 1
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
