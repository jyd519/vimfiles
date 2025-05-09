" Make sure Python is ready
if !has("python")
  echo "vim has to be compiled with +python to run this"
  finish
endif

python << en
import vim
def getWordUnderCursor():
  return vim.eval("expand('<cWORD>')")

def test():
  w = getWordUnderCursor()
  #print w
  #vim.command( "redraw" ) # discard previous messages
  vim.current.buffer.append(80*"-")
en

" nmap <silent> ,TT :python test()<CR>
"
"
function! SomeName(arg1, arg2, arg3)
  " Get the first argument by name in VimL
  let firstarg=a:arg1

  " Get the second argument by position in Viml
  let secondarg=a:arg2

  " Get the arguments in python
  python << EOF
import vim

first_argument = vim.eval("a:arg1") 
second_argument = vim.eval("a:arg2")
print first_argument, second_argument
EOF

endfunction
