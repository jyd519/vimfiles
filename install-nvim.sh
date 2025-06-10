#!/bin/bash
set -euo pipefail

OS=`uname -s`
ARCH=`uname -m`
target=/opt/nvim
pkg=nvim-linux64.tar.gz
if [[ "$OS" == "Darwin" ]]; then
  pkg=nvim-macos-${ARCH}.tar.gz
fi

if [[ ! -f $pkg ]]; then
  curl -Lf -o "$pkg" https://github.com/neovim/neovim/releases/latest/download/$pkg
fi

tar xzf $pkg
sudo rm -rf $target
sudo mkdir -p $target

if [[ "$OS" == "Linux" ]]; then
  sudo mv ./nvim-linux64/* $target
else
  sudo mv ./nvim-macos-${ARCH}/* $target
fi

sudo ln -sf $target/bin/nvim /usr/local/bin/
rm -rf ./$pkg
