call plug#begin('~/.vim_nvim/plugged')

" Language Server Protocol:

" CONFIG for LanugageServer and Depolote
" if has('nvim')
"   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
"   Plug 'Shougo/deoplete.nvim'
"   Plug 'Shougo/denite.nvim'
"   Plug 'roxma/nvim-yarp'
"   Plug 'roxma/vim-hug-neovim-rpc'
" endif
" let g:python3_host_prog = "/Users/ddosen/.pyenv/shims/python3"
" let g:deoplete#enable_at_startup = 1

" Plug 'prettier/vim-prettier', {
"   \ 'do': 'yarn install',
"   \ 'branch': 'release/1.x',
"   \ 'for': [
"     \ 'javascript',
"     \ 'typescript',
"     \ 'css',
"     \ 'less',
"     \ 'scss',
"     \ 'json',
"     \ 'graphql',
"     \ 'markdown',
"     \ 'vue',
"     \ 'lua',
"     \ 'php',
"     \ 'python',
"     \ 'ruby',
"     \ 'html',
"     \ 'swift' ] }
" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }

" CONFIG for coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'neoclide/coc-denite'
" Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
" END Language Server Protocol:


" Plug 'xolox/vim-easytags'
" tags
" Plug 'ludovicchabant/vim-gutentags'

" colorschemes
" Plug 'vim-airline/vim-airline-themes'
" Plug 'romainl/Apprentice'
" Plug 'chriskempson/base16-vim'
Plug 'gruvbox-community/gruvbox'
Plug 'skbolton/embark'
" Plug 'lifepillar/vim-gruvbox8'
" Plug 'quanganhdo/grb256'
" Plug 'jonathanfilip/vim-lucius'
" Plug 'jgdavey/vim-railscasts'
" Plug 'altercation/vim-colors-solarized'
" Plug 'vim-scripts/Sorcerer'

" env
Plug 'tpope/vim-dotenv'

" visual mode yank
Plug 'machakann/vim-highlightedyank'

" general
Plug 'tpope/vim-repeat'
Plug 'vim-scripts/L9'
" Plug 'ervandew/supertab'
Plug 'chrisbra/csv.vim'
Plug 'mattn/webapi-vim'
Plug 'vim-airline/vim-airline'
Plug 'PProvost/vim-markdown-jekyll'
Plug 'tpope/vim-liquid'
Plug 'mattn/gist-vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ekalinin/Dockerfile.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'jlanzarotta/bufexplorer'
Plug 'airblade/vim-gitgutter'
Plug 'mileszs/ack.vim'
Plug 'tpope/vim-obsession'

Plug 'tpope/vim-dispatch'

"os/git manageemnt
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-eunuch'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'moll/vim-node'

" editing
" " Group dependencies, vim-snippets depends on ultisnips
" Plug 'https://github.com/junegunn/vim-github-dashboard.git'
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'vimwiki/vimwiki'
" Plug 'junegunn/fzf'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'michal-h21/vim-zettel'
Plug 'tpope/vim-commentary'
Plug 'Lokaltog/vim-easymotion'
Plug 'christoomey/vim-sort-motion'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-unimpaired'
Plug 'bronson/vim-trailing-whitespace'
Plug 'terryma/vim-expand-region'
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'NHDaly/tmux-scroll-copy-mode'
Plug 'haya14busa/incsearch.vim'
Plug 'junegunn/vim-easy-align'
Plug 'nathanaelkane/vim-indent-guides'
" Plug 'elzr/vim-json'
"" languages
Plug 'tpope/vim-haml'
" Plug 'jerrymarino/SwiftPlayground.vim'
" clojure
" Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
" Plug 'tpope/vim-classpath', { 'for': 'clojure' }
" Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
" Plug 'guns/vim-clojure-highlight', { 'for': 'clojure' }
" Plug 'tpope/vim-leiningen', { 'for': 'clojure' }
" crystal
Plug 'rhysd/vim-crystal'
" go
Plug 'fatih/vim-go', { 'tag': '*' }
" elixir
Plug 'elixir-lang/vim-elixir'
" html
Plug 'mattn/emmet-vim'
Plug 'othree/html5.vim'
Plug 'hail2u/vim-css3-syntax'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'tpope/vim-ragtag'
" javascript
" Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
Plug 'ternjs/tern_for_vim', { 'for': ['javascript', 'javascript.jsx'] }

Plug 'kchmck/vim-coffee-script'
Plug 'mustache/vim-mustache-handlebars'
Plug 'nono/vim-handlebars'
Plug 'tpope/vim-jdaddy'
Plug 'isRuslan/vim-es6'
" ocaml
Plug 'let-def/ocp-indent-vim'

Plug 'Quramy/vim-dtsm'
Plug 'Quramy/tsuquyomi'
" Plug 'isagalaev/highlight.js'
" Plug 'mxw/vim-jsx'
" Plug 'pangloss/vim-javascript'
" ruby
" Plug 'tpope/vim-endwise'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-rake'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/ruby-matchit'
Plug 'ecomba/vim-ruby-refactoring'
" rust
Plug 'rust-lang/rust.vim'
"swift
Plug 'Keithbsmiley/swift.vim'
" elm
Plug 'ElmCast/elm-vim'
" graphql
Plug 'jparise/vim-graphql'
" sql
Plug 'ivalkeen/vim-simpledb'
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
" testing
Plug 'tpope/vim-cucumber'
Plug 'sunaku/vim-ruby-minitest'
Plug 'claco/jasmine.vim'
" vue js
Plug 'posva/vim-vue'
" java - yes java
Plug 'artur-shaik/vim-javacomplete2'

" ethereum
Plug 'tomlion/vim-solidity'

" typescript tslint linting
" Plug 'vim-syntastic/syntastic'1a
Plug 'leafgarland/typescript-vim'
Plug 'ianks/vim-tsx'

" Plug 'mtscout6/syntastic-local-eslint.vim'
" Plug 'w0rp/ale'
" Plug 'HerringtonDarkholme/yats.vim'
" Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
Plug 'neomake/neomake'


call plug#end()

" CONFIG for LanugageServer and Depolote
" source $HOME/.config/nvim/config/language.vimrc

" CONFIG for coc
source $HOME/.config/nvim/config/coc.vimrc

