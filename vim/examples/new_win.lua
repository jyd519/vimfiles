local ft = vim.bo.filetype
local config = vim.deepcopy(dap.configurations[ft])
if not config then
  print(">>> no configuration for " .. ft)
  return
end

local buf = -1
for _, value in pairs(vim.api.nvim_list_bufs()) do
  local name = vim.api.nvim_buf_get_name(value)
  if vim.api.nvim_buf_is_loaded(value) and vim.fn.fnamemodify(name, ":t") == "config.lua" then
    buf = value
    break
  end
end

if buf < 0 then
  vim.cmd('vsplit')
  local win = vim.api.nvim_get_current_win()
  buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(buf, "config.lua")
  vim.api.nvim_buf_set_option(buf, "filetype", "lua")
  vim.api.nvim_win_set_buf(win, buf)
else
 if vim.fn.getbufinfo(buf)[1].hidden == 1 then
    local win = vim.fn.getbufinfo(buf)[1].windows[1]
    vim.cmd('vsplit')
    win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
 end
end

for _, c in pairs(config) do
  for k, v in pairs(c) do
     if type(v) == "function" then
       c[k] = "<THIS IS A FUNCTION>"
     end
  end
end

local text = vim.inspect(config)
local lines = vim.split(text, '\n')
lines[1] =  "local configs = " .. lines[1]

table.insert(lines, "dap.configurations." .. vim.bo.filetype .. "= configs")
vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
