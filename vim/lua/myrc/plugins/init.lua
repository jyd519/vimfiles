local g, fn = vim.g, vim.fn

return {
  {
    "mhinz/vim-startify",
    init = function()
      g.startify_change_to_dir = 0
      g.startify_change_to_vcs_root = 1
      g.startify_files_number = 5
    end,
  },
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    init = function() vim.g.startuptime_tries = 10 end,
  },
  -- Utils {{{2
  {
    "folke/which-key.nvim",
    config = true,
    cmd = {"WhichKey"},
  },
  { "nvim-lua/plenary.nvim", lazy = true }, -- some useful lua functions
  {
    "christoomey/vim-tmux-navigator",
    enabled = fn.has("win32") == 0 and fn.executable("tmux") == 1,
  },
  {
    "ojroques/nvim-osc52",
    event = "VimEnter",
    enabled = vim.fn.has("nvim-0.10") == 0 and g.enabled_plugins.osc == 1,
    config = function()
      require("osc52").setup()
      vim.keymap.set("v", "<leader>y", require("osc52").copy_visual)
      vim.cmd([[
          autocmd vimrc TextYankPost * lua require("osc52").copy_visual()
        ]])
    end,
  },
  { "tpope/vim-unimpaired", event = "VeryLazy" },
  { "tpope/vim-scriptease", lazy = true, cmd = "Breakadd" },
  -- }}}
  -- Basic plugins {{{2
  "anuvyklack/keymap-amend.nvim",
  { "doums/rg.nvim", cmd = { "Rg", "Rgf", "Rgp", "Rgfp" } },
  { "AndrewRadev/splitjoin.vim", event = "VeryLazy" },
  { "tmhedberg/matchit", event = "VeryLazy" },
  { "junegunn/vim-easy-align", event = { "BufReadPost", "BufNewFile" } },
  { "godlygeek/tabular", cmd = "Tabularize" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "chiedojohn/vim-case-convert", event = "VeryLazy" },
  { "nvim-mini/mini.nvim", version = false },
  { "gpanders/editorconfig.nvim", enabled = vim.fn.has("nvim-0.9") == 0 },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = function()
      require("nvim-web-devicons").setup({
        -- https://github.com/nvim-tree/nvim-web-devicons
        -- https://www.nerdfonts.com/font-downloads
        color_icons = true,
        default = true,
      })
    end,
  },
  -- }}}
  -- Locals {{{2
  { dir = g.VIMFILES .. "/locals/t.nvim", cmd = { "T", "TS" } },
  { dir = g.VIMFILES .. "/locals/vim-a", cmd = { "A", "AH" } },
  { dir = g.VIMFILES .. "/locals/nvim-projectconfig", opts = { silent = false } },
  -- }}}

  -- vim-on-browser {{{2
  {
    "glacambre/firenvim",
    build = ":call firenvim#install(0)",
    enabled = false,
    config = function()
      vim.g.firenvim_config = {
        localSettings = { [".*"] = { takeover = "never" } },
      }
    end,
  },
  {
    "subnut/nvim-ghost.nvim",
    enabled = vim.g.enabled_plugins["ghost_text"] == 1,
    init = function() vim.g.nvim_ghost_autostart = 0 end,
    keys = {
      {
        "<leader>ug",
        function()
          if vim.fn.exists(":GhostTextStart") == 2 then
            vim.cmd("GhostTextStart")
            vim.notify("GhostText Started")
          else
            vim.cmd("GhostTextStop")
            vim.notify("GhostText Stopped")
          end
        end,
        desc = "GhostText Toggle",
        silent = true,
      },
    },
    cmd = { "GhostTextStart", "GhostTextStop" },
  },
  -- }}}
  {
    "dense-analysis/ale", -- linter
    lazy = true,
    cmd = { "ALEToggle", "ALEInfo", "ALEDetail", "ALELint", "ALEFix" },
    keys = { "<Plug>(ale_lint)", "<Plug>(ale_fix)" },
  },
  {
    "allaman/emoji.nvim",
    version = "*",
    ft = { "markdown", "typescript", "text", "lua" }, -- adjust to your needs
    opts = {
      -- default is false
      enable_cmp_integration = true,
      picker = { enabeld = true },
      -- optional if your plugin installation directory
      -- is not vim.fn.stdpath("data") .. "/lazy/
      plugin_path = g.VIMFILES .. "/lazy/",
    },
    config = function(_, opts)
      require("emoji").setup(opts)
      vim.keymap.set("n", "<leader>se", function() require("emoji").insert() end, { desc = "[S]earch [E]moji" })
    end,
  },
  {
    "https://github.com/ahmedkhalf/project.nvim",
    config = function() require("project_nvim").setup({ manual_mode = true }) end,
  },
  -- }}}
}

-- vim: et:fdm=marker:
