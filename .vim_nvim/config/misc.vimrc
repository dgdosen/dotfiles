augroup myfiletypes
  "clear old autocmds in group
  autocmd!
  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType python set sw=2 sts=2 et
augroup END

set switchbuf=useopen

autocmd BufRead,BufNewFile *.html source ~/.vim/indent/html_grb.vim
autocmd FileType htmldjango source ~/.vim/indent/html_grb.vim

autocmd! BufRead,BufNewFile *.sass setfiletype sass

map <leader>o :only <cr>

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

" :au WinEnter * :setlocal number
" :au WinLeave * :setlocal nonumber
if has("gui_running")
    " source ~/proj/vim-complexity/repo/complexity.vim
endif

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

" let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn|tmp|.idea|DerivedData)$'
" let g:ctrlp_custom_ignore = {
"     \ 'dir':  '\.git$\|\.hg$\|\.svn$\|bower_components$\|dist$\|node_modules$\|project_files$\|test$',
"     \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

" set wildignore+=*/tmp/*,*/.idea/*,*.so,*.swp,*.zip,tags,*.log,*/.idea/*,*/.DS_Store
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
"
"

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


command! -range Md5 :echo system('echo '.shellescape(join(getline(<line1>, <line2>), '\n')) . '| md5')

" imap <c-l> <space>=><space>

" function! OpenChangedFiles()
"   only " Close all windows, unless they're modified
"   let status = system('git status -s | grep "^ \?\(M\|A\)" | cut -d " " -f 3')
"   let filenames = split(status, "\n")
"   exec "edit " . filenames[0]
"   for filename in filenames[1:]
"     exec "sp " . filename
"   endfor
" endfunction
" command! OpenChangedFiles :call OpenChangedFiles()

" " In these functions, we don't use the count argument, but the map referencing
" " v:count seems to make it work. I don't know why.
" function! ScrollOtherWindowDown(count)
"   normal! 
"   normal! 
"   normal! 
" endfunction
" function! ScrollOtherWindowUp(count)
"   normal! 
"   normal! 
"   normal! 
" endfunction
" nnoremap g<c-y> :call ScrollOtherWindowUp(v:count)<cr>
" nnoremap g<c-e> :call ScrollOtherWindowDown(v:count)<cr>

" set shell=bash


" Can't be bothered to understand the difference between ESC and <c-c> in
" insert mode
inoremap <c-c> <esc>

" expanding regions
set iskeyword-=_
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
let g:expand_region_text_objects = {
      \ 'iw'  :0,
      \ 'iW'  :0,
      \ 'i"'  :0,
      \ 'i''' :0,
      \ 'ib'  :1,
      \ 'iB'  :1,
      \ 'il'  :0,
      \ 'ip'  :0,
      \ 'ie'  :0,
      \ }
call expand_region#custom_text_objects('ruby', {
      \ 'im' :0,
      \ 'am' :0,
      \ })



if &term =~ '^screen'
  " tmux will send xterm-style keys when its xterm-keys option is on
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

