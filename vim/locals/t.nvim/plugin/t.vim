" mysnippets template
"
" Author: jyd119@qq.com
" Supports two commands:
"   T *     load snippets
"   TS xxx  save selection as xxx

command! -nargs=1 -bang -complete=customlist,v:lua.require't'.populate_files T lua require("t").insert_tpl(<f-args>)
command! -nargs=1 -range -complete=customlist,v:lua.require't'.populate_files TS lua require("t").save_tpl(<f-args>)

