#!/bin/bash
set -euo pipefail

FROM="ali"
URL=http://47.101.198.167

DOWNLOAD_ONLY=false

usage() {
  echo "Usage:"
  echo "  install-nvim.sh [OPTIONS] [SOURCE]"
  echo ""
  echo "Sources (default: gh):"
  echo "  gh     Download from GitHub latest release"
  echo "  old    Download from GitHub neovim-releases (older/stable builds)"
  echo "  cn     Download from Aliyun OSS mirror (China)"
  echo "  ali    Download from private Aliyun ECS mirror"
  echo ""
  echo "Options:"
  echo "  -d, --download-only  Only download the package, do not install"
  echo "  -h, --help           Show this help message"
}

while [[ $# -gt 0 ]]; do
  case $1 in
    -h | --help)
      usage
      exit 0
      ;;
    -d | --download-only)
      DOWNLOAD_ONLY=true
      ;;
    gh)
      FROM="gh"
      URL=https://github.com/neovim/neovim/releases/latest/download
      ;;
    old)
      FROM="old"
      URL=https://github.com/neovim/neovim-releases/releases/latest/download
      ;;
    cn)
      FROM="cn"
      URL=https://ata-yuekao-update.oss-cn-beijing.aliyuncs.com/softwares
      ;;
    ali)
      FROM="ali"
      URL=http://47.101.198.167
      ;;
    *)
      echo "Unknown parameter passed: $1"
      echo ""
      usage
      exit 1
  esac
  shift
done

echo "Source : $FROM"
echo "URL    : $URL"

OS=$(uname -s)
ARCH=$(uname -m)
target=/opt/nvim
pkg=nvim-linux-${ARCH}.tar.gz
if [[ "$OS" == "Darwin" ]]; then
  pkg=nvim-macos-${ARCH}.tar.gz
fi

if [[ ! -f $pkg ]]; then
  echo "Downloading $pkg ..."
  curl -Lf -o "$pkg" $URL/$pkg
else
  echo "Package $pkg already exists, skipping download."
fi

if [[ "$DOWNLOAD_ONLY" == true ]]; then
  echo "Download complete: $(pwd)/$pkg"
  exit 0
fi

echo "Installing to $target ..."
mkdir -p nvim-tmp
tar xzf $pkg --strip-components=1 -C nvim-tmp
sudo rm -rf $target
sudo mkdir -p $target
sudo mv ./nvim-tmp/* $target

sudo ln -sf $target/bin/nvim /usr/local/bin/
rm -rf ./$pkg
rm -rf ./nvim-tmp
echo "Installed: $(nvim --version | head -1)"