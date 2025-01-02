" Requirements:
"    im-select (macOS)
"
" Empty `vimrc` augroup {{{
augroup vimrc
  autocmd!
augroup END
"}}}

" Quick switch to normal mode{{{
imap jj <ESC>
" Insert a blank line
imap <C-Return> <CR><CR><C-o>k<Tab>"
"}}}

" Quick editing myvimrc{{{
"--------------------------------------------------------------------------------
nmap <leader>ei :e! <C-r>=g:myinitrc<CR><CR>
nmap <leader>ev :e! $MYVIMRC<CR>
nmap <leader>ss :source %<cr>
"}}}

" Smart way to move btw. windows{{{
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l
"}}}

" Tab management {{{
nmap <leader>tn :tabnew %<cr>
nmap <leader>tc :tabclose<cr>
nmap <leader>tm :tabmove
"}}}

" Efficient editing{{{1
" ---------------------------------

" Switch to current dir
nmap <leader>cd :lcd %:p:h<cr>:pwd<cr>

" Delete current line without yanking the line breaks
nnoremap dil ^d$
" Yank current line without the line breaks
nnoremap yil ^y$
vnoremap p "_dP

" Move to begin of line / end to line
inoremap <C-e> <Esc>A
inoremap <C-a> <Esc>I
cnoremap <C-a> <C-b>

if !has("mac")
  " Ctrl-V Paste from clipboard
  cnoremap <C-V> <c-r>+
  inoremap <C-V> <c-r>+
endif

" Editing a protected file as 'sudo'
command! W w !sudo tee % > /dev/null
"}}}

" Highlight Yanked Text {{{1
if g:is_nvim
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
endif
" }}}

" Open with browser {{{1
if has("win32")
  nmap <leader>o :update<cr>:silent !start chrome.exe "file://%:p"<cr>
endif
if has("mac")
  nmap <leader>o :update<cr>:silent !open -a "Google Chrome" "%:p"<cr>:redraw!<cr>
endif
" }}}

" Terminal {{{1
" to exit terminal-mode
tnoremap <Esc> <C-\><C-n>
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l

function! s:setMappingForTerminal()
  noremap <buffer> q <c-w>c
endfunction
if g:is_nvim
  autocmd vimrc TermOpen * call <SID>setMappingForTerminal()
else
  autocmd vimrc TerminalOpen * call <SID>setMappingForTerminal()
endif
" }}}

" Auto switching IME {{{1
"--------------------------------------------------------------------------------
if has("mac") && executable("im-select")
  autocmd! vimrc InsertLeave * call misc#Ime_en()
  autocmd! vimrc InsertEnter * call misc#Ime_zh()
endif
"}}}

" Search for visually selected text {{{1
vnoremap <silent> * :call misc#SearchVisualTextDown()<CR>
vnoremap <silent> # :call misc#SearchVisualTextUp()<CR>

" Zoom / Restore window {{{1
command! ZoomToggle call misc#ZoomToggle()
nnoremap <silent> <leader>z :call misc#ZoomToggle()<CR>

" quickfix {{{
nnoremap <silent> <F2> :call qf#ToggleQuickFix()<cr>
nnoremap <silent> <S-F2> :call qf#ToggleLocationList()<cr>
nnoremap <silent> <leader>xg :call qf#ToggleQuickFix()<cr>
nnoremap <silent> <leader>xl :call qf#ToggleLocationList()<cr>
"}}}

" enable osc52 copying for remote ssh connection
if $SSH_CONNECTION != "" && g:is_vim
  nmap <leader>y <Plug>OSCYankVisual
endif

" Font zoom in/out
nmap <silent> <C-=> :call zoom#ZoomIn()<Enter>
nmap <silent> <C--> :call zoom#ZoomOut()<Enter>

" aes-vim
vmap <leader>ec :AesEnc<cr>
nmap <leader>ed :AesDec<cr>

" vim: set fdm=marker fen:
