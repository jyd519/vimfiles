"--------------------------------------------------------------------------------
" Configurations for Vim
" Use vim-plug to install plugins
" Jyd  Last-Modified: 2023-8-7
"--------------------------------------------------------------------------------
set nocompatible

if has('nvim')
  echom "To empower nvim featurs, you should source <init.lua>."
endif

let g:myinitrc=resolve(expand('<sfile>:p'))
let $VIMFILES=fnamemodify(g:myinitrc, ':h')
if !exists("$MYVIMRC")
  let $MYVIMRC=g:myinitrc
endif

set rtp^=$VIMFILES rtp+=$VIMFILES/after

" enable plugins
let g:enabled_plugins = { "fzf": 1, "node": 1, "go": 1, "rust": 0, "coc": 0 }

runtime config/globals.vim

let s:configs = [
      \ 'config/plugged.vim',
      \ 'config/options.vim',
      \ 'config/mappings.vim',
      \ 'config/plugins/shared.vim',
      \ ]
for s in s:configs
  execute printf('source %s/%s', $VIMFILES, s)
endfor
