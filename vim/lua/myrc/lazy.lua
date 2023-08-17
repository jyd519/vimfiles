-- Install lazy.nvim {{{2
local fn = vim.fn
local g = vim.g

local lazypath = g.VIMFILES .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
    -- Utils {{{2
    { "nvim-lua/plenary.nvim", lazy = true }, -- some useful lua functions
    {
      "nvim-treesitter/nvim-treesitter",
      version = false,
      event = { "BufReadPost", "BufNewFile" },
      config = function()
        require("myrc.config.treesitter")
      end,
    },
    {
      "dstein64/vim-startuptime",
      cmd = "StartupTime",
      init = function()
        vim.g.startuptime_tries = 10
      end,
    },
    { "christoomey/vim-tmux-navigator", enabled = fn.has("win32") == 0 and fn.executable("tmux") == 1 },
    {
      "ojroques/nvim-osc52",
      event = "VimEnter",
      enabled = vim.env.SSH_CLIENT ~= nil,
      config = function()
        require("osc52").setup()
        vim.keymap.set("v", "<leader>y", require("osc52").copy_visual)
        vim.cmd[[
          autocmd vimrc TextYankPost * lua require("osc52").copy_visual()
        ]]
      end,
    },
    -- }}}
    -- Colorschemes {{{2
    { "Mofiqul/vscode.nvim" },
    { "NLKNguyen/papercolor-theme" },
    { "rebelot/kanagawa.nvim" },
    { "navarasu/onedark.nvim" },
    {
      "catppuccin/nvim",
      name = "catppuccin",
      config = function()
        require("catppuccin").setup({
          flavour = "latte", -- latte, frappe, macchiato, mocha
          background = {
            light = "latte",
            dark = "mocha",
          },
          transparent_background = true,
        })
      end,
    },
    {
      "marko-cerovac/material.nvim",
      config = function()
        vim.g.material_style = "lighter"
      end,
    },
    -- }}}
    -- Basic plugins {{{2
    "mhinz/vim-startify",
    "anuvyklack/keymap-amend.nvim",
    -- "justinmk/vim-sneak",
    {
      "phaazon/hop.nvim",
      event = "VeryLazy",
      config = function()
        require("myrc.config.hop")
      end,
    },
    {
      "anuvyklack/hydra.nvim",
      event = "VeryLazy",
      dependencies = {
        { "jbyuki/venn.nvim" },
      },
      config = function()
        require("myrc.config.hydra")
      end,
    },
    { "mattn/emmet-vim", ft = { "html", "jsx", "vue" } },
    {
      "echasnovski/mini.nvim",
      version = "*",
      event = "VeryLazy",
      enabled = false,
      config = function(_, opts)
        -- https://github.com/echasnovski/mini.nvim
        require("mini.pairs").setup(opts)
      end,
    },
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        require("nvim-autopairs").setup({
          map_cr = false,
        })
      end,
    },

    { "AndrewRadev/splitjoin.vim" },
    "tmhedberg/matchit",
    "junegunn/vim-easy-align",
    { "godlygeek/tabular", cmd = "Tabularize" },
    { "tpope/vim-repeat" },
    { "chiedojohn/vim-case-convert" },
    {
      "chentoast/marks.nvim",
      config = function()
        require("myrc.config.marks")
      end,
    },
    { "numToStr/Comment.nvim", config = true },
    { "gpanders/editorconfig.nvim", enabled = not vim.fn.has("nvim-0.9") },
    {
      "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
        require("myrc.config.surround")
      end,
    },
    {
      "kyazdani42/nvim-web-devicons",
      lazy = true,
      config = function()
        require("nvim-web-devicons").setup({
          -- Used by telescope
          -- https://github.com/nvim-tree/nvim-web-devicons
          -- https://www.nerdfonts.com/font-downloads
          color_icons = true,
          default = true,
        })
      end,
    },
    {
      "rcarriga/nvim-notify",
      config = function()
        require("myrc.config.notify")
      end,
    },
    { dir = g.VIMFILES .. "/locals/t.nvim", cmd = { "T", "TS" } },
    { dir = g.VIMFILES .. "/locals/vim-a", cmd = { "A", "AH" } },
    {
      dir = g.VIMFILES .. "/locals/nvim-projectconfig",
      opts = { silent = false },
      priority = 100,
    },
    -- }}}
    -- Coding {{{2
    { "thinca/vim-quickrun", cmd = { "QuickRun" } },
    { "vim-test/vim-test", event = "VimEnter" }, -- Unit-Testing
    -- https://github.com/ThePrimeagen/refactoring.nvim#installation
    {
      "ThePrimeagen/refactoring.nvim",
      config = function()
        require("telescope").load_extension("refactoring")
        vim.api.nvim_set_keymap(
          "v",
          "<leader>rf",
          "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
          { noremap = true }
        )
      end,
    },
    { "sbdchd/neoformat", cmd = { "Neoformat" } },
    {
      "lukas-reineke/indent-blankline.nvim",
      event = { "VeryLazy" },
      config = true,
      opts = {
        char = "│",
        filetype_exclude = {"qf", "markdown", "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
        -- depends on treesitter
        show_current_context = true,
        show_current_context_start = false,
      },
    },
    {
      "lewis6991/gitsigns.nvim",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        require("myrc.config.gitsigns")
      end,
    },
    {
      "Exafunction/codeium.vim",
      enabled = true,
      config = function()
        vim.g.codeium_no_map_tab = 1

        vim.keymap.set("i", "<C-g>", function()
          return vim.fn["codeium#Accept"]()
        end, { expr = true, desc = "Accept Codeium" })

        local mapkey = require("keymap-amend")
        mapkey("i", "<C-j>", function(fallback)
          if vim.b._codeium_completions ~= nil then
            return vim.fn["codeium#Clear"]()
          else
            fallback()
          end
        end, { silent = true, desc = "Clear Codeium Completions" })
      end,
    },
    {
      "github/copilot.vim",
      enabled = false,
      config = function()
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_assume_mapped = true
        vim.g.copilot_tab_fallback = ""
      end,
    },
    {
      "norcalli/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup({
          "css",
          "sass",
          "scss",
          "vue",
          "html",
          javascript = { mode = "foreground" },
          typescript = { mode = "foreground" },
        }, { mode = "background" })
      end,
    },
    -- }}}
    -- DAP Debugging {{{2
    {
      "mfussenegger/nvim-dap",
      lazy = true,
      event = "BufReadPre",
      config = function()
        require("myrc.config.dap")
      end,
    },
    "theHamsta/nvim-dap-virtual-text",
    "rcarriga/nvim-dap-ui",
    "mfussenegger/nvim-dap-python",
    "nvim-telescope/telescope-dap.nvim",
    { "leoluz/nvim-dap-go" },
    { "jbyuki/one-small-step-for-vimkind", module = "osv" },
    { "mxsdev/nvim-dap-vscode-js" },
    -- }}}
    -- Languages Go/dart/rust/cpp/typescript {{{2
    { "jose-elias-alvarez/typescript.nvim" },
    { "ray-x/guihua.lua", ft = "go" }, -- float term, codeaction and codelens gui support
    { "ray-x/go.nvim", ft = "go" },
    { "fatih/vim-go", ft = "go" }, -- run = ":GoUpdateBinaries"
    {
      "rust-lang/rust.vim",
      init = function()
        vim.g.rustfmt_autosave = 1
      end,
    },
    { "simrat39/rust-tools.nvim" },
    { "saecki/crates.nvim", config = true },
    {
      "p00f/clangd_extensions.nvim",
      ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
      config = function()
        require("myrc.config.clangd")
      end,
    },
    { "pearofducks/ansible-vim" },
    { "dense-analysis/ale", lazy = true, event = "VimEnter" }, -- linter
    -- Markdown, reStructuredText, textile
    {
        'yaocccc/nvim-hl-mdcodeblock.lua',
        enabled = false,
        after = 'nvim-treesitter',
        config = function ()
            require('hl-mdcodeblock').setup({
                -- option
            })
        end
    },
    { "jyd519/md-img-paste.vim", ft = "markdown" },
    -- }}}
    -- Snippets {{{2
    {
      "SirVer/ultisnips",
      enabled = g.enabled_plugins.python == 1 and vim.fn.has("python3") == 1,
      event = { "BufReadPre", "BufNewFile" },
    },
    {
      "L3MON4D3/LuaSnip",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        { "rafamadriz/friendly-snippets" },
        { "honza/vim-snippets" },
      },
      config = function()
        require("myrc.config.luasnip")
      end,
    },
    -- }}}
    -- Completion Engine {{{2
    {
      "hrsh7th/nvim-cmp",
      event = "VimEnter",
      dependencies = {
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-cmdline" },
        { "hrsh7th/cmp-nvim-lua" },
        { "hrsh7th/cmp-nvim-lsp-document-symbol" },
        { "quangnguyen30192/cmp-nvim-tags", ft = { "c", "cpp" } },
        { "saadparwaiz1/cmp_luasnip" },
        {
          "tzachar/cmp-tabnine",
          enabled = false,
          build = "./install.sh",
          config = function()
            require("myrc.config.tabnine")
          end,
        },
      },
      config = function()
        require("myrc.config.cmp")
      end,
    },
    -- }}}
    -- LSP {{{2
    { "williamboman/mason.nvim", config = true },
    { "williamboman/mason-lspconfig.nvim" },
    {
      "tamago324/nlsp-settings.nvim",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        require("nlspsettings").setup({
          config_home = vim.fn.stdpath("config") .. "/nlsp-settings",
          local_settings_dir = ".vim",
          local_settings_root_markers_fallback = { ".git", ".vim" },
          append_default_schemas = true,
          loader = "json",
        })
      end,
    },
    {
      "neovim/nvim-lspconfig",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        require("myrc.config.lsp")
      end,
    },
    { "folke/neodev.nvim", lazy = true },
    {
      "simrat39/symbols-outline.nvim",
      config = function()
        require("myrc.config.symbols-outline")
      end,
    },
    { "b0o/schemastore.nvim" },
    -- }}}
    -- File explorer/Fuzzy Finder {{{2
    {
      "preservim/nerdtree",
      cmd = {
        "NERDTree",
        "NERDTreeToggle",
        "NERDTreeFind",
        "NERDTreeFromBookmark",
      },
    },
    {
      "ibhagwan/fzf-lua",
      event = "VimEnter",
      enabled = fn.get(g.enabled_plugins, "fzf") == 1,
      config = function()
        -- calling `setup` is optional for customization
        require("fzf-lua").setup({
          fzf_opts = {['--layout'] = 'reverse-list'},
        })
      end
    },
    {
      "junegunn/fzf.vim",
      event = "VimEnter",
      enabled = false , -- fn.get(g.enabled_plugins, "fzf") == 1,
    },
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.2",
      dependencies = {
        { "nvim-telescope/telescope-ui-select.nvim" },
      },
      config = function()
        require("myrc.config.telescope")
      end,
    },
    {
      -- https://github.com/tomasky/bookmarks.nvim
      "tomasky/bookmarks.nvim",
      event = "VimEnter",
      config = function()
        require("bookmarks").setup({
          on_attach = function(bufnr)
            local bm = require("bookmarks")
            local map = vim.keymap.set
            local toggle = function()
              if vim.bo.filetype == "nerdtree" then
                return
              end
              bm.bookmark_toggle()
            end
            map("n", "mt", toggle) -- add or remove bookmark at current line
            map("n", "mi", bm.bookmark_ann) -- add or edit mark annotation at current line
            map("n", "mc", bm.bookmark_clean) -- clean all marks in local buffer
            map("n", "mn", bm.bookmark_next) -- jump to next mark in local buffer
            map("n", "mp", bm.bookmark_prev) -- jump to previous mark in local buffer
            map("n", "ml", bm.bookmark_list) -- show marked file list in quickfix window
          end,
        })
      end,
    },
    -- }}}
    -- Status line {{{2
    {
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      dependencies = {
        -- The icon font for Visual Studio Code
        { "ChristianChiarulli/neovim-codicons", lazy = true },
      },
      config = function()
        require("myrc.config.lualine")
      end,
    },
    { "arkav/lualine-lsp-progress" },
    -- 2}}}
  },
  -- Lazy configurations {{{2
  {
    root = g.VIMFILES .. "/lazy",
    performance = {
      rtp = {
        reset = false, -- no reset the runtime path to $VIMRUNTIME and your config directory
      },
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
  }
  -- }}}
)

-- Initialize enabled_plugins{{{2
local plugins = g.enabled_plugins
local lazyPlugins = require("lazy").plugins()
for _, plugin in pairs(lazyPlugins) do
  if type(plugin) == "table" then
    plugins[plugin.name:lower()] = 1
  end
end
g.enabled_plugins = plugins
-- }}}

-- vim: set fdm=marker fdl=1: }}}
