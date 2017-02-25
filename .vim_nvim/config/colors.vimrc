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

function! ShowColors()
  let num = 255
  while num >= 0
    exec 'hi col_'.num.' ctermbg='.num.' ctermfg=white'
    exec 'syn match col_'.num.' "ctermbg='.num.':...." containedIn=ALL'
    call append(0, 'ctermbg='.num.':....')
    let num = num - 1
  endwhile
endfunction