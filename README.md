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

1. ctags

https://github.com/universal-ctags/ctags

+  MacOS: `brew install ctags`
+  Windows: https://github.com/universal-ctags/ctags-win32/releases

2. The_Silver_Searcher:

https://github.com/ggreer/the_silver_searcher

+ MacOS: `brew install the_silver_searcher`
+ Linux: `apt-get install silversearcher-ag`
+ Windows: https://github.com/k-takata/the_silver_searcher-win32

3. clang-foramt

+ MacOS: `brew install clang-format`
