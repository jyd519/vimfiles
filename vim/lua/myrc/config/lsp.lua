-- Setup lspconfig.lsp
-- >> Reference: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- Globals {{{2
local api = vim.api
local lsp = vim.lsp

-- $MASON -> ~/.local/share/nvim/mason
--  vim.fn.exepath("clangd")
--  vim.fn.expand("$MASON/packages/vue-language-server/")
require("mason").setup()
require("mason-lspconfig").setup({
  automatic_enable = false,
})

vim.lsp.set_log_level("warn")
-- }}}

-- key mappings {{{2
local bufmap = function(mode, lhs, rhs, opts)
  local options = { buffer = true }
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
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
  bufmap("n", "gx", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code action" })
  bufmap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code action" })

  -- codelens
  bufmap("n", "<leader>cc", "<cmd>lua vim.lsp.codelens.run()<cr>", { desc = "Run Codelens" })
  bufmap("n", "<leader>cC", "<cmd>lua vim.lsp.codelens.refresh()<cr>", { desc = "Refresh & Display Codelens" })
end

local format_is_enabled = false
vim.api.nvim_create_user_command("FormatToggle", function()
  format_is_enabled = not format_is_enabled
  vim.notify("Autoformatting " .. (format_is_enabled and "enabled" or "disabled"))
end, {})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local bufnr = event.buf
    local autocmd = api.nvim_create_autocmd
    if client == nil then return end

    setup_keymapping(client, bufnr)

    if client.name == "ruff" then client.server_capabilities.hoverProvider = false end

    local lsp_group = api.nvim_create_augroup("my_lsp_autocmd", { clear = true })

    -- The blow command will highlight the current variable and its usages in the buffer.
    if client.server_capabilities.documentHighlightProvider then
      vim.cmd([[
        hi! link LspReferenceRead Visual
        hi! link LspReferenceText Visual
        hi! link LspReferenceWrite Visual
      ]])

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

    -- Enable inlay hints
    -- if client:supports_method("textDocument/inlayHint") then lsp.inlay_hint.enable(true, { bufnr = event.buf }) end

    if client:supports_method("textDocument/codeLens", bufnr) then
      vim.lsp.codelens.refresh({ bufnr = bufnr })
      vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
        buffer = bufnr,
        callback = function() vim.lsp.codelens.refresh({ bufnr = bufnr }) end,
      })
    end

    if client.name == "clangd" then
      -- require("clangd_extensions.inlay_hints").setup_autocmd()
      -- require("clangd_extensions.inlay_hints").set_inlay_hints()
    end

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

-- Languages {{{2
vim.lsp.enable({
  "cmake",
  "bashls",
  "yamlls",
  "clangd",
  "ts_ls",
  "angularls",
  "cssls",
  "ansiblels",
  "jsonls",
  "gopls",
  "emmet_language_server",
  "basedpyright",
  "ruff",
  "lua_ls",
})
-- }}}

-- Rounded border floating windows {{{2
-- local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
-- vim.lsp.buf.hover = function(opts)
--   return hover({
--     border = "single",
--     -- max_width = 100,
--     max_width = math.floor(vim.o.columns * 0.7),
--     max_height = math.floor(vim.o.lines * 0.7),
--   })
-- end
-- }}}

-- Diagnostics Settings {{{2
if vim.fn.has("nvim-0.10") == 1 then
  vim.diagnostic.config({
    float = {
      source = "if_many",
      border = "rounded",
    },
    virtual_text = {
      severity = vim.diagnostic.severity.WARN,
    },
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
else
  local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
end
-- }}}

-- vim: set fdm=marker fdl=1:
