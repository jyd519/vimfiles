"--------------------------------------------------------------------------------
" vim-plug
"--------------------------------------------------------------------------------
if empty(glob($VIMFILES . '/autoload/plug.vim'))
  silent !curl -fLo $VIMFILES/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('$VIMFILES/plugged')

Plug 'mhinz/vim-startify'

if g:is_nvim
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'Mofiqul/vscode.nvim'
  Plug 'marko-cerovac/material.nvim'
else
  Plug 'NLKNguyen/papercolor-theme'
endif

" efficient editing
Plug 'jyd519/ListToggle'          " toggle quickfix/location window
Plug 'vim-scripts/bufkill.vim'
" Plug 'easymotion/vim-easymotion'  " slow
Plug 'justinmk/vim-sneak'
Plug 'mattn/emmet-vim', { 'for': ['html', 'jsx', 'vue'] }
Plug 'jiangmiao/auto-pairs'
Plug 'tmhedberg/matchit'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

" Unit-Testing
Plug 'vim-test/vim-test'

Plug 'chiedojohn/vim-case-convert'
Plug 'thinca/vim-quickrun'
Plug 'puremourning/vimspector'

Plug 'preservim/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'wesleyche/SrcExpl', { 'on': 'SrcExpl' }

Plug 'dense-analysis/ale'

" Plug 'xolox/vim-easytags'
" Plug 'ludovicchabant/vim-gutentags'
Plug 'brookhong/cscope.vim'
" Plug 'nathanaelkane/vim-indent-guides'
Plug 'jyd519/a.vim', { 'on': ['A', 'AS', 'AV', 'AT', 'IH', 'IHS']}

Plug 'xolox/vim-misc'
Plug 'terryma/vim-multiple-cursors'
Plug 'liuchengxu/vista.vim'

" tmux
Plug 'christoomey/vim-tmux-navigator'

" snippets
if has('python')
  Plug 'SirVer/ultisnips'
endif

Plug 'honza/vim-snippets'
Plug 'mhartington/vim-angular2-snippets', { 'for': 'typescript' }

" Markdown, reStructuredText, textile
Plug 'godlygeek/tabular', { 'on': ['Tabularize', 'AddTabularPattern'] }
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'jyd519/md-img-paste.vim', { 'for': 'markdown' }
Plug 'dhruvasagar/vim-table-mode'
Plug 'vim-scripts/DrawIt'
Plug 'gyim/vim-boxdraw'

" Auto Completion 
Plug 'ycm-core/YouCompleteMe'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Gist
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim', { 'on': ['Gist'] }

" async
Plug 'skywind3000/asyncrun.vim'
Plug 'tpope/vim-dispatch'

" Graphviz+UML+Dot
Plug 'aklt/plantuml-syntax', { 'for': 'plantuml' }
Plug 'tyru/open-browser.vim', { 'for': 'plantuml' }
Plug 'weirongxu/plantuml-previewer.vim', { 'for': 'plantuml' }
Plug 'wannesm/wmgraphviz.vim', { 'for': 'dot' }

" EditorConfig
" Plug 'editorconfig/editorconfig-vim'
Plug 'sbdchd/neoformat'

"js & node
Plug 'isRuslan/vim-es6', { 'for': ['javascript', 'typescript'] }
Plug 'moll/vim-node', { 'for': ['javascript', 'typescript'] }
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'typescript'] }
Plug 'elzr/vim-json', {'for': 'json'}

" typescript
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }

" nginx
Plug 'chr4/nginx.vim'

" gyp
Plug 'kelan/gyp.vim', { 'for': 'gyp' }

" Go
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries' }

" Rust
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'racer-rust/vim-racer', { 'for': 'rust' }

" Google GN
Plug 'c0nk/vim-gn', { 'for': 'gn' }

" docker
Plug 'ekalinin/Dockerfile.vim'

" unicode characters
Plug 'chrisbra/unicode.vim'
Plug 'junegunn/vim-emoji'

" python
Plug 'jupyter-vim/jupyter-vim', { 'for': 'python' }

" toml
Plug 'cespare/vim-toml', {'for': 'toml'}

" Grammar checker
Plug 'rhysd/vim-grammarous', { 'on': ['GrammarousCheck'] }

" C/C++ build
Plug 'ilyachur/cmake4vim'

" vimdoc - Chinese version
Plug 'yianwillis/vimcdoc'
" reading rfc
Plug 'mhinz/vim-rfc'

" peg / pigeon 
Plug 'jasontbradshaw/pigeon.vim', {'for': 'peg'}

Plug 'tweekmonster/startuptime.vim'

if g:is_nvim
  " treesitter 
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  
  Plug 'nvim-treesitter/nvim-treesitter-refactor'

  Plug 'chentau/marks.nvim'
  Plug 'rcarriga/nvim-notify'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'nathom/filetype.nvim'
  Plug 'numToStr/Comment.nvim'
else
  Plug 'vim-airline/vim-airline'
  Plug 'tomtom/tcomment_vim'
  Plug 'kshenoy/vim-signature'
  Plug '$VIMFILS/locals/vim-a'
endif

call plug#end() 
