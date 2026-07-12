local g = vim.g

-- Bootstrap lazy.nvim
local lazypath = g.VIMFILES .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath .. "/lua") then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  root = g.VIMFILES .. "/lazy",
  spec = {
    { import = "myrc.plugins" },
  },
  dev = {
    -- path = g.VIMFILES .. "/locals",
  },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      reset = false, -- no reset the runtime path to $VIMRUNTIME and your config directory
    },
  },
  rocks = {
    enabled = false,
    -- use hererocks to install luarocks?
    -- set to `nil` to use hererocks when luarocks is not found
    -- set to `true` to always use hererocks
    -- set to `false` to always use luarocks
    hererocks = nil,
  },
  install = {
    missing = vim.env.SSH_CONNECTION == nil,
  },
  readme = {
    enabled = true,
    root = vim.fs.joinpath(vim.g.VIMFILES, "doc"),
    files = { "README.md", "lua/**/README.md" },
    -- only generate markdown helptags for plugins that don't have docs
    skip_if_doc_exists = false,
  },
  -- Unicode symbols. No need Nerd Font
  ui = {
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})

function _G.is_plugin_loaded(name)
  local plugins = require("lazy").plugins()
  for _, plugin in pairs(plugins) do
    if vim.stricmp(plugin.name, name) == 0 then return not not plugin._.loaded end
  end
  return false
end
function _G.has_plugin(name)
  local plugins = require("lazy").plugins()
  for _, plugin in pairs(plugins) do
    if vim.stricmp(plugin.name, name) == 0 then return true end
  end
  return false
end
