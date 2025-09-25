# My VIM Configuratiosn

This repository contains a comprehensive Vim/Neovim configuration designed for developers who want a powerful, efficient, and modern editing environment. The configuration supports both traditional Vim and modern Neovim with Lua-based configurations.

## Features

### Modular Configuration
- **Dual Support**: Separate configurations for Vim (`basic.vim`) and Neovim (`lazy.lua`)
- **Plugin Management**: Uses vim-plug for Vim and lazy.nvim for Neovim
- **Conditional Loading**: Plugins can be enabled/disabled based on user needs
- **Performance Optimized**: Lazy loading and efficient plugin management

### Rich Plugin Ecosystem
- **Code Completion**: Multiple completion engines (YouCompleteMe, CoC, nvim-cmp)
- **Language Support**: Extensive support for JavaScript/TypeScript, Go, Rust, Python, C/C++, and more
- **Navigation**: Fuzzy finders (fzf, telescope), file explorers (NERDTree, nvim-tree)
- **Development Tools**: LSP integration, DAP debugging, testing frameworks
- **Productivity**: Snippets, auto-pairs, surround operations, commenting tools

### Modern Development Workflow
- **LSP Integration**: Full language server protocol support
- **Debugging**: Built-in DAP support for multiple languages
- **Version Control**: Git integration with fugitive and gitgutter
- **Terminal Integration**: Built-in terminal support with floaterm
- **Formatting**: Code formatting with neoformat

## Project Structure

```
.
├── README.md              # This file
├── install-nvim.ps1       # Neovim installer for Windows
├── install-nvim.sh        # Neovim installer for Unix-like systems
├── vim/                   # Main Vim configuration directory
│   ├── basic.vim          # Entry point for Vim configuration
│   ├── lazy.lua           # Entry point for Neovim configuration
│   ├── config/            # Shared configuration files
│   ├── lua/               # Neovim Lua modules
│   │   └── myrc/          # Custom Neovim configuration
│   │       ├── plugins/   # Plugin specifications
│   │       └── config/    # Plugin configurations
│   └── plugged/           # Vim-plug managed plugins (Vim)
└── lazy/                  # Lazy.nvim managed plugins (Neovim)
```

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
