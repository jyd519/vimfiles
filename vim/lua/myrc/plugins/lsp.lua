return {
-- LSP Core {{{1
  {
    "neovim/nvim-lspconfig",
    -- event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- Setup LSP
      -- >> Reference: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      -- Globals {{{2
      local api = vim.api
      local lsp = vim.lsp
      local map = vim.keymap.set
      local cmd = vim.api.nvim_create_user_command
      local autocmd = api.nvim_create_autocmd

      -- $MASON -> ~/.local/share/nvim/mason
      --  vim.fn.exepath("clangd")
      --  vim.fn.expand("$MASON/packages/vue-language-server/")

      vim.lsp.log.set_level("warn")

      if vim.fn.has("nvim-0.12") == 1 then
        -- Simply enable the built-in automation
        vim.lsp.codelens.enable(true)
      end
      -- }}}

      -- key mappings {{{2
      map(
        "n",
        "<leader>xt",
        function()
          vim.diagnostic.config({
            virtual_lines = not vim.diagnostic.config().virtual_lines,
            virtual_text = not vim.diagnostic.config().virtual_text,
          })
        end,
        { desc = "Toggle diagnostic virtual lines and virtual text" }
      )

      cmd(
        "DiagnosticToggle",
        function()
          vim.diagnostic.config({
            virtual_lines = not vim.diagnostic.config().virtual_lines,
            virtual_text = not vim.diagnostic.config().virtual_text,
          })
        end,
        { desc = "Toggle diagnostic virtual lines and virtual text" }
      )

      local bufmap = function(mode, lhs, rhs, opts)
        local options = { buffer = true }
        if opts then options = vim.tbl_extend("force", options, opts) end
        vim.keymap.set(mode, lhs, rhs, options)
      end

      local show_code_actions = function(client, bufnr)
        local clients = vim.lsp.get_clients({ name = "vtsls", bufnr = bufnr })
        if #clients > 0 then
          require("vtsls").commands.source_actions(bufnr)
          return
        end
        vim.lsp.buf.code_action()
      end

      local function setup_keymapping(client, bufnr)
        bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to definition" })
        bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { desc = "Go to declaration" })
        bufmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", { desc = "Go to implementation" })
        bufmap("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { desc = "Go to type definition" })
        bufmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "List references" })
        bufmap("n", "gK", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "Show signature" })
        bufmap("i", "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "Show signature" })
        bufmap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename symbol" })
        bufmap("n", "<leader>cf", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", { desc = "Format code" })
        bufmap("n", "<space>wa", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
        bufmap("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
        bufmap("n", "<leader>xd", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Show diagnostics" })

        -- Selects a code action available at the current cursor position
        bufmap("n", "ga", show_code_actions, { desc = "Code action" })
        bufmap("n", "<leader>ca", show_code_actions, { desc = "Code action" })

        -- codelens
        bufmap("n", "<leader>cc", "<cmd>lua vim.lsp.codelens.run()<cr>", { desc = "Run Codelens" })
        bufmap(
          "n",
          "<leader>ct",
          "<cmd>lua vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled())<cr>",
          { desc = "Toggle Codelens" }
        )
      end

      local format_is_enabled = false
      cmd("FormatToggle", function()
        format_is_enabled = not format_is_enabled
        vim.notify("Autoformatting " .. (format_is_enabled and "enabled" or "disabled"))
      end, { desc = "Toggle autoformatting" })

      cmd(
        "CodelensToggle",
        function() vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled()) end,
        { desc = "Toggle Codelens" }
      )

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local bufnr = event.buf
          if client == nil then return end

          setup_keymapping(client, bufnr)

          if client.name == "ruff" then client.server_capabilities.hoverProvider = false end

          local lsp_group = api.nvim_create_augroup("my_lsp_autocmd", { clear = true })

          -- The blow command will highlight the current variable and its usages in the buffer.
          if client.server_capabilities.documentHighlightProvider then
            autocmd("CursorHold", {
              group = lsp_group,
              buffer = bufnr,
              callback = function() lsp.buf.document_highlight() end,
            })

            autocmd("CursorMoved", {
              group = lsp_group,
              buffer = bufnr,
              callback = function() lsp.buf.clear_references() end,
            })
          end

          -- codelens
          if client.name == "lua_ls" then
            vim.lsp.codelens.enable(false, { bufnr = bufnr })
          end
          if vim.fn.has("nvim-0.12") == 0 then
            if client:supports_method("textDocument/codeLens", bufnr) then
              vim.lsp.codelens.enable(true, { bufnr = bufnr })
              autocmd({ "BufEnter", "InsertLeave" }, {
                buffer = bufnr,
                callback = function() vim.lsp.codelens.enable(true, { bufnr = bufnr }) end,
              })
            end
          end

          -- Enable inlay hints
          -- if client:supports_method("textDocument/inlayHint") then lsp.inlay_hint.enable(true, { bufnr = event.buf }) end
          -- Tsserver usually works poorly. Sorry you work with bad languages
          -- You can remove this line if you know what you're doing :)
          if client.name == "tsserver" then
            lsp.inlay_hint.enable(false, { bufnr = event.buf })
            return
          end

          -- format on save
          if client.server_capabilities.documentFormattingProvider then
            autocmd("BufWritePre", {
              group = lsp_group,
              buffer = bufnr,
              callback = function()
                if not format_is_enabled then return end
                vim.lsp.buf.format({
                  async = false,
                  filter = function(c) return c.id == client.id end,
                })
              end,
            })
          end
        end,
      })
      -- }}}

      -- Diagnostics Settings {{{2
      vim.diagnostic.config({
        float = {
          source = "if_many",
          border = "rounded",
        },
        virtual_text = { severity = vim.diagnostic.severity.WARN },
        signs = {
          severity = vim.diagnostic.severity.HINT,
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      })
      -- }}}
    end,
    dependencies = {
      -- TODO
      -- { "folke/neodev.nvim", lazy = true },
      { "mason-org/mason.nvim", cmd = "Mason", config = true },
      { "mason-org/mason-lspconfig.nvim", opts = { automatic_enable = true } },
    },
  },
-- }}}

-- Outline {{{1
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { { "<leader>to", "<cmd>Outline<CR>", desc = "Toggle outline" } },
    config = function()
      require("outline").setup({
        symbol_folding = {
          autofold_depth = 1,
          auto_unfold = {
            hovered = true,
          },
        },
        outline_items = {
          show_symbol_lineno = true,
        },
        keymaps = {
          show_help = "?",
          close = { "q" },
          goto_location = "<Cr>",
          peek_location = "o",
          goto_and_close = "<S-Cr>",
          restore_location = "<C-g>",
          toggle_preview = "K",
          rename_symbol = "r",
          code_actions = "a",
          fold = "f",
          unfold = "e",
          fold_toggle = "<Tab>",
          fold_toggle_all = "<S-Tab>",
          fold_all = "F",
          unfold_all = "E",
          fold_reset = "R",
          down_and_jump = "<down>",
          up_and_jump = "<up>",
        },
      })
    end,
  },
-- }}}

-- Clangd {{{1
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    opts = {
      inlay_hints = {
        inline = false, --vim.fn.has("nvim-0.10") == 1,
        only_current_line = true,
        only_current_line_autocmd = { "CursorHold" },
        show_parameter_hints = false,
        parameter_hints_prefix = "<- ",
        other_hints_prefix = "=> ",
        max_len_align = false,
        max_len_align_padding = 1,
        right_align = false,
        right_align_padding = 7,
        highlight = "Comment",
        priority = 100,
      },
    },
  },
-- }}}

-- Other LSP plugins {{{1
  { "b0o/schemastore.nvim", lazy = true },
  { "pearofducks/ansible-vim", ft = { "yaml", "ansible", "ansible_hosts" } },
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
}
-- vim: set fdm=marker fdl=0:
