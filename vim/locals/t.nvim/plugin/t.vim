" mysnippets template
"
" Author: jyd119@qq.com
" Supports two commands:
"   T *     load snippets
"   TS xxx  save selection as xxx

command! -nargs=1 -bang -complete=customlist,v:lua.require'myrc.t'.populate_files T lua require("myrc.t").insert_tpl(<f-args>)
command! -nargs=1 -range -complete=customlist,v:lua.require'myrc.t'.populate_files TS lua require("myrc.t").save_tpl(<f-args>)

