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
    "nvim-treesitter/nvim-treesitter",
    main = "nvim-treesitter",
    branch = "main",
    config = function() require("myrc.config.treesitter") end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    enabled = false,
  },
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
  {
    "smoka7/hop.nvim",
    version = "*",
    event = "VeryLazy",
    config = function() require("myrc.config.hop") end,
  },
  { "doums/rg.nvim", cmd = { "Rg", "Rgf", "Rgp", "Rgfp" } },
  { "AndrewRadev/splitjoin.vim", event = "VeryLazy" },
  { "tmhedberg/matchit", event = "VeryLazy" },
  { "junegunn/vim-easy-align", event = { "BufReadPost", "BufNewFile" } },
  { "godlygeek/tabular", cmd = "Tabularize" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "chiedojohn/vim-case-convert", event = "VeryLazy" },
  {
    "chentoast/marks.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "MarksListBuf" },
    config = function() require("myrc.config.marks") end,
  },
  { "nvim-mini/mini.nvim", version = false },
  { "gpanders/editorconfig.nvim", enabled = vim.fn.has("nvim-0.9") == 0 },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function() require("myrc.config.surround") end,
  },
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
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function() require("myrc.config.notify") end,
  },
  { dir = g.VIMFILES .. "/locals/t.nvim", cmd = { "T", "TS" } },
  { dir = g.VIMFILES .. "/locals/vim-a", cmd = { "A", "AH" } },
  { dir = g.VIMFILES .. "/locals/nvim-projectconfig", opts = { silent = false } },
  -- }}}

  -- Coding {{{2
  { "thinca/vim-quickrun", cmd = { "QuickRun" } },
  {
    "jyd519/vim-test", -- Unit-Testing
    enabled = g.enabled_plugins.test == 1,
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function() require("myrc.config.indent-blankline") end,
  },
  {
    "akinsho/toggleterm.nvim",
    branch = "main",
    event = "VeryLazy",
    config = function() require("myrc.config.toggleterm") end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewFileHistory",
    },
  },
  -- }}}
  -- DAP Debugging {{{2
  {
    "mfussenegger/nvim-dap",
    event = { "BufReadPost", "BufNewFile" },
    ft = { "go", "python", "lua", "rust", "typescript", "javascript" },
    config = function() require("myrc.config.dap") end,
    dependencies = {
      { "theHamsta/nvim-dap-virtual-text" },
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      { "mfussenegger/nvim-dap-python" },
      { "nvim-telescope/telescope-dap.nvim" },
      { "leoluz/nvim-dap-go" },
      { "jbyuki/one-small-step-for-vimkind", module = "osv" },
    },
  },
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
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    config = function() require("myrc.config.clangd") end,
  },
  { "pearofducks/ansible-vim", ft = { "yaml", "ansible", "ansible_hosts" } },
  {
    "dense-analysis/ale", -- linter
    lazy = true,
    cmd = { "ALEToggle", "ALEInfo", "ALEDetail", "ALELint", "ALEFix" },
    keys = { "<Plug>(ale_lint)", "<Plug>(ale_fix)" },
  },
  -- Markdown, reStructuredText, textile
  {
    "yaocccc/nvim-hl-mdcodeblock.lua",
    enabled = false,
    after = "nvim-treesitter",
    config = function() require("hl-mdcodeblock").setup({}) end,
  },
  { "img-paste-devs/img-paste.vim", ft = "markdown" },
  -- }}}
  -- Snippets {{{2
  {
    "SirVer/ultisnips",
    lazy = true,
    enabled = g.enabled_plugins.python == 1 and vim.fn.has("python3") == 1,
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    dependencies = {
      { "rafamadriz/friendly-snippets" },
      { "honza/vim-snippets" },
    },
    config = function() require("myrc.config.luasnip") end,
  },
  -- }}}
  -- Completion Engine {{{2
  {
    "hrsh7th/nvim-cmp",
    event = "VeryLazy",
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "yehuohan/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-nvim-lua" },
      -- { "Snikimonkd/cmp-go-pkgs" }, broken with nvim-treesitter
      -- { "hrsh7th/cmp-nvim-lsp-document-symbol" },
      -- { "quangnguyen30192/cmp-nvim-tags", ft = { "c", "cpp" } },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "rcarriga/cmp-dap" },
    },
    config = function() require("myrc.config.cmp") end,
  },
  -- }}}
  -- LSP {{{2
  {
    "neovim/nvim-lspconfig",
    -- event = { "BufReadPost", "BufNewFile" },
    config = function() require("myrc.config.lsp") end,
    dependencies = {
      -- TODO
      -- { "folke/neodev.nvim", lazy = true },
      { "mason-org/mason.nvim", cmd = "Mason", config = true },
      { "mason-org/mason-lspconfig.nvim" },
    },
  },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { { "<leader>to", "<cmd>Outline<CR>", desc = "Toggle outline" } },
    config = function() require("myrc.config.symbols-outline") end,
  },
  { "b0o/schemastore.nvim", lazy = true },
  {
    "Bekaboo/dropbar.nvim",
    config = function()
      local dropbar_api = require("dropbar.api")
      vim.keymap.set("n", "<leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
      vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
      vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
    end,
  },
  -- }}}
  -- File explorer/Fuzzy Finder {{{2
  {
    "nvim-tree/nvim-tree.lua",
    cond = false,
    event = "VeryLazy",
    version = "*",
    config = function() require("myrc.config.nvim-tree") end,
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
  {
    -- https://github.com/tomasky/bookmarks.nvim
    "tomasky/bookmarks.nvim",
    keys = { "mm", "mt", "ml", "mc" },
    config = function() require("myrc.config.bookmarks") end,
  },
  -- }}}
}

-- vim: et:fdm=marker:
