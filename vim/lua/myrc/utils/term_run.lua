local M = {}

function M.gulp(args)
  local Terminal = require("toggleterm.terminal").Terminal
  local t = {"gulp"}
  for _, v in ipairs(args) do
    table.insert(t, v)
  end
  local cmd = table.concat( t, " ")
  Terminal:new({ cmd = cmd, hidden = true, close_on_exit = false }):toggle()
end

return M
