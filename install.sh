#!/bin/bash
echo "Link ~/.vimrc to $(pwd)/vim/vimrc"
ln -sf $(pwd)/vim/vimrc  ~/.vimrc

if [[ -d ~/.config/nvim ]]; then
  echo "Link ~/.config/nvim/init.vim to $(pwd)/vim/vimrc"
  ln -sf $(pwd)/vim/vimrc  ~/.config/nvim/init.vim
fi
