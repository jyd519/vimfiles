#!/bin/sh

#Exit immediately if a command exits with a non-zero status
set -e 
script_path=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

curl -fLo $script_path/vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
