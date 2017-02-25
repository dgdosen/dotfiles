call plug#begin('~/.vim_nvim/plugged')

" Make sure you use single quotes
Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
Plug 'Shougo/deoplete.nvim'
Plug 'rhysd/vim-crystal'
Plug 'neomake/neomake'

" react development
" Plug 'mtscout6/syntastic-local-eslint.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

" unsorted migration
Plug 'kchmck/vim-coffee-script'
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-cucumber'
Plug 'Lokaltog/vim-easymotion'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'nono/vim-handlebars'
Plug 'claco/jasmine.vim'
Plug 'tpope/vim-markdown'
Plug 'vim-scripts/ruby-matchit'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-repeat'
Plug 'vim-ruby/vim-ruby'
Plug 'sunaku/vim-ruby-minitest'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-unimpaired'
Plug 'ervandew/supertab'
Plug 'vim-scripts/L9'
Plug 'tpope/vim-ragtag'
Plug 'bronson/vim-trailing-whitespace'
Plug 'tpope/vim-haml'
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-classpath'
Plug 'guns/vim-clojure-static'
Plug 'mattn/webapi-vim'
Plug 'jgdavey/vim-railscasts'
Plug 'moll/vim-node'
Plug 'tpope/vim-fireplace'
Plug 'guns/vim-clojure-highlight'
Plug 'ecomba/vim-ruby-refactoring'
Plug 'terryma/vim-expand-region'
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
Plug 'bling/vim-airline'
Plug 'tpope/vim-leiningen'
Plug 'tpope/vim-dispatch'
Plug 'PProvost/vim-markdown-jekyll'
Plug 'tpope/vim-liquid'
Plug 'airblade/vim-gitgutter'
Plug 'rking/ag.vim'
Plug 'Keithbsmiley/swift.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-obsession'
Plug 'jlanzarotta/bufexplorer'
Plug 'fatih/vim-go'
Plug 'rust-lang/rust.vim'
Plug 'NHDaly/tmux-scroll-copy-mode'
Plug 'chriskempson/base16-vim'
Plug 'romainl/Apprentice'
Plug 'vim-scripts/Sorcerer'
Plug 'haya14busa/incsearch.vim'
Plug 'morhetz/gruvbox'
Plug 'jonathanfilip/vim-lucius'
Plug 'tpope/vim-jdaddy'
Plug 'christoomey/vim-sort-motion'
Plug 'ryanoasis/vim-devicons'
Plug 'ekalinin/Dockerfile.vim'
Plug 'mattn/gist-vim'
Plug 'elixir-lang/vim-elixir'

" segregated vim only?
" Plug 'Shougo/neocomplete'


" " Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
" Plug 'junegunn/vim-easy-align'

" " Any valid git URL is allowed
" Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" " Group dependencies, vim-snippets depends on ultisnips
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" " On-demand loading
" Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" " Using a non-master branch
" Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" " Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
" Plug 'fatih/vim-go', { 'tag': '*' }

" " Plugin options
" Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'

" " Unmanaged plugin (manually installed and updated)
" Plug '~/my-prototype-plugin'

" Add plugins to &runtimepath
call plug#end()

