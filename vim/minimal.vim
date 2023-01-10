"--------------------------------------------------------------------------------
" Minimal configurations without any external plugins
" Jyd  Last-Modified: 2023-01-05
"--------------------------------------------------------------------------------
set nocompatible

let g:loaded_plug = 1
let g:enabled_plugins = {} 

let $VIMFILES=fnamemodify(resolve(expand('<sfile>:p')), ':h')
set rtp^=$VIMFILES rtp+=$VIMFILES/after

let g:MYINITRC=resolve(expand('<sfile>:p'))
if !exists("$MYVIMRC")
  let $MYVIMRC=g:MYINITRC
endif


let s:configs = [ 
      \ 'config/globals.vim',
      \ 'config/options.vim',
      \ 'config/mappings.vim',
      \ 'config/plugins/shared.vim',
      \ 'config/plugins/vim_only.vim',
      \ 'config/plugins/ctags.vim',
      \ ]
for s in s:configs 
  execute printf('source %s/%s', $VIMFILES, s)
endfor
