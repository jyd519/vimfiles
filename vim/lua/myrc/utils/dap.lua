local M = {}

local dap = require("dap")

-- python3 -m debugpy  --listen 0.0.0.0:5678 manage.py runserver 0.0.0.0:8088 --nothreading --noreload
--
-- local dap = require("dap")
-- dap.adapters.pythonServer = {
--     type = "server",
--     host = "127.0.0.1",
--     port = "5678",
--     options = {
--       source_filetype = 'python',
--     }
-- }
-- local daputil = require("myrc.utils.dap")
-- daputil.add("python", {
--     -- The first three options are required by nvim-dap
--     type = "pythonServer", -- the type here established the link to the adapter definition: `dap.adapters.python`
--     request = "attach",
--     name = "Attach remote Process",
--     -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
--     connect = {
--         host = "127.0.0.1",
--         port = 5678,
--     },
--     pathMappings = {
--       {
--         localRoot= "${workspaceFolder}",
--         remoteRoot= "/home/joycloud/joycloud"
--       }
--     },
--     justMyCode = false,
-- })

---@param language string
---@param setting table
M.add = function(language, setting)
  for i = #dap.configurations[language], 1, -1 do
    if dap.configurations.python[i].name == setting.name then
      table.remove(dap.configurations[language], i)
    end
  end
  table.insert(dap.configurations[language], setting)
end

return M
