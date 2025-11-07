-- find plugins
local plugins = require("lazy").plugins()
for _, plugin in pairs(plugins) do
  if plugin.name:match("telescope.nvim") then
    put(plugin.name)
  end
end
