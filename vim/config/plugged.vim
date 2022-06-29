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
Plug 'NLKNguyen/papercolor-theme'

" Efficient editing
Plug 'jyd519/ListToggle'          " toggle quickfix/location window
Plug 'vim-scripts/bufkill.vim'
Plug 'justinmk/vim-sneak'
Plug 'mattn/emmet-vim', { 'for': ['html', 'jsx', 'vue'] }
Plug 'jiangmiao/auto-pairs'
Plug 'tmhedberg/matchit'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'chiedojohn/vim-case-convert'
Plug 'tomtom/tcomment_vim'
Plug $VIMFILES . '/locals/vim-a'

Plug 'vim-test/vim-test'    " Unit-Testing
Plug 'thinca/vim-quickrun'
Plug 'tweekmonster/startuptime.vim'
Plug 'preservim/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

if g:use_heavy_plugin
  Plug 'puremourning/vimspector'
endif


Plug 'dense-analysis/ale'
Plug 'brookhong/cscope.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'xolox/vim-misc'

" tmux
Plug 'christoomey/vim-tmux-navigator'

" snippets
if g:use_heavy_plugin && has('python3') 
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'mhartington/vim-angular2-snippets', { 'for': 'typescript' }

  Plug 'liuchengxu/vista.vim'
endif

" async
Plug 'skywind3000/asyncrun.vim'
Plug 'tpope/vim-dispatch'

" Auto Completion 
if g:use_heavy_plugin
  Plug 'ycm-core/YouCompleteMe'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif

" Statusline
Plug 'vim-airline/vim-airline'

" Code formatter
Plug 'sbdchd/neoformat'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Gist
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim', { 'on': ['Gist'] }

" Graphviz+UML+Dot
Plug 'aklt/plantuml-syntax', { 'for': 'plantuml' }
Plug 'tyru/open-browser.vim', { 'for': 'plantuml' }
Plug 'weirongxu/plantuml-previewer.vim', { 'for': 'plantuml' }
Plug 'wannesm/wmgraphviz.vim', { 'for': 'dot' }

" Markdown, reStructuredText, textile
Plug 'godlygeek/tabular', { 'on': ['Tabularize', 'AddTabularPattern'] }
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'jyd519/md-img-paste.vim', { 'for': 'markdown' }
Plug 'dhruvasagar/vim-table-mode'
Plug 'vim-scripts/DrawIt'
Plug 'gyim/vim-boxdraw'

"js, ts, node
Plug 'isRuslan/vim-es6', { 'for': ['javascript', 'typescript'] }
Plug 'moll/vim-node', { 'for': ['javascript', 'typescript'] }
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'typescript'] }
Plug 'elzr/vim-json', {'for': 'json'}
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }

" nginx
Plug 'chr4/nginx.vim'

" gyp
Plug 'kelan/gyp.vim', { 'for': 'gyp' }

" Go
if g:use_heavy_plugin
  Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries' }
endif

" Rust
if g:use_heavy_plugin && executable('rust') != 0
  Plug 'rust-lang/rust.vim', { 'for': 'rust' }
  Plug 'racer-rust/vim-racer', { 'for': 'rust' }
endif

" Google GN
Plug 'c0nk/vim-gn', { 'for': 'gn' }

" docker
Plug 'ekalinin/Dockerfile.vim'

" unicode characters
Plug 'chrisbra/unicode.vim'
Plug 'junegunn/vim-emoji'

" python
if g:use_heavy_plugin
  Plug 'jupyter-vim/jupyter-vim', { 'for': 'python' }
endif

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

call plug#end() 
