" for deoplete support
"
let g:deoplete#enable_at_startup = 1
if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif
" let g:deoplete#disable_auto_complete = 1
" autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

let deoplete#tag#cache_limit_size = 20000000
" let g:deoplete#sources = {}
" let g:deoplete#sources._ = ['buffer', 'tag']


" " tern
" if exists('g:plugs["tern_for_vim"]')
"   let g:tern_show_argument_hints = 'on_hold'
"   let g:tern_show_signature_in_pum = 1
"   autocmd FileType javascript setlocal omnifunc=tern#Complete
" endif

" " deoplete tab-complete
" inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" tern
autocmd FileType javascript nnoremap <silent> <buffer> gb :TernDef<CR>
autocmd FileType typescript setlocal formatprg=prettier\ --parser\ typescript

" neomake
let g:neomake_open_list=0
let g:jsx_ext_required = 0
" let g:neomake_list_height = 2
" let g:neomake_open_list = 2
" let g:neomake_verbose = 3
let g:neomake_jsx_enabled_makers = ['eslint']
let g:neomake_javascript_eslint_exe = './node_modules/.bin/eslint'
let g:neomake_javascript_enabled_makers = ['eslint']
autocmd! BufWritePost *.js silent! Neomake

"""""""""""""""""""""""""""""""""""""""
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

" Use <c-h> for snippets
" let g:NERDSnippets_key = '<c-h>'

" DGD: better erb snippet support
" autocmd BufNewFile,BufRead *.html.erb set filetype=html.eruby
"
" DGD: Triying out Flog
" :silent exe "g:flog_enable"
" :silent exe "let g:flog_low_color=#a5c261"
" :silent exe "let g:flog_medium_color=#ffc66d"
" :silent exe "let g:flog_high_color=#cc7833"
" :silent exe "let g:flog_background_color=#323232"
:silent exe "let g:flog_medium_limit=10"
:silent exe "let g:flog_high_limit=20"

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

" DGD: support for NERDTree
nmap <silent> <c-n> :NERDTreeToggle<CR>
" nnoremap <silent> <c-l> :NERDTREEWinSize=50<CR>
" nmap <silent> <c-m> :NERDTreeWinSize=50<CR>
let NERDTreeShowHidden=1
map <leader>r :NERDTreeFind<cr>

" DGD: incserch
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" " DGD: support for easy-motion
" hi EasyMotionTarget ctermbg=none ctermfg=red
" hi EasyMotionShade  ctermbg=none ctermfg=lightred
" hi EasyMotionTarget2First ctermbg=none ctermfg=red
" hi EasyMotionTarget2Second ctermbg=none ctermfg=lightred

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


" DGD: getting vim-css-color to work with scss
" au BufRead,BufNewFile *.scss set filetype=css
"
autocmd BufNewFile,BufRead *.hbs set filetype=hbs.html

" ultisnips
" let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsJumpForwardTrigger="<c-t>"
" let g:UltiSnipsJumpBackwardTrigger="<c-b>"
" look at coc-snippets in coc.vimrc

"DGD: working with haskell
" Configure browser for haskell_doc.vim
let g:haddock_browser = "open"
let g:haddock_browser_callformat = "%s %s"

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

"airline or popwerline?
" let g:airline_theme='gruvbox'
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

let g:python_host_prog = '$HOME/.pyenv/shims/python2'
let g:python2_host_prog = '$HOME/.pyenv/shims/python2'
let g:python3_host_prog = '$HOME/.pyenv/shims/python3'

" vim-coffee-script
autocmd BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab

"coc vim
"coc-prettier
" command! -nargs=0 Prettier :CocCommand prettier.formatFile
let g:prettier#config#single_quote = 'true'

" language servers
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>


" ack.vim using the_silver_searcher
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>

"dadbod ui
let g:db_ui_save_location = '~/dev/project_b/db/sql'
