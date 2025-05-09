function! Tasty()
  echo "Tasty " . line('.')
endfunction

" 5,10call Tasty()

function! Buffet(...)
  return a:1 . " " . a:2
endfunction

" echo Buffet("Noodles", "Sushi")

function! Breakfast() range
  echo "Breakfast: " . a:firstline . "  " .  a:lastline
endfunction

call Breakfast()

5,6call Breakfast()

" returns "Noodles Sushi"
" vim9
" def Min(num1: number, num2: number): number
"   var smaller: number
"   if num1 < num2
"     smaller = num1
"   else
"     smaller = num2
"   endif
"   return smaller
" enddef
