#!/bin/bash

# git clone --depth=1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/opt/packer.nvim
# On Linux and macOS, the directory is ~/.config/nvim

# vim -> init.vim
echo "Link ~/.vimrc to $(pwd)/vim/init.vim"
ln -sf $(pwd)/vim/init.vim ~/.vimrc

# neovim -> init.lua
if [[ -d ~/.config/nvim ]]; then
  echo "Link ~/.config/nvim/init.lua to $(pwd)/vim/init.lua"
  ln -sf $(pwd)/vim/init.lua ~/.config/nvim/init.lua
fi
