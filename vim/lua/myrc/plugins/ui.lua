return {
-- Notify {{{1
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      vim.notify = require("notify")
      require("notify").setup({
        timeout = 1000,
        background_colour = "#000000",
      })
      vim.lsp.handlers['window/showMessage'] = function(_, result, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        local lvl = ({ 'ERROR', 'WARN', 'INFO', 'DEBUG' })[result.type]
        vim.notify(result.message, lvl, {
          title = 'LSP | ' .. client.name,
          timeout = 10000,
          keep = function()
            return lvl == 'ERROR' or lvl == 'WARN'
          end,
        })
      end
    end,
  },
-- }}}
-- Indent Blankline {{{1
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local api = vim.api
      local filetype_exclude = {
        "lspinfo",
        "checkhealth",
        "help",
        "man",
        "mason",
        "qf",
        "startify",
        "markdown",
        "alpha",
        "dashboard",
        "neo-tree",
        "lazy",
      }
      require("ibl").setup({
        indent = {
          char = "│",
        },
        exclude = {
          filetypes = filetype_exclude,
          buftypes = { "terminal", "nofile" },
        },
        scope = { enabled = false },
      })
      local hooks = require("ibl.hooks")
      hooks.register(
        hooks.type.ACTIVE,
        function(bufnr) return vim.b.large_buf == nil and vim.api.nvim_buf_line_count(bufnr) < 5000 end
      )
    end,
  },
-- }}}
-- NvimTree {{{1
  {
    "nvim-tree/nvim-tree.lua",
    cond = false,
    event = "VeryLazy",
    version = "*",
    config = function()
      local function nvim_tree_on_attach(bufnr)
        local api = require "nvim-tree.api"
        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))
        vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
      end
      require("nvim-tree").setup({
        on_attach = nvim_tree_on_attach,
        view = { width = 40 },
        renderer = {
          root_folder_label = function (path)
            path = path:gsub(vim.loop.os_homedir(), "~", 1)
            return path:gsub("([a-zA-Z])[a-z]+", "%1") .. path:gsub(".*[^a-zA-Z].?", "")
          end
        },
        filters = { dotfiles = true },
      })
      vim.keymap.set("n", "<F3>", ":NvimTreeToggle<cr>", { desc = "Toggle NvimTree" })
      vim.keymap.set("n", "<leader>nf", ":NvimTreeFindFile<cr>", { desc = "Find File in NvimTree" })
      vim.keymap.set("n", "<leader>nF", ":NvimTreeFindFile!<cr>", { desc = "Find File in NvimTree" })
    end,
  },
-- }}}
}
-- vim: set fdm=marker fdl=1:
