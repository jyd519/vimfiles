return {
  {
    "nvim-treesitter/nvim-treesitter",
    main = "nvim-treesitter",
    branch = "main",
    config = function()
      local treesitter = require("nvim-treesitter")

      ---@diagnostic disable-next-line: missing-fields
      treesitter.setup({
        sync_install = false,
        auto_install = false,
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<leader>gnn",
            node_incremental = "<leader>grn",
            scope_incremental = "<leader>grc",
            node_decremental = "<leader>grm",
          },
        },
        refactor = {
          highlight_definitions = { enable = true },
          highlight_current_scope = { enable = true },
          smart_rename = {
            enable = true,
            keymaps = {
              smart_rename = "grr",
            },
          },
        },
        textobjects = {
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]]"] = "@jsx.element",
              ["]f"] = "@function.outer",
              ["]m"] = "@class.outer",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]M"] = "@class.outer",
            },
            goto_previous_start = {
              ["[["] = "@jsx.element",
              ["[f"] = "@function.outer",
              ["[m"] = "@class.outer",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[M"] = "@class.outer",
            },
          },
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
            },
            selection_modes = {
              ["@parameter.outer"] = "v",
              ["@function.outer"] = "V",
              ["@class.outer"] = "<c-v>",
            },
            include_surrounding_whitespace = true,
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>sn"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>sN"] = "@parameter.inner",
            },
          },
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local ft = vim.bo.filetype
          if ft == "" then return end

          -- 检查是否能启动 treesitter
          local ok, parser = pcall(vim.treesitter.language.add, ft)
          if not ok then return end

          -- 分别检查 folds 和 indents 查询是否存在
          local has_folds = pcall(vim.treesitter.query.get, ft, "folds")
          local has_indents = pcall(vim.treesitter.query.get, ft, "indents")

          if has_folds then
            vim.opt_local.foldmethod = "expr"
            vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          else
            vim.opt_local.foldmethod = "indent"
            vim.opt_local.foldexpr = ""
          end

          if has_indents then vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    enabled = false,
  },
  {
    "Wansmer/treesj",
    keys = { "<space>m", "<space>j", "<space>s" },
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
    config = function()
      require("treesj").setup({
        ---@type boolean Use default keymaps (<space>m - toggle, <space>j - join, <space>s - split)
        use_default_keymaps = true,
      })
    end,
  },
}
-- vim: set fdl=2 fdm=expr:
