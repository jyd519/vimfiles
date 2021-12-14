" Define a group `vimrc` and initialize it.
augroup vimrc
  autocmd!
augroup END

" Quick switch to normal mode
imap jj <ESC>   
" Insert a blank line
imap <C-Return> <CR><CR><C-o>k<Tab>

" Quick editing myvimrc
"--------------------------------------------------------------------------------
if !exists("$MYVIMRC")
  let $MYVIMRC = expand("<sfile>:p")
endif
map <leader>ev :e! $MYVIMRC<CR>
map <leader>ss :source %<cr>

" Smart way to move btw. windows
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

" Switch to current dir
map <leader>cd :lcd %:p:h<cr>:pwd<cr>

" Tab configuration
map <leader>tn :tabnew %<cr>
map <leader>te :tabedit
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

" Delete current line without yanking the line breaks
nnoremap dil ^d$
" Yank current line without the line breaks
nnoremap yil ^y$

" Move to begin of line / end to line
inoremap <C-e> <Esc>A
inoremap <C-a> <Esc>I
cnoremap <C-a> <C-b>

" Start browser
if has("win32")
  nmap <leader>o :update<cr>:silent !"chrome.exe" "file://%:p"<cr>
endif
if has("mac")
  nmap <leader>o :update<cr>:silent !open -a "Google Chrome" "%:p"<cr>:redraw!<cr>
endif

if g:is_nvim
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
endif

vnoremap p "_dP

" Terminal
tnoremap <Esc> <C-\><C-n>  " to exit terminal-mode
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l

" Editing a protected file as 'sudo'
command! W w !sudo tee % > /dev/null

" Auto switching IME
"--------------------------------------------------------------------------------
function! Ime_en()
  let ts = localtime()
  let input_status = system('im-select')
  if input_status =~ "com.apple.keylayout.ABC"
    let b:inputtoggle = 0
  else
    let b:inputtoggle = 1
    call system('im-select com.apple.keylayout.ABC') "use en ime
  endif
endfunction

function! Ime_zh()
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
  au! vimrc InsertLeave * call Ime_en()
  au! vimrc InsertEnter * call Ime_zh()
endif

" font
if has("gui_running")
  let s:font_size=17
  if has("mac")
    let s:fontbase="Hack_Nerd_Font_Mono"
    let s:fontwide="PingFangSC-Light"
  else
    let s:fontbase="Ubuntu_Mono"
    let s:fontwide="NSimSun"
  endif

  if !has('gui_vimr')
    execute "set guifont=". s:fontbase . ":h" . s:font_size
    execute "set guifontwide=". s:fontwide . ":h" . s:font_size
  endif

  function! s:IncFontSize()
    let s:font_size+=1
    execute "set guifont=". s:fontbase . ":h" . s:font_size
    execute "set guifontwide=". s:fontwide . ":h" . s:font_size
    echom s:font_size
  endfunction

  function! s:DecFontSize()
    let s:font_size-=1
    execute "set guifont=". s:fontbase . ":h" . s:font_size
    execute "set guifontwide=". s:fontwide . ":h" . s:font_size
    echom s:font_size
  endfunction

  map <leader>fi :call <SID>IncFontSize()<CR>
  map <leader>fo :call <SID>DecFontSize()<CR>
endif

