"highlighting search"
" set hls

" set hi colors
syntax enable
set termguicolors
:set t_Co=256 " 256 colors
" :set background=dark
:set background=light
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
" :colorscheme embark
" :colorscheme gruvbox8_soft
" :colorscheme lucius

" let g:airline_theme='solarized'
" let g:airline_theme='base_16_gruvbox_dark_hard'

let g:gruvbox_invert_selection=0
let g:gruvbox_contrast_dark = "soft"
" let g:gruvbox_contrast_light = "medium"

:hi Visual ctermbg=darkgray guibg=black

" highlight SignColumn ctermbg=lightgrey
" highlight LineNr ctermfg=darkgreen ctermbg=lightgrey
highlight VertSplit ctermfg=white ctermbg=darkgreen
" highlight current line
:set cursorline
" :hi CursorLine ctermbg=darkgrey guibg=black

highlight HighlightedyankRegion cterm=reverse gui=reverse
let g:highlightedyank_highlight_duration = 300

" highlight current column
" :set cc=80
call matchadd('ColorColumn', '\%81v', '100')
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
