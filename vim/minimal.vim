"--------------------------------------------------------------------------------
" Minimal configurations without any external plugins
" Jyd  Last-Modified: 2023-01-05
"--------------------------------------------------------------------------------
set nocompatible

let $VIMFILES=fnamemodify(resolve(expand('<sfile>:p')), ':h')
set rtp^=$VIMFILES rtp+=$VIMFILES/after

let g:MYINITRC=resolve(expand('<sfile>:p'))
if !exists("$MYVIMRC")
  let $MYVIMRC=g:MYINITRC
endif

let g:enabled_plugins = {"netrw": 1} 

runtime config/globals.vim
runtime config/options.vim
runtime config/mappings.vim
runtime config/plugins/shared.vim
