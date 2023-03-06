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
