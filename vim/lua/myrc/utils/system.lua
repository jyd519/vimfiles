local M = {}

M.system_open = function(path)
  local sysname = vim.loop.os_uname().sysname
  if sysname:match("Windows") then
    -- Windows: Without removing the file from the path, it opens in code.exe instead of explorer.exe
    local p
    local lastSlashIndex = path:match("^.+()\\[^\\]*$") -- Match the last slash and everything before it
    if lastSlashIndex then
      p = path:sub(1, lastSlashIndex - 1) -- Extract substring before the last slash
    else
      p = path -- If no slash found, return original path
    end
    vim.cmd("silent !start explorer " .. p)
    return
  end

  if sysname:match("Darwin") then vim.fn.jobstart({ "open", path }, { detach = true }) end
  if sysname:match("Linux") then vim.fn.jobstart({ "xdg-open", path }, { detach = true }) end
end

return M
