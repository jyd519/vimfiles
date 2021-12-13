local function get_sel_text()
  local line1 = vim.api.nvim_buf_get_mark(0, "<")[1]
  local line2 = vim.api.nvim_buf_get_mark(0, ">")[1]
  return vim.api.nvim_buf_get_lines(0, line1-1, line2, false)
end