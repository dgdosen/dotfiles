" csv viles
if exists("did_load_csvfiletype")
  finish
endif

" markdown filetype file
if exists("did\_load\_filetypes")
 finish
endif

let did_load_csvfiletype=1
augroup markdown

    au! BufRead,BufNewFile *.mkd   setfiletype mkd
    au! BufRead,BufNewFile *.markdown   setfiletype mkd

augroup filetypedetect
  au! BufRead,BufNewFile *.csv,*.dat	setfiletype csv

augroup END
