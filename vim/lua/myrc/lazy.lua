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
    -- Utils {{{2
    { "nvim-lua/plenary.nvim", lazy = true }, -- some useful lua functions
    {
      "nvim-treesitter/nvim-treesitter",
      version = false, -- last release is way too old and doesn't work on Windows
      event = { "VeryLazy" },
      cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
      lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
      config = function() require("myrc.config.treesitter") end,
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects"
    },
    {
      "dstein64/vim-startuptime",
      cmd = "StartupTime",
      init = function() vim.g.startuptime_tries = 10 end,
    },
    { "christoomey/vim-tmux-navigator", enabled = fn.has("win32") == 0 and fn.executable("tmux") == 1 },
    {
      "ojroques/nvim-osc52",
      event = "VimEnter",
      enabled = vim.env.SSH_CLIENT ~= nil or vim.env.WSL_DISTRO_NAME ~= nil,
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
    -- Colorschemes {{{2
    { "Mofiqul/vscode.nvim", lazy = true },
    { "NLKNguyen/papercolor-theme", lazy = true },
    { "rakr/vim-one", lazy = true },
    { "navarasu/onedark.nvim", lazy = true },
    {
      "catppuccin/nvim",
      lazy = true,
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
      lazy = true,
      config = function() vim.g.material_style = "lighter" end,
    },
    -- }}}
    -- Basic plugins {{{2
    {
      "mhinz/vim-startify",
      enabled = true,
      config = function() g.startify_files_number = 5 end,
    },
    "anuvyklack/keymap-amend.nvim",
    {
      "smoka7/hop.nvim",
      version = "*",
      event = "VeryLazy",
      config = function() require("myrc.config.hop") end,
    },
    {
      "nvimtools/hydra.nvim",
      event = "VeryLazy",
      dependencies = {
        { "jbyuki/venn.nvim" },
      },
      config = function() require("myrc.config.hydra") end,
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
    {
      "chentoast/marks.nvim",
      event = { "BufReadPost", "BufNewFile" },
      cmd = { "MarksListBuf" },
      config = function() require("myrc.config.marks") end,
    },
    { "numToStr/Comment.nvim", event = "VeryLazy", config = true },
    { "gpanders/editorconfig.nvim", enabled = vim.fn.has("nvim-0.9") == 0 },
    {
      "kylechui/nvim-surround",
      event = { "BufReadPost", "BufNewFile" },
      config = function() require("myrc.config.surround") end,
    },
    {
      "nvim-tree/nvim-web-devicons",
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
      event = "VeryLazy",
      config = function() require("myrc.config.notify") end,
    },
    { dir = g.VIMFILES .. "/locals/t.nvim", cmd = { "T", "TS" } },
    { dir = g.VIMFILES .. "/locals/vim-a", cmd = { "A", "AH" } },
    {
      dir = g.VIMFILES .. "/locals/nvim-projectconfig",
      opts = { silent = false },
    },
    -- }}}
    -- Coding {{{2
    { "thinca/vim-quickrun", cmd = { "QuickRun" } },
    { "jyd519/vim-test", event = { "BufReadPost", "BufNewFile" } }, -- Unit-Testing
    -- https://github.com/ThePrimeagen/refactoring.nvim#installation
    {
      "ThePrimeagen/refactoring.nvim",
      config = true,
      ft = { "typescript", "javascript", "go", "rust", "python", "lua", "c", "cpp" },
    },
    { "jyd519/neoformat", cmd = { "Neoformat" } },
    {
      "lukas-reineke/indent-blankline.nvim",
      enabled = true,
      event = { "BufReadPost", "BufNewFile" },
      config = function() require("myrc.config.indent-blankline") end,
    },
    {
      "lewis6991/gitsigns.nvim",
      event = { "BufReadPost", "BufNewFile" },
      config = function() require("myrc.config.gitsigns") end,
    },
    { "tpope/vim-fugitive", event = "VeryLazy" },
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      event = "VeryLazy",
      config = function() require("myrc.config.toggleterm") end,
    },
    {
      "TimUntersberger/neogit",
      cmd = "Neogit",
      config = function()
        require("neogit").setup({
          kind = "vsplit", -- opens neogit in a split
          signs = {
            section = { "", "" },
            item = { "", "" },
            hunk = { "", "" },
          },
          integrations = { diffview = true }, -- adds integration with diffview.nvim
        })
      end,
    },
    {
      "sindrets/diffview.nvim",
      cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    },
    {
      "Exafunction/codeium.vim",
      event = { "BufEnter" },
      config = function() require("myrc.config.codeium") end,
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
      "olimorris/codecompanion.nvim",
      event = { "VeryLazy" },
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        { "MeanderingProgrammer/render-markdown.nvim", lazy = true, ft = { "codecompanion" } },
      },
      config = function() require("myrc.config.codecompanion") end,
    },
    {
      "norcalli/nvim-colorizer.lua",
      ft = { "css", "sass", "scss", "vue", "html", "javascript", "typescript" },
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
      -- event = { "BufReadPost", "BufNewFile" },
      keys = { "<leader>D" },
      ft = { "go", "python", "lua", "rust", "typescript", "javascript" },
      config = function() require("myrc.config.dap") end,
      dependencies = {
        { "theHamsta/nvim-dap-virtual-text" },
        { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
        { "mfussenegger/nvim-dap-python" },
        { "nvim-telescope/telescope-dap.nvim" },
        { "leoluz/nvim-dap-go" },
        { "jbyuki/one-small-step-for-vimkind", module = "osv" },
        { "mxsdev/nvim-dap-vscode-js" },
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
          localSettings = {
            [".*"] = { takeover = "never" },
          },
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
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
      ft = { "javascript", "typescript" },
      opts = {},
    },
    { "ray-x/guihua.lua", ft = "go" }, -- float term, codeaction and codelens gui support
    {
      "ray-x/go.nvim",
      ft = { "go", "gomod" },
      config = function() require("go").setup() end,
    },
    { "fatih/vim-go", enabled = false, ft = "go" }, -- run = ":GoUpdateBinaries"
    {
      "rust-lang/rust.vim",
      ft = { "rust", "rs" },
      init = function() vim.g.rustfmt_autosave = 1 end,
    },
    { "simrat39/rust-tools.nvim", ft = { "rust" } },
    { "saecki/crates.nvim", config = true, ft = { "toml" } },
    {
      "p00f/clangd_extensions.nvim",
      ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
      config = function() require("myrc.config.clangd") end,
    },
    { "pearofducks/ansible-vim", ft = { "yaml", "ansible", "ansible_hosts" } },
    {
      "someone-stole-my-name/yaml-companion.nvim",
      ft = { "yaml" },
      config = function() require("telescope").load_extension("yaml_schema") end,
    },
    {
      "dense-analysis/ale",
      lazy = true,
      cmd = {
        "ALEToggle",
        "ALEInfo",
        "ALEDetail",
        "ALELint",
        "ALEFix",
      },
      keys = { "<Plug>(ale_lint)", "<Plug>(ale_fix)" },
    }, -- linter
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
      event = { "InsertEnter" },
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
      -- event = { "InsertEnter", "CmdLineEnter" },
      dependencies = {
        { "hrsh7th/cmp-buffer" },
        { "yehuohan/cmp-path" },
        { "hrsh7th/cmp-cmdline" },
        { "hrsh7th/cmp-nvim-lua" },
        { "Snikimonkd/cmp-go-pkgs" },
        -- { "hrsh7th/cmp-nvim-lsp-document-symbol" },
        -- { "quangnguyen30192/cmp-nvim-tags", ft = { "c", "cpp" } },
        { "saadparwaiz1/cmp_luasnip" },
        { "hrsh7th/cmp-nvim-lsp" },
        {
          "tzachar/cmp-tabnine",
          enabled = false,
          build = "./install.sh",
          config = function() require("myrc.config.tabnine") end,
        },
      },
      config = function() require("myrc.config.cmp") end,
    },
    -- }}}
    -- LSP {{{2
    {
      "neovim/nvim-lspconfig",
      event = { "BufReadPost", "BufNewFile" },
      config = function() require("myrc.config.lsp") end,
      dependencies = {
        { "folke/neodev.nvim", lazy = true },
        { "williamboman/mason.nvim", cmd = "Mason", config = true },
        { "williamboman/mason-lspconfig.nvim" },
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
    -- }}}
    -- File explorer/Fuzzy Finder {{{2
    {
      "preservim/nerdtree",
      enabled = false,
      cmd = {
        "NERDTree",
        "NERDTreeToggle",
        "NERDTreeFind",
        "NERDTreeFromBookmark",
      },
    },
    {
      "nvim-tree/nvim-tree.lua",
      tag = "v1.7.1",
      config = function() require("myrc.config.nvim-tree") end,
    },
    {
      "ibhagwan/fzf-lua",
      event = { "BufReadPost", "BufNewFile" },
      enabled = fn.get(g.enabled_plugins, "fzf-lua") == 1,
      config = function()
        require("fzf-lua").setup({
          fzf_opts = { ["--layout"] = "reverse-list" },
        })
      end,
    },
    {
      "junegunn/fzf.vim",
      event = { "BufReadPost", "BufNewFile" },
      enabled = fn.get(g.enabled_plugins, "fzf") == 1,
      dependencies = {
        "junegunn/fzf",
      },
    },
    {
      "nvim-telescope/telescope.nvim",
      enabled = fn.get(g.enabled_plugins, "telescope") == 1,
      cmd = { "Telescope" },
      tag = "0.1.8",
      dependencies = {
        {
          "nvim-telescope/telescope-ui-select.nvim",
          "piersolenski/telescope-import.nvim",
          {
            "nvim-telescope/telescope-fzf-native.nvim",
            enabled = vim.fn.executable("cmake") == 1,
            build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
          },
        },
      },
      config = function() require("myrc.config.telescope") end,
    },
    {
      "allaman/emoji.nvim",
      version = "4.0", -- optionally pin to a tag
      ft = { "markdown", "typescript", "text", "lua" }, -- adjust to your needs
      opts = {
        -- default is false
        enable_cmp_integration = true,
        -- optional if your plugin installation directory
        -- is not vim.fn.stdpath("data") .. "/lazy/
        plugin_path = g.VIMFILES .. "/lazy/",
      },
      config = function(_, opts)
        require("emoji").setup(opts)
        local ts = require("telescope").load_extension("emoji")
        vim.keymap.set("n", "<leader>se", ts.emoji, { desc = "[S]earch [E]moji" })
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
    -- Status line {{{2
    {
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      dependencies = {
        -- The icon font for Visual Studio Code
        { "ChristianChiarulli/neovim-codicons", lazy = true },
        { "arkav/lualine-lsp-progress" },
      },
      init = function()
        vim.g.lualine_laststatus = vim.o.laststatus
        if vim.fn.argc(-1) > 0 then
          -- set an empty statusline till lualine loads
          vim.o.statusline = " "
        else
          -- hide the statusline on the starter page
          vim.o.laststatus = 0
        end
      end,
      config = function() require("myrc.config.lualine") end,
    },
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

-- Initialize enabled_plugins{{{2
local plugins = g.enabled_plugins
local lazyPlugins = require("lazy").plugins()
for _, plugin in pairs(lazyPlugins) do
  if type(plugin) == "table" then plugins[plugin.name:lower()] = 1 end
end
g.enabled_plugins = plugins
-- }}}

-- vim: set fdm=marker fdl=1: }}}
