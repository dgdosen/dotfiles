let g:LanguageClient_useFloatingHover=1
let g:LanguageClient_hoverPreview='Always'
let g:LanguageClient_diagnosticsDisplay={
      \   1: {'signTexthl': 'LineNr', 'virtualTexthl': 'User8'},
      \   2: {'signTexthl': 'LineNr', 'virtualTexthl': 'User8'},
      \   3: {'signTexthl': 'LineNr', 'virtualTexthl': 'User8'},
      \   4: {'signTexthl': 'LineNr', 'virtualTexthl': 'User8'},
      \ }

let g:LanguageClient_serverCommands={}

if exists('$DEBUG_LC_LOGFILE')
  let g:LanguageClient_loggingFile=$DEBUG_LC_LOGFILE
  let g:LanguageClient_loggingLevel='DEBUG'
endif

if executable('typescript-language-server')
  " ie. via `npm install -g typescript-language-server`
  if exists('$DEBUG_LSP_LOGFILE')
    let s:debug_args=[
          \   '--log-level=4',
          \   '--tsserver-log-file',
          \   $DEBUG_LSP_LOGFILE,
          \   '--tsserver-log-verbosity=verbose'
          \ ]
  else
    let s:debug_args=[]
  endif


  let s:ts_lsp=extend([exepath('typescript-language-server'), '--stdio'], s:debug_args)
elseif executable('javascript-typescript-stdio')
  " ie. via `npm install -g javascript-typescript-langserver`
  if exists('$DEBUG_LSP_LOGFILE')
    let s:debug_args=['--trace', '--logfile', $DEBUG_LSP_LOGFILE]
  else
    let s:debug_args=[]
  endif

  let s:ts_lsp=extend([exepath('javascript-typescript-stdio')], s:debug_args)
else
  let s:ts_lsp=[]
endif

" From `npm install -g flow-bin`:
let s:flow_lsp=executable('flow') ?
      \ [exepath('flow'), 'lsp'] :
      \ []

let s:ts_filetypes=[
      \   'typescript',
      \   'typescript.tsx',
      \   'typescript.jest',
      \   'typescript.jest.tsx'
      \ ]

let s:js_filetypes=[
      \   'javascript',
      \   'javascript.jsx',
      \   'javascript.jest',
      \   'javascript.jest.jsx'
      \ ]

let g:LanguageClient_rootMarkers={}

if s:ts_lsp != []
  for s:ts_filetype in s:ts_filetypes
    let g:LanguageClient_rootMarkers[s:ts_filetype] = ['tsconfig.json', '.flowconfig', 'package.json']
    let g:LanguageClient_serverCommands[s:ts_filetype]=s:ts_lsp
  endfor
endif

if s:ts_lsp != [] && filereadable('tsconfig.json')
  let s:js_lsp=s:ts_lsp
elseif s:flow_lsp != [] && filereadable('.flowconfig')
  let s:js_lsp=s:flow_lsp
elseif s:ts_lsp != []
  let s:js_lsp=s:ts_lsp
endif

if exists('s:js_lsp')
  for s:js_filetype in s:js_filetypes
    let g:LanguageClient_rootMarkers[s:js_filetype] = ['tsconfig.json', '.flowconfig', 'package.json']
    let g:LanguageClient_serverCommands[s:js_filetype]=s:js_lsp
  endfor
endif

if executable('ocaml-language-server')
  let s:ocaml_lsp=[exepath('ocaml-language-server')]
  let g:LanguageClient_serverCommands['reason']=s:ocaml_lsp
  let g:LanguageClient_serverCommands['ocaml']=s:ocaml_lsp
endif

let g:LanguageClient_diagnosticsList='Location'

let g:python3_host_prog = "/Users/ddosen/.pyenv/shims/python"
let g:deoplete#enable_at_startup = 1
