call plug#begin('~/.vim_nvim/plugged')

" nvim specific
Plug 'Shougo/deoplete.nvim'
Plug 'neomake/neomake'

" colorschemes
Plug 'romainl/Apprentice'
Plug 'chriskempson/base16-vim'
Plug 'morhetz/gruvbox'
Plug 'jonathanfilip/vim-lucius'
Plug 'jgdavey/vim-railscasts'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-scripts/Sorcerer'

" general
Plug 'tpope/vim-repeat'
Plug 'vim-scripts/L9'
Plug 'ervandew/supertab'
Plug 'mattn/webapi-vim'
Plug 'bling/vim-airline'
Plug 'PProvost/vim-markdown-jekyll'
Plug 'tpope/vim-liquid'
Plug 'mattn/gist-vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ekalinin/Dockerfile.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'jlanzarotta/bufexplorer'
Plug 'airblade/vim-gitgutter'
Plug 'rking/ag.vim'
Plug 'tpope/vim-obsession'

" linting
" Plug 'vim-syntastic/syntastic'
" Plug 'w0rp/ale'
Plug 'tpope/vim-dispatch'

"os/git manageemnt
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-eunuch'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'moll/vim-node'

" editing
" " Group dependencies, vim-snippets depends on ultisnips
" Plug 'https://github.com/junegunn/vim-github-dashboard.git'
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'Lokaltog/vim-easymotion'
Plug 'christoomey/vim-sort-motion'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-unimpaired'
Plug 'bronson/vim-trailing-whitespace'
Plug 'terryma/vim-expand-region'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'NHDaly/tmux-scroll-copy-mode'
Plug 'haya14busa/incsearch.vim'
Plug 'junegunn/vim-easy-align'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'elzr/vim-json'
"" languages
Plug 'tpope/vim-haml'
" clojure
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'tpope/vim-classpath', { 'for': 'clojure' }
Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
Plug 'guns/vim-clojure-highlight', { 'for': 'clojure' }
Plug 'tpope/vim-leiningen', { 'for': 'clojure' }
" crystal
Plug 'rhysd/vim-crystal'
" go
Plug 'fatih/vim-go', { 'tag': '*' }
" elixir
Plug 'elixir-lang/vim-elixir'
" html
Plug 'othree/html5.vim'
Plug 'hail2u/vim-css3-syntax'
Plug 'tpope/vim-ragtag'
" javascript
" Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
Plug 'ternjs/tern_for_vim', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'kchmck/vim-coffee-script'
Plug 'mustache/vim-mustache-handlebars'
Plug 'nono/vim-handlebars'
Plug 'tpope/vim-jdaddy'
Plug 'isRuslan/vim-es6'
" Plug 'mtscout6/syntastic-local-eslint.vim'
" Plug 'isagalaev/highlight.js'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
" ruby
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/ruby-matchit'
Plug 'ecomba/vim-ruby-refactoring'
" rust
Plug 'rust-lang/rust.vim'
"swift
Plug 'Keithbsmiley/swift.vim'

" testing
Plug 'tpope/vim-cucumber'
Plug 'sunaku/vim-ruby-minitest'
Plug 'claco/jasmine.vim'

call plug#end()
