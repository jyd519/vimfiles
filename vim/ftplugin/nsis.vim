if exists('did_nsis_vim') || &cp || version < 700
  finish
endif
let did_nsis_vim = 1

"NSIS
"--------------------------------------------------------------------------------
"
function! Makensis(arg)
  let l:path = expand("%:p")
  let l:cmd="!cmd /k \"setnsis && makensis " . a:arg . " " . iconv(l:path, "utf8", "cp936") . "\""
  execute l:cmd
endfunction

setlocal foldmethod=syntax
colorscheme vc

nmap <buffer> <F9> :update<cr>:call Makensis("/DMYDEBUG")<cr>

