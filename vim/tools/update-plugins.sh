#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

curl -fLo $root/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fLo $root/plugin/surround.vim https://raw.githubusercontent.com/tpope/vim-surround/master/plugin/surround.vim
curl -fLo $root/autoload/repeat.vim https://raw.githubusercontent.com/tpope/vim-repeat/master/autoload/repeat.vim
