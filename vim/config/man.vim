" Simple configuration for reading man page
"
let s:configs = [ 
      \ 'config/globals.vim',
      \ 'config/options.vim',
      \ 'config/mappings.vim',
      \ ]
for s in s:configs 
  execute printf('source %s/%s', $VIMFILES, s)
endfor

" Disable tmux navigator when zooming the Vim pane
"--------------------------------------------------------------------------------
let g:tmux_navigator_disable_when_zoomed = 1

"--------------------------------------------------------------------------------
" man mode plugins
"--------------------------------------------------------------------------------
if empty(glob($VIMFILES . '/autoload/plug.vim'))
  silent !curl -fLo $VIMFILES/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('$VIMFILES/plugged')

Plug 'Mofiqul/vscode.nvim'
Plug 'easymotion/vim-easymotion'
Plug 'bling/vim-airline'
Plug 'jez/vim-superman'
Plug 'christoomey/vim-tmux-navigator'

call plug#end() 

colorscheme vscode
