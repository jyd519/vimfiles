local snippets_dir = vim.api.nvim_eval("g:mysnippets_dir")
if snippets_dir == "" then
  snippets_dir = vim.api.nvim_eval("expand('$SNIPPETS_DIR')")
end