" coc config
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint',
  \ 'coc-prettier',
  \ 'coc-json',
  \ ]

" coc influence:
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" TODO: will nobackup mean these are obsolete?
