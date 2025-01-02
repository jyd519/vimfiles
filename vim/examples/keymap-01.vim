" <count>CMD
func! s:test1()
  echo 'test1() ' . v:count
endfunc
" map ,tt :<c-u>call <SID>test1()<CR>


func! s:test2() range
  echom 'Test ' . a:firstline . ' > ' . a:lastline
endfunc

map ,tt :<c-u>call <SID>test2()<CR>
vmap ,tt :<c-u>'<,'>call <SID>test2()<CR>
