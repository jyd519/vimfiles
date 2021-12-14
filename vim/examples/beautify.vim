"--------------------------------------------------------------------------------
"jsbeautify settings
"--------------------------------------------------------------------------------

if exists('beautify_plugin_loaded')
  finish
endif 
let beautify_plugin_loaded = 1

function! s:JBeautify()
  if &ft ==? 'css'
    call CSSBeautify()
  elseif &ft ==? 'html' || &ft ==? 'xhtml'
    call HtmlBeautify()
  elseif &ft =~ 'javascript' || &ft =~ 'typescript'
    call JsBeautify()
  elseif &ft ==? 'json'
    call JsonBeautify()
  else
     echom 'JSBeautify: ' . &ft . ' is not supported'
  endif
endfunction

nnoremap <leader>jb :call <SID>JBeautify()<CR>
