#!/bin/bash
set -euo pipefail

FROM="gh"
URL=https://github.com/neovim/neovim/releases/latest/download

while [[ $# -gt 0 ]]; do
  case $1 in
    -h | --help)
      echo "Usage:"
      echo "  install-nvim.sh [cn|old|gh]"
      exit
      ;;
    gh)
      ;;
    old)
      URL=https://github.com/neovim/neovim-releases/releases/latest/download
      ;;
    cn)
      FROM="cn"
      URL=https://ata-yuekao-update.oss-cn-beijing.aliyuncs.com/softwares
      ;;
    *)
      echo "Unknown parameter passed: $1"
      exit 1
  esac
  shift
done

echo $URL

OS=$(uname -s)
ARCH=$(uname -m)
target=/opt/nvim
pkg=nvim-linux-${ARCH}.tar.gz
if [[ "$OS" == "Darwin" ]]; then
  pkg=nvim-macos-${ARCH}.tar.gz
fi

if [[ ! -f $pkg ]]; then
  curl -Lf -o "$pkg" $URL/$pkg
fi

mkdir -p nvim-tmp
tar xzf $pkg --strip-components=1 -C nvim-tmp
sudo rm -rf $target
sudo mkdir -p $target
sudo mv ./nvim-tmp/* $target

sudo ln -sf $target/bin/nvim /usr/local/bin/
rm -rf ./$pkg
rm -rf ./nvim-tmp
