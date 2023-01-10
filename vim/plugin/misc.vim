command! -range ToTuple <line1>,<line2> call misc#ToTupleFunction()
command! -nargs=0 -range=% UnescapeUnicode :<line1>,<line2>call misc#UnescapeUnicode()
command! -nargs=0 XmlUnescape :call misc#XmlUnescape()
command! -nargs=1 -range ToJs call misc#ToJS(<q-args>, <line1>, <line2>)
command! -nargs=* -bang Dot :call misc#Dot(<bang>0, <q-args>)|redraw!
command! -nargs=0 AddPath :call misc#SetPath()

xnoremap @ :<C-u>call misc#ExecuteMacroOverVisualRange()<CR>

