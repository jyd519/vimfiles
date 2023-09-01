"--------------------------------------------------------------------------------
" Minimal configurations without any external plugins
" Jyd  Last-Modified: 2023-01-05
"--------------------------------------------------------------------------------
set nocompatible

let $VIMFILES=fnamemodify(resolve(expand('<sfile>:p')), ':h')
set rtp^=$VIMFILES rtp+=$VIMFILES/after

let g:myinitrc=resolve(expand('<sfile>:p'))
if !exists("$MYVIMRC")
  let $MYVIMRC=g:myinitrc
endif

if exists('g:enabled_plugins') 
  let g:enabled_plugins["netrw"] =  1
else
  let g:enabled_plugins = {"netrw": 1} 
endif

runtime config/globals.vim
runtime config/options.vim
runtime config/mappings.vim
runtime config/plugins/shared.vim
