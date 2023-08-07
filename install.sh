#!/bin/bash

# install packer.nvim
#   git clone --depth=1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/opt/packer.nvim
#
# install plug.vim
#   curl  -fLo ./vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

SCRIPT_PATH="$( cd "$(dirname $0)" ; pwd -P )"

VIMCONFIG=$(cat <<-END
let g:test#javascript#runner = 'jest'
set background="light"
let g:colorscheme='PaperColor'
source $SCRIPT_PATH/vim/init.vim
END
)

NVIMCONFIG=$(cat <<-END
let g:loaded_python_provider = 1
let g:python_host_prog = '~/.pyenv/versions/2.7.18/bin/python2'
let g:python3_host_prog = '~/.pyenv/versions/3.10.2/bin/python3.10'
let g:node_host_prog = '/usr/local/bin/neovim-node-host'

let g:use_heavy_plugin = 1
let g:use_treesitter = 1

let g:test#javascript#runner = 'jest'

set background="light"
let g:colorscheme='vscode'

source $SCRIPT_PATH/vim/init.lua
END
)

#----------------------------------------
# vim
#----------------------------------------
if ! [[ -f ~/.vimrc ]]; then
  echo "Creating ~/.vimrc for vim ..."
  printf "%s\n" "$VIMCONFIG" > ~/.vimrc
else
  printf "\n==========================================================\n"
  printf "Vim configuration already exists: ~/.vimrc"
  printf "\n==========================================================\n"
  printf "\n%s\n" "$VIMCONFIG"
fi

#----------------------------------------
# neovim
#----------------------------------------
# On Linux and macOS, the directory to store configuration is ~/.config/nvim
NEOVIM_CONFIG_DIR=~/.config/nvim
if ! [[ -f $NEOVIM_CONFIG_DIR/init.vim ]]; then
  echo "Creating nvim configuration ..."
  if ! [[ -d $NEOVIM_CONFIG_DIR ]]; then
    mkdir -p $NEOVIM_CONFIG_DIR
  fi

  printf "%s\n" "$NVIMCONFIG" > $NEOVIM_CONFIG_DIR/init.vim
else
  printf "\n==========================================================\n"
  printf "Nvim configuration already exists: ~/.config/nvim/init.vim"
  printf "\n==========================================================\n"

  printf "\n%s\n" "$NVIMCONFIG"
fi
