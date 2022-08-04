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
  nmap <leader>o :update<cr>:silent !"chrome.exe" "file://%:p"<cr>
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
" }}}

" Auto switching IME {{{1
"--------------------------------------------------------------------------------
function! s:Ime_en()
  let ts = localtime()
  let input_status = system('im-select')
  if input_status =~ "com.apple.keylayout.ABC"
    let b:inputtoggle = 0
  else
    let b:inputtoggle = 1
    call system('im-select com.apple.keylayout.ABC') "use en ime
  endif
endfunction

function! s:Ime_zh()
  try
    if b:inputtoggle == 1
      " Restore previous IME
      call system('im-select com.apple.inputmethod.SCIM.ITABC')
    endif
  catch /inputtoggle/
    let b:inputtoggle = 0
  endtry
endfunction

if has("mac")
  autocmd! vimrc InsertLeave * call <SID>Ime_en()
  autocmd! vimrc InsertEnter * call <SID>Ime_zh()
endif
"}}}

" Search for visually selected text {{{1
function! s:getSelectedText()
  let l:old_reg = getreg('"')
  let l:old_regtype = getregtype('"')
  norm gvy
  let l:ret = getreg('"')
  call setreg('"', l:old_reg, l:old_regtype)
  exe "norm \<Esc>"
  return l:ret
endfunction

vnoremap <silent> * :call setreg("/",
      \ substitute(<SID>getSelectedText(),
      \ '\_s\+',
      \ '\\_s\\+', 'g')
      \ )<Cr>n

vnoremap <silent> # :call setreg("?",
      \ substitute(<SID>getSelectedText(),
      \ '\_s\+',
      \ '\\_s\\+', 'g')
      \ )<Cr>n


" Zoom / Restore window {{{1
function! s:ZoomToggle() abort
  if exists('t:zoomed') && t:zoomed
    execute t:zoom_winrestcmd
    let t:zoomed = 0
  else
    let t:zoom_winrestcmd = winrestcmd()
    resize
    vertical resize
    let t:zoomed = 1
  endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <leader>z :ZoomToggle<CR>

" vim: set fdm=marker fen:
