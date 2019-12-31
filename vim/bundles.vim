"--------------------------------------------------------------------------------
" vim-plug
"--------------------------------------------------------------------------------
if empty(glob($VIMFILES . '/autoload/plug.vim'))
  silent !curl -fLo $VIMFILES/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

"Conditional plugin loading
" Plug 'benekastah/neomake', Cond(has('nvim'))
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin('$VIMFILES/plugged')

Plug 'mhinz/vim-startify'
Plug 'flazz/vim-colorschemes'
" efficient
Plug 'jyd519/ListToggle'
Plug 'vim-scripts/bufkill.vim'
Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'mattn/emmet-vim'

Plug 'chiedojohn/vim-case-convert'
Plug 'thinca/vim-quickrun'

Plug 'jiangmiao/auto-pairs'
Plug 'tmhedberg/matchit'
Plug 'AndrewRadev/splitjoin.vim'

Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'

Plug 'wesleyche/SrcExpl'
" Plug 'ervandew/supertab'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tomtom/tcomment_vim'

Plug 'w0rp/ale'

Plug 'bling/vim-airline'
Plug 'xolox/vim-easytags'
Plug 'nathanaelkane/vim-indent-guides'

Plug 'xolox/vim-misc'
Plug 'terryma/vim-multiple-cursors'
Plug 'xolox/vim-session'
Plug 'kshenoy/vim-signature'
Plug 'jez/vim-superman'
Plug 'majutsushi/tagbar'

" tmux
Plug 'edkolev/tmuxline.vim'
Plug 'christoomey/vim-tmux-navigator'

" snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
"angula2 snippets
Plug 'mhartington/vim-angular2-snippets'

" Markdown, reStructuredText, textile
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'jyd519/md-img-paste.vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'vim-scripts/DrawIt'


" Auto Completion 
" Plug 'Shougo/neocomplete.vim'
Plug 'ycm-core/YouCompleteMe' 
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Gist
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'

" async
Plug 'skywind3000/asyncrun.vim'
Plug 'tpope/vim-dispatch'

" Graphviz+UML
Plug 'aklt/plantuml-syntax'
Plug 'wannesm/wmgraphviz.vim'

" EditorConfig
Plug 'editorconfig/editorconfig-vim'
Plug 'rhysd/vim-clang-format'

"js & node
Plug 'isRuslan/vim-es6'
Plug 'moll/vim-node'
Plug 'geekjuice/vim-mocha'

Plug 'marijnh/tern_for_vim'

Plug 'kchmck/vim-coffee-script'
Plug 'pangloss/vim-javascript'
Plug 'maksimr/vim-jsbeautify'
Plug 'elzr/vim-json'
Plug 'Shutnik/jshint2.vim'

" typescript
Plug 'leafgarland/typescript-vim'

" nginx
Plug 'chr4/nginx.vim'

" gyp
Plug 'kelan/gyp.vim'

" Go
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries' }
" Plug 'fatih/vim-go', { 'for': 'go', 'tag': 'v1.20' }

" Rust
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'racer-rust/vim-racer', { 'for': 'rust' }
Plug 'timonv/vim-cargo', { 'for': 'rust' }

" Google GN
Plug 'c0nk/vim-gn'

" docker
Plug 'ekalinin/Dockerfile.vim'

" unicode characters
Plug 'chrisbra/unicode.vim'

" python
Plug 'rkulla/pydiction', { 'for': 'python' }
Plug 'tell-k/vim-autopep8', { 'for': 'python' }

" toml
Plug 'cespare/vim-toml', {'for': 'toml'}

" tool
Plug 'farconics/victionary'

Plug 'rhysd/vim-grammarous'

Plug 'vhdirk/vim-cmake'

" Plug 'sheerun/vim-polyglot'

Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}

" vimdoc - Chinese version
Plug 'yianwillis/vimcdoc'

call plug#end() 