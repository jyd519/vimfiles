local fn = vim.fn
local g = vim.g

return {
  -- Startup {{{2
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
  -- }}}
  -- Utils {{{2
  {
    "folke/which-key.nvim",
    config = true,
    cmd = { "WhichKey" },
  },
  { "nvim-lua/plenary.nvim", lazy = true }, -- some useful lua functions
  {
    "christoomey/vim-tmux-navigator",
    init = function()
      g.tmux_navigator_disable_when_zoomed = 1
      g.tmux_navigator_no_mappings = 1
    end,
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
  {
    "anuvyklack/keymap-amend.nvim",
    priority = 100,
    config = function()
      local amend = require("keymap-amend")
      vim.keymap.amend = amend

      -- Cancel search highlighting
      amend("n", "<Esc>", function(original)
        if vim.v.hlsearch and vim.v.hlsearch == 1 then vim.cmd("nohlsearch") end
        original()
      end, { desc = "Clear Search Highlight" })
    end,
  },
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
    opts = {
      -- https://github.com/nvim-tree/nvim-web-devicons
      -- https://www.nerdfonts.com/font-downloads
      color_icons = true,
      default = true,
    },
    config = true,
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
  -- ALE {{{2
  {
    "dense-analysis/ale", -- linter
    init = function()
      g.ale_enabled = 1
      g.ale_disable_lsp = 1
      g.ale_use_neovim_diagnostics_api = vim.g.is_nvim
      g.ale_set_quickfix = 0
      g.ale_set_loclist = 1
      g.ale_open_list = 1
      g.ale_lint_on_enter = 0
      g.ale_lint_on_text_changed = "never"
      g.ale_lint_on_insert_leave = 0
      g.ale_lint_on_save = 0
      g.ale_maximum_file_size = 256000
      g.ale_echo_msg_format = "[%linter%] %s [%severity%]"
      g.ale_echo_msg_error_str = "E"
      g.ale_echo_msg_warning_str = "W"
      g.ale_objcpp_clang_options = "-std=c++17 -Wall"
      g.ale_cpp_cc_options = "-std=c++17 -Wall"
      g.ale_c_cc_options = "-std=c11 -Wall"
      g.ale_python_mypy_options = "--follow-imports=silent"
      g.ale_pattern_options_enabled = 1
      g.ale_linters = {
        javascript = { "eslint" },
        typescript = { "eslint" },
        python = { "ruff", "pylint", "mypy", "black" },
        go = { "gofmt", "golint", "gopls", "govet", "golangci-lint" },
      }
      g.ale_pattern_options = {
        ["\\.min\\.js$"] = { ale_enabled = 0 },
        ["\\.min\\.css$"] = { ale_enabled = 0 },
      }
      g.ale_fixers = {
        ["*"] = { "remove_trailing_lines", "trim_whitespace" },
        javascript = { "eslint", "prettier" },
        typescript = { "eslint", "prettier" },
        python = { "ruff", "black", "yapf", "isort" },
      }
    end,
    lazy = true,
    cmd = { "ALEToggle", "ALEInfo", "ALEDetail", "ALELint", "ALEFix" },
    keys = { "<Plug>(ale_lint)", "<Plug>(ale_fix)" },
  },
  -- }}}
  -- emoji {{{2
  {
    "allaman/emoji.nvim",
    version = "*",
    ft = { "markdown", "typescript", "text", "lua" }, -- adjust to your needs
    opts = {
      -- default is false
      enable_cmp_integration = false,
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
  -- }}}
  -- Project {{{2
  {
    "https://github.com/ahmedkhalf/project.nvim",
    config = function() require("project_nvim").setup({ manual_mode = true }) end,
  },
  -- }}}
}

-- vim: fdm=marker fdl=1:
