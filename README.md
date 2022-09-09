# My VIM Configuratiosn

## Install

1. Get Vim files 

`git clone https://github.com/jyd519/vimfiles  ~/.vimgit`

2. Create symbol links

```sh
~/.vimgit/install.sh
```

or edit vimrc

+ neovim

~/.config/nvim/init.vim

```
so ~/.vimgit/init.lua
```

+ vim 

```
so ~/.vimgit/init.vim
```

3. Install plugins

+ vim-plug

`vim -c "PlugInstall"`

+ packer.nvim

`nvim -c "PackerSync"`

## Dependencies

### The_Silver_Searcher

+ https://github.com/ggreer/the_silver_searcher

1. MacOS: `brew install the_silver_searcher`
2. Linux: `apt-get install silversearcher-ag`
3. Windows: `winget install "The Silver Searcher"`

### fd

+ https://github.com/sharkdp/fd/releases/

### ripgrep

+ https://github.com/BurntSushi/ripgrep/releases

### llvm

+ https://github.com/llvm/llvm-project/releases

### ctags

https://github.com/universal-ctags/ctags

+  MacOS: `brew install ctags`
+  Windows: https://github.com/universal-ctags/ctags-win32/releases
