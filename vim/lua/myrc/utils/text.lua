local M = {}

function M.getCurrentParagraph()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  -- search forward
  local rowi = row
  while true do
    local lastLine = vim.api.nvim_buf_get_lines(0, rowi, rowi + 1, false) or { "" }
    if lastLine[1] == "" then break end
    if lastLine[1] == nil then break end
    rowi = rowi + 1
  end

  -- search back
  local rowj = row > 1 and row - 1 or row
  while true do
    local lastLine = vim.api.nvim_buf_get_lines(0, rowj, rowj + 1, false) or { "" }
    if lastLine[1] == "" then break end
    if lastLine[1] == nil then break end
    rowj = rowj - 1
    if rowj < 1 then break end
  end

  local lines = vim.api.nvim_buf_get_lines(0, rowj + 1, rowi, false)
  local result = table.concat(lines, " ")
  result = result:gsub("[%c]", "")

  return result
end

return M
