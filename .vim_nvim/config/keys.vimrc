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


" Seriously, guys. It's not like :W is bound to anything anyway.
command! W :w

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

" DGD: adding a bit of autosave - this doesn't work in vim7+
" :au FocusLost * :wa
" :set autowrite
" DGD: makes it easier to move up and down lines
nnoremap j gj
nnoremap k gk

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


nmap <c-w>- :vertical res +20<cr>
nmap <c-w>+ :vertical res -20<cr>
" nnoremap <c-[> <c-w>[
" nnoremap <c-]> <c-w>]

"clipboard
set clipboard=unnamed

" evaluate expressions - a macro
iab <expr> ddate strftime("%Y-%B-%d - %a:")

" automatic spell checking
iabbrev teh the

nmap <silent> <c-t> :TagbarToggle<CR>
" nmap <leader>8 :TagbarToggle<CR>

:iabbrev </ </<C-X><C-O>
imap <C-Space> <C-X><C-O>


command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<cr>

syn match  coffeeTodo contained   "\<\(FOO\|DGD\):"


au BufNewFile,BufRead *.axlsx setlocal ft=ruby
nmap <leader>v :e ~/.vim/init.vim<CR>
