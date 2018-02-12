function! Infect(...)
  echo a:0   
  " => 2
  echo a:1    
  " => jake
  echo a:2    
  " => bella

  for s in a:000  " a list
    echon ' ' . s
  endfor
endfunction

call Infect('jake', 'bella')
