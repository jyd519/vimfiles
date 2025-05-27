-- Install lazy.nvim {{{2
local fn = vim.fn
local g = vim.g
if g.cfg_install_missing_plugins == nil then g.cfg_install_missing_plugins = 1 end

local lazypath = g.VIMFILES .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath .. "/lua") then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- 2}}}

-- Plugins
require("lazy").setup(
  {
    {
      "nvim-treesitter/nvim-treesitter",
      event = { "BufReadPost", "BufNewFile" },
      config = function() require("myrc.config.treesitter") end,
    },
    { "tpope/vim-unimpaired", event = "VeryLazy" },
    { "tpope/vim-scriptease", lazy = true, cmd = "Breakadd" },
    "anuvyklack/keymap-amend.nvim",
    {
      "smoka7/hop.nvim",
      version = "*",
      event = "VeryLazy",
      config = function() require("myrc.config.hop") end,
    },
    { "mattn/emmet-vim", ft = { "html", "jsx", "vue", "javascriptreact", "javascript", "css", "scss" } },
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        require("nvim-autopairs").setup({
          map_cr = false,
          disable_in_visualblock = true,
          fast_wrap = {},
        })
      end,
    },
    { "AndrewRadev/splitjoin.vim", event = "VeryLazy" },
    { "tmhedberg/matchit", event = "VeryLazy" },
    { "junegunn/vim-easy-align", event = { "BufReadPost", "BufNewFile" } },
    { "godlygeek/tabular", cmd = "Tabularize" },
    { "tpope/vim-repeat", event = "VeryLazy" },
    { "chiedojohn/vim-case-convert", event = "VeryLazy" },
    { "numToStr/Comment.nvim", event = "VeryLazy", config = true },
    {
      "kylechui/nvim-surround",
      event = { "BufReadPost", "BufNewFile" },
      config = function() require("myrc.config.surround") end,
    },
    { dir = g.VIMFILES .. "/locals/vim-a", cmd = { "A", "AH" } },
    { "jyd519/neoformat", cmd = { "Neoformat" } },
  },
  -- Lazy configurations {{{2
  {
    root = g.VIMFILES .. "/lazy",
    performance = {
      rtp = {
        reset = false, -- no reset the runtime path to $VIMRUNTIME and your config directory
      },
    },
    install = {
      -- skip installing missing dependencies when running in a ssh session
      missing = vim.env.SSH_CONNECTION == nil,
    },
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
        source = "📄",
        start = "🚀",
        task = "📌",
        lazy = "💤 ",
      },
    },
    readme = {
      enabled = true,
      root = vim.fs.joinpath(vim.g.VIMFILES, "doc"),
      files = { "README.md", "lua/**/README.md" },
      -- only generate markdown helptags for plugins that don't have docs
      skip_if_doc_exists = false,
    },
  }
  -- }}}
)

-- vim: set fdm=marker fdl=1: }}}
