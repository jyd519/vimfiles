-- command! -nargs=1 -range -complete=customlist,s:snippet_files TS call SaveTemplate(<q-args>)
-- command! -nargs=1 -bang -complete=customlist,s:snippet_files T call InsertTemplate(<q-args>)
vim.cmd([[
  command! -nargs=1 -bang -complete=customlist,v:lua.require't'.populate_files T lua require("t").insert_tpl(<f-args>)
  command! -nargs=1 -range -complete=customlist,v:lua.require't'.populate_files TS  lua require("t").save_tpl(<f-args>)
]])