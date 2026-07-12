local put = function(...)
  -- print(vim.inspect({...}))
  local objects = {}
  for i = 1, select("#", ...) do
    local val = select(i, ...)
    if val == nil then
      objects[i] = "nil"
    elseif type(val) == "string" then
      objects[i] = val
    else
      objects[i] = vim.inspect(val, { newline = " ", indent = "", depth = 4 })
    end
  end
  print(table.concat(objects, ","))
end

-- find plugins
local plugins = require("lazy").plugins()
for _, plugin in pairs(plugins) do
  if vim.stricmp(plugin.name, "TELESCOPE.nvim") == 0 then put("Find>>>", plugin.name, not not plugin._.loaded) end
end

local g, fn = vim.g, vim.fn
local function is_plugin_loaded(name)
  local Config = require("lazy.core.config")
  return Config.plugins[name] and Config.plugins[name]._.loaded
end
_G.is_plugin_loaded = is_plugin_loaded

local Config = require("lazy.core.config")
for k, i in pairs(Config.plugins) do
  put(k, not not i._.loaded)
end
