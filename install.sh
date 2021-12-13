#!/bin/bash

# git clone --depth=1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/opt/packer.nvim
# On Linux and macOS, the directory is ~/.config/nvim

echo "Link ~/.vimrc to $(pwd)/vim/init.vim"
ln -sf $(pwd)/vim/init.vim ~/.vimrc

if [[ -d ~/.config/nvim ]]; then
  echo "Link ~/.config/nvim/init.vim to $(pwd)/vim/init.vim"
  ln -sf $(pwd)/vim/init.vim ~/.config/nvim/init.vim
fi
