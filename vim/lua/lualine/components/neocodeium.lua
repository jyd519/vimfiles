local M = require("lualine.component"):extend()

local symbols = {
  status = {
    [0] = "󰚩 ", -- Enabled
    [1] = "󱚧 ", -- Disabled Globally
    [2] = "󱙻 ", -- Disabled for Buffer
    [3] = "󱙺 ", -- Disabled for Buffer filetype
    [4] = "󱙺 ", -- Disabled for Buffer with enabled function
    [5] = "󱚠 ", -- Disabled for Buffer encoding
    [6] = "󱚠 ", -- Buffer is special type
  },

  server_status = {
    [0] = "󰣺 ", -- Connected
    [1] = "󰣻 ", -- Connecting
    [2] = "󰣽 ", -- Disconnected
  },
}

function M:init(options)
  M.super.init(self, options)
  vim.api.nvim_create_autocmd("User", {
    pattern = { "NeoCodeiumServer*", "NeoCodeium*{En,Dis}abled" },
    callback = function()
      require("lualine").refresh()
    end,
  })
end

function M:update_status()
  local ok, neocodeium = pcall(require, "neocodeium")
  if not ok then
    return ""
  end
  local status, server_status = neocodeium.get_status()
  return symbols.status[status] .. symbols.server_status[server_status]
end

return M
