" keep default value
let s:current_font = &guifont

" command
" command! -narg=0 ZoomIn    :call s:ZoomIn()
" command! -narg=0 ZoomOut   :call s:ZoomOut()
" command! -narg=0 ZoomReset :call s:ZoomReset()

" guifont size + 1
function! zoom#ZoomIn()
  let l:fsize = substitute(&guifont, '^.*:h\([^:]*\).*$', '\1', '')
  let l:fsize += 1
  let l:guifont = substitute(&guifont, ':h\([^:]*\)', ':h' . l:fsize, '')
  echom l:guifont
  let &guifont = l:guifont
endfunction

" guifont size - 1
function! zoom#ZoomOut()
  let l:fsize = substitute(&guifont, '^.*:h\([^:]*\).*$', '\1', '')
  let l:fsize -= 1
  let l:guifont = substitute(&guifont, ':h\([^:]*\)', ':h' . l:fsize, '')
  echom l:guifont
  let &guifont = l:guifont
endfunction

" reset guifont size
function! zoom#ZoomReset()
  let &guifont = s:current_font
endfunction

" vim: set ff=unix et ft=vim nowrap :
