"--------------------------------------------------------------------------------
" Configurations for Vim
" Use vim-plug to install plugins
" Jyd  Last-Modified: 2021-12-13
"--------------------------------------------------------------------------------
set nocompatible

if has('nvim')
  echom "To empower nvim featurs, you should source <init.lua>."
endif

let g:MYINITRC=resolve(expand('<sfile>:p'))
let $VIMFILES=fnamemodify(g:MYINITRC, ':h')
if !exists("$MYVIMRC")
  let $MYVIMRC=g:MYINITRC
endif

set rtp^=$VIMFILES rtp+=$VIMFILES/after

runtime config/globals.vim

" enable plugins
let g:enabled_plugins = { "fzf": 1, "node": 1, "go": 1, "rust": 1, "coc": 1 }

let s:configs = [
      \ 'config/plugged.vim',
      \ 'config/options.vim',
      \ 'config/mappings.vim',
      \ 'config/plugins/shared.vim',
      \ 'config/plugins/vim_only.vim',
      \ 'config/plugins/ctags.vim',
      \ ]
for s in s:configs
  execute printf('source %s/%s', $VIMFILES, s)
endfor
