" Convert selected text to javascript string
"--------------------------------------------------------------------------------
function! misc#ToJS(sep, first_line, last_line)
  let i = a:first_line
  while i<=a:last_line
    let l = getline(i)
    let l = substitute(l, a:sep, "\\\\".a:sep, "g")
    if i==a:last_line
      call setline(i, a:sep . l . a:sep . ";" )
    else
      call setline(i, a:sep . l . a:sep . " + " )
    endif
    let i=i+1
  endwhile
endfunction

" Quick unescape xml entities
"--------------------------------------------------------------------------------
function! misc#XmlUnescape()
  silent! execute ':%s/&lt;/</g'
  silent! execute ':%s/&gt;/>/g'
  silent! execute ':%s/&amp;/\&/g'
endfunction

" Unescape \uXXXX sequences in selected lines
"--------------------------------------------------------------------------------
function! misc#UnescapeUnicode() range
  let cmd = a:firstline . "," . a:lastline . 's/\\u\(\x\{4\}\)/\=nr2char("0x".submatch(1),1)/g'
  silent! execute cmd
endfunction

" Convert rows of numbers or text (as if pasted from excel column) to a tuple
"--------------------------------------------------------------------------------
function! misc#ToTupleFunction() range
  silent execute a:firstline . "," . a:lastline . "s/^/'/"
  silent execute a:firstline . "," . a:lastline . "s/$/',/"
  silent execute a:firstline . "," . a:lastline . "join"
  silent execute "normal I("
  silent execute "normal $xa)"
  silent execute "normal ggVGYY"
endfunction

" Dot
"--------------------------------------------------------------------------------
function! misc#Dot(bang, format)
  let fmt = a:format
  if empty(fmt)
    let fmt = 'png'
  endif
  let cmd = '!dot'
  let opt = ' -T' . fmt . ' -o '
  let currfile = expand('%:p')
  let outfile = expand('%:p:r') . '.' . fmt
  echom opt
  silent execute cmd . ' "' . currfile . '" '. opt . ' "' . outfile . '" '
  if a:bang
    call system('open ' . outfile)
  endif
endfunction


" set path
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function! misc#SetPath()
  if !executable('fd')
    echom "AddPath: executable `fd` not found!"
    return
  endif
  let list = systemlist("fd . --type d --hidden -E .git -E .yarn")
  let list += systemlist("fd --type f --max-depth 1")
  let p = join(list, ",")
  execute("set path=" . p)
endfunction

" Apply macro on selected lines
"--------------------------------------------------------------------------------
function! misc#ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" Delete trailing whitespaces in a whole buffer
function! misc#DeleteTrailingWS() abort
  normal mz
  %s/\v\s+$//ge
  normal `z
endfunc


" Zoom / Restore window
function! misc#ZoomToggle() abort
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


" Auto switching IME
"--------------------------------------------------------------------------------
function! misc#Ime_en()
  let ts = localtime()
  let input_status = system('im-select')
  if input_status =~ "com.apple.keylayout.ABC"
    let b:inputtoggle = 0
  else
    let b:inputtoggle = 1
    call system('im-select com.apple.keylayout.ABC') "use en ime
  endif
endfunction

function! misc#Ime_zh()
  try
    if b:inputtoggle == 1
      " Restore previous IME
      call system('im-select com.apple.inputmethod.SCIM.ITABC')
    endif
  catch /inputtoggle/
    let b:inputtoggle = 0
  endtry
endfunction


" Search for visually selected text
function! s:getSelectedText()
  let l:old_reg = getreg('"')
  let l:old_regtype = getregtype('"')
  norm gvy
  let l:ret = getreg('"')
  call setreg('"', l:old_reg, l:old_regtype)
  exe "norm \<Esc>"
  return l:ret
endfunction

function! misc#SearchVisualTextDown()
  call setreg("/", substitute(<SID>getSelectedText(), '\_s\+', '\\_s\\+', 'g'))
  norm n
endfunction

function! misc#SearchVisualTextUp()
  call setreg("/", substitute(<SID>getSelectedText(), '\_s\+', '\\_s\\+', 'g'))
  norm N
endfunction
