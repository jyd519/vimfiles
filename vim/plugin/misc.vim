" Convert selected text to javascript string
"--------------------------------------------------------------------------------
function! s:ToJS(sep, first_line, last_line)
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
command!  -nargs=1 -range ToJs call s:ToJS(<q-args>, <line1>, <line2>)


" Quick unescape xml entities
"--------------------------------------------------------------------------------
function! XmlUnescape()
  silent! execute ':%s/&lt;/</g'
  silent! execute ':%s/&gt;/>/g'
  silent! execute ':%s/&amp;/\&/g'
endfunction
command! -nargs=0 XmlUnescape :call XmlUnescape()

" Unescape \uXXXX sequences in selected lines
"--------------------------------------------------------------------------------
function! UnescapeUnicode() range
  let cmd = a:firstline . "," . a:lastline . 's/\\u\(\x\{4\}\)/\=nr2char("0x".submatch(1),1)/g'
  silent! execute cmd
endfunction
command! -nargs=0 -range=% UnescapeUnicode :<line1>,<line2>call UnescapeUnicode()

" Convert rows of numbers or text (as if pasted from excel column) to a tuple
"--------------------------------------------------------------------------------
function! ToTupleFunction() range
  silent execute a:firstline . "," . a:lastline . "s/^/'/"
  silent execute a:firstline . "," . a:lastline . "s/$/',/"
  silent execute a:firstline . "," . a:lastline . "join"
  silent execute "normal I("
  silent execute "normal $xa)"
  silent execute "normal ggVGYY"
endfunction
command! -range ToTuple <line1>,<line2> call ToTupleFunction()

" Dot
"--------------------------------------------------------------------------------
function! Dot(bang, format)
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
command! -nargs=* -bang Dot :call Dot(<bang>0, <q-args>)|redraw!
