"--------------------------------------------------------------------------------
" Configurations for Vim/Neovim ( +lua, +python )
" Jyd  Last-Modified: 2021-12-13
"--------------------------------------------------------------------------------
set nocompatible
let $VIMFILES=fnamemodify(resolve(expand('<sfile>:p')), ':h')

if has('nvim')
  source $VIMFILES/init.lua
  finish
end

set rtp^=$VIMFILES rtp+=$VIMFILES/after

if $VIM_MODE =~ 'man'
  let $MYVIMRC=expand("$VIMFILES/config/man.vim")
  source $VIMFILES/config/man.vim
  finish
endif

" Source required plugins
if $VIM_MODE =~ 'ycm'
  let g:did_coc_loaded = 1        " Disable COC
else
  let $VIM_MODE = 'coc'
  let g:loaded_youcompleteme = 1  " Disable YCM
endif

" load local customized script
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

let $MYVIMRC=expand("$VIMFILES/init.vim")

let s:configs = [ 
      \ 'config/globals.vim',
      \ 'config/plugged.vim',
      \ 'config/options.vim',
      \ 'config/mappings.vim',
      \ 'config/plugins/shared.vim',
      \ 'config/plugins/vim_only.vim',
      \ 'config/plugins/ctags.vim',
      \ 'config/color.vim',
      \ ]
for s in s:configs 
  execute printf('source %s/%s', $VIMFILES, s)
endfor