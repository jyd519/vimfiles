# My VIM Configuratiosn

## Install

1. Get Vim files 

`git clone https://github.com/jyd519/vimfiles  ~/.vimgit`

2. Create symbol links

```sh
~/.vimgit/install.sh
```

3. Install plugins

`vim -c "PlugInstall"`


## Dependencies

1. ctags

https://github.com/universal-ctags/ctags

+  MacOS: `brew install ctags`
+  Windows: https://github.com/universal-ctags/ctags-win32/releases

2. jsctags(optional)

`npm install -g git://github.com/ramitos/jsctags.git`

3. The_Silver_Searcher:

https://github.com/ggreer/the_silver_searcher

+ MacOS: `brew install the_silver_searcher`
+ Linux: `apt-get install silversearcher-ag`
+ Windows: https://github.com/k-takata/the_silver_searcher-win32

4. clang-foramt

+ MacOS: `brew install clang-format`
