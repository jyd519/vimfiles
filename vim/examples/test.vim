function! Ta() range
  echom a:firstline. " , " . a:lastline
endfunction

command! -nargs=0 -range=% AA :<line1>,<line2>call Ta()
