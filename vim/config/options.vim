set shiftwidth=2
set tabstop=2
set expandtab
set modeline

set nowrap
set number
" set relativenumber
set ignorecase smartcase " Only be case sensitive when search contains uppercase
set hidden " allow we leave from the current modified buffer
set smartindent
set hlsearch

set nobackup nowb noswf
set nowritebackup
set backupcopy=yes

set showmatch
set cmdheight=2
set history=100
set updatetime=300  " Smaller updatetime for CursorHold & CursorHoldI
set shortmess+=c    " don't give |ins-completion-menu| messages.
set signcolumn=yes " always show signcolumns
" if has("nvim-0.5.0") || has("patch-8.1.1564")
"   " Recently vim can merge signcolumn and number column into one
"   set signcolumn=number
" else
"   set signcolumn=yes " always show signcolumns
" endif
if &foldmethod == "manual"
  set foldmethod=indent
end
set foldlevelstart=99
set foldcolumn=3

set scrolloff=2
set guioptions-=T
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,gbk,gb18030
set wildmenu " show a navigable menu for tab completion
set wildmode=list:longest,full
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
set wildignore+=*DS_Store,*.pyc
set completeopt=menuone,longest,preview,noselect
"set t_ti= t_te= Keep screen after vim exited

set clipboard+=unnamed

if has("balloon_eval")
  set ballooneval
  set balloondelay=100
endif

if has('termguicolors')
  set termguicolors
  " Correct RGB escape codes for vim inside tmux
  if !has('nvim') && $TERM ==# 'screen-256color'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
endif

set path=.,./include/**/*,/usr/local/include,/usr/include,$VIMFILES

" Default sh is Bash
let g:bash_is_sh=1

" Persistent undo
"--------------------------------------------------------------------------------
set undofile
if has('nvim')
  set undodir=$HOME/undodir/nvim
else
  set undodir=$HOME/undodir/vim
endif

" define leader char
"--------------------------------------------------------------------------------
let g:mapleader = ","
let g:maplocalleader = ","

" status line
"--------------------------------------------------------------------------------
set laststatus=2

" enable syntax highlighting
syntax on
syntax sync minlines=256
set synmaxcol=300
set redrawtime=10000

if has("win32")
  if has('termencoding')
    set termencoding=gb2312
  endif
  if has('directx')
    set renderoptions=type:directx,level:0.75,gamma:1.25,contrast:0.5,
                          \geom:1,renmode:5,taamode:1
  endif
endif

" ctags
"--------------------------------------------------------------------------------
" look ctags in directory the current file in, and working directory,
" and looking up and up until /
set tags=./tags,tags,./.tags,.tags
