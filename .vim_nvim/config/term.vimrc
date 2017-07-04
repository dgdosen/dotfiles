
" longer buffers!
let g:terminal_scrollback_buffer_size = 100000

" map to get out of terminal mode
" tnoremap <A-x> <C-\><C-n>
tnoremap <Esc> <C-\><C-n>
tnoremap <C-a> <C-\><C-n>

tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l

autocmd BufEnter term://* startinsert
