"--------------------------------------------------------------------------------
" vim-plug
"--------------------------------------------------------------------------------
if empty(glob($VIMFILES . '/autoload/plug.vim'))
  silent !curl -fLo $VIMFILES/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

function! s:any(...)
  for name in a:000
    if get(g:enabled_plugins, name, 0) | return 1 | endif
  endfor
  return 0
endfunction

function! s:all(...)
  for name in a:000
    if get(g:enabled_plugins, name, 0) == 0 | return 0 | endif
  endfor
  return 1
endfunction

call plug#begin('$VIMFILES/plugged')

Plug 'mhinz/vim-startify'
Plug 'NLKNguyen/papercolor-theme'

" Efficient editing
Plug 'jyd519/ListToggle'          " toggle quickfix/location window
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
Plug $VIMFILES . '/locals/vim-a', { 'on': ['A', 'AH'] }

if s:any("test")
  Plug 'vim-test/vim-test'    " Unit-Testing, requires python
  Plug 'brookhong/cscope.vim'
endif

Plug 'thinca/vim-quickrun'
Plug 'dstein64/vim-startuptime', { 'on': ['StartupTime'] }

Plug 'preservim/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }

if get(g:enabled_plugins, "fzf", 0)
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
endif

if get(g:enabled_plugins, "python", 0)
  Plug 'puremourning/vimspector'
endif

Plug 'dense-analysis/ale'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'xolox/vim-misc'

" tmux
if !has("win32") && executable("tmux")
  Plug 'christoomey/vim-tmux-navigator'
endif

" snippets
if get(g:enabled_plugins, "python", 0)
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'mhartington/vim-angular2-snippets', { 'for': 'typescript' }
endif

" async
Plug 'skywind3000/asyncrun.vim'
Plug 'tpope/vim-dispatch'

" Auto Completion
if get(g:enabled_plugins, "ycm", 0)
  Plug 'ycm-core/YouCompleteMe'
endif
if get(g:enabled_plugins, "coc", 0)
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif

" Statusline
Plug 'vim-airline/vim-airline'

" Code formatter
Plug 'sbdchd/neoformat', {'on': ['Neoformat']}

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Gist
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim', { 'on': ['Gist'] }

" Graphviz+UML+Dot
if s:all("uml", "markdown")
  Plug 'aklt/plantuml-syntax', { 'for': 'plantuml' }
  Plug 'tyru/open-browser.vim', { 'for': 'plantuml' }
  Plug 'weirongxu/plantuml-previewer.vim', { 'for': 'plantuml' }
  Plug 'wannesm/wmgraphviz.vim', { 'for': 'dot' }
endif

" Markdown, reStructuredText, textile
if s:any("markdown")
  Plug 'godlygeek/tabular', { 'on': ['Tabularize', 'AddTabularPattern'] }
  Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
  Plug 'jyd519/md-img-paste.vim', { 'for': 'markdown' }
  Plug 'dhruvasagar/vim-table-mode'
  Plug 'vim-scripts/DrawIt'
  Plug 'gyim/vim-boxdraw'
endif

"js, ts, node
if s:any("node")
  Plug 'isRuslan/vim-es6', { 'for': ['javascript', 'typescript'] }
  Plug 'moll/vim-node', { 'for': ['javascript', 'typescript'] }
  Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'typescript'] }
  Plug 'elzr/vim-json', {'for': 'json'}
  Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
endif

" nginx
Plug 'chr4/nginx.vim'

" gyp
Plug 'kelan/gyp.vim', { 'for': 'gyp' }

" Go
if s:any("go")
  Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries' }
endif

" Rust
if get(g:enabled_plugins, "rust", 0)
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

" toml
Plug 'cespare/vim-toml', {'for': 'toml'}

" Grammar checker
Plug 'rhysd/vim-grammarous', { 'on': ['GrammarousCheck'] }

" C/C++ build
Plug 'ilyachur/cmake4vim', { 'for': ['cpp', 'c', 'objc', 'objcc', 'cmake'] }

" vimdoc - Chinese version
Plug 'yianwillis/vimcdoc'

" reading rfc
Plug 'mhinz/vim-rfc'

" peg / pigeon
Plug 'jasontbradshaw/pigeon.vim', {'for': 'peg'}

call plug#end()

for [key, value] in items(g:plugs)
  let g:enabled_plugins[tolower(key)] = isdirectory(value.dir) 
endfor
