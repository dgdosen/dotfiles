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
  au! BufRead,BufNewFile *.csv,*.dat,*.1,*.2,*.3,*.4,*.5,*.6,*.CHT,*.DRF,*.DR2,*.DR3,*.DR4	setfiletype csv

augroup END
