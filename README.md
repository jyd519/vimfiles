# My VIM Configuratiosn

## Install

1. Get Vim Files

`git clone https://github.com/jyd519/vimfiles  ~/.vimgit`

2. Apply Configuratiosn

+ For Neovim User

```sh
mkdir -p ~/.config/nvim
```

Below is the example for `~/.config/nvim/init.vim`

```vim
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0
" path to python3
let g:python3_host_prog = expand('~/.pyenv/versions/3.10.2/bin/python3.10')
let g:loaded_python3_provider = 1
" npm i -g neovim
let g:node_host_prog = '/usr/local/bin/neovim-node-host'
" On Windows
" let g:node_host_prog="<path>/node_modules/neovim/bin/cli.js"

let g:node_path = $NODE_PATH != "" ? $NODE_PATH :  'node'

" let g:copilot_node_command=expand('~/.nvm/versions/node/v16.10.0/bin/node')
" let g:notes_dir = '<path>'

" enable plugins
" let g:enabled_plugins = { "fzf": 1, "node": 0, "go": 0, "rust": 0, "python": 0 \
"   "fzf-lua": 0, "markdown": 0, \
"   "netrw": 0, "telescope": 1, "test": 0 , "tmux": 0, "nvim-treesitter": 0 \
"}
"
let test#go#gotest#options = '-v'

" HACK: work around bad detection of background in Tmux (no OSC11 support)
" https://github.com/neovim/neovim/issues/17070
if $TERM_PROGRAM == "tmux"
  lua vim.loop.fs_write(2, "\27Ptmux;\27\27]11;?\7\27\\", -1, nil)
endif

if exists('+termguicolors')
  set termguicolors
endif

source ~/vimgit/vim/lazy.lua

colorscheme vscode
```

+ For Vim User

```vim
let g:enabled_plugins={"fzf":1, "coc": 0}

source ~/.vimgit/vim/basic.vim

set guifont=Consolas:h14
colors papercolor

" Set GUI VIM Font
" if has("gui_running") && !has("gui_vimr")
"   if has("mac")
"     set guifont=JetBrains_Mono_Regular_Nerd_Font_Complete_Mono:h16
"     set guifontwide=PingFangSC-Light:h16
"   else
"     set guifont=Hack_Nerd_Font_Mono:h14
"     set guifontwide=NSimSun:h14
"   endif
" endif
```

## Dependencies

### git

### ripgrep

+ https://github.com/BurntSushi/ripgrep/releases

### The Silver Searcher

Manual Install: [Download The Silver Searcher](https://github.com/ggreer/the_silver_searcher)

or Install with a package manager.

1. MacOS: `brew install the_silver_searcher`
2. Linux: `apt-get install silversearcher-ag`
3. Windows: `winget install "The Silver Searcher"`

### fd

+ https://github.com/sharkdp/fd/releases/

### llvm

> clangd

+ https://github.com/llvm/llvm-project/releases

### ctags

https://github.com/universal-ctags/ctags

+  MacOS: `brew install ctags`
+  Windows: https://github.com/universal-ctags/ctags-win32/releases
