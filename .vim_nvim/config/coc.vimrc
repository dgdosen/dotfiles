" coc config
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-tsserver',
  \ 'coc-prettier',
  \ 'coc-json',
  \ 'coc-emmet',
  \ 'coc-tslint'
  \ ]

" coc influence:
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

autocmd FileType json syntax match Comment +\/\/.\+$+
 " TODO: will nobackup mean these are obsolete?
