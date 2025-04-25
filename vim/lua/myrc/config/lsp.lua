-- Setup lspconfig.lsp
-- >> Reference: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- Globals {{{2
local api = vim.api
local fn = vim.fn
local lsp = vim.lsp
local lspconfig = require("lspconfig")
local util = lspconfig.util
local is_window = vim.fn.has("win32") == 1

require("mason").setup()
require("mason-lspconfig").setup()

vim.lsp.set_log_level("warn")

local bufmap = function(mode, lhs, rhs, opts)
  local options = { buffer = true }
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
end

local has_file = function(root, ...)
  local patterns = vim.iter({ ... }):flatten():totable()
  for _, name in ipairs(patterns) do
    if vim.uv.fs_stat(table.concat({ root, name }, "/")) ~= nil then return true end
  end
  return false
end

local function get_typescript_server_path(root_dir)
  local found_ts = ""
  local function check_dir(path)
    found_ts = table.concat({ path, "node_modules", "typescript", "lib" }, "/")
    if vim.loop.fs_stat(found_ts) then return path end
  end
  if util.search_ancestors(root_dir, check_dir) then
    return found_ts
  else
    put(">> typescript/lib not found")
    return found_ts
  end
end

-- }}}

-- key mappings {{{2
---@diagnostic disable-next-line: unused-local
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
    local client_id = event.data.client_id
    local client = vim.lsp.get_client_by_id(client_id)
    local bufnr = event.buf
    local autocmd = api.nvim_create_autocmd
    setup_keymapping(client, bufnr)
    if client == nil then return end

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
    if client:supports_method("textDocument/inlayHint") then lsp.inlay_hint.enable(true, { bufnr = event.buf }) end

    if client.name == "clangd" then
      -- require("clangd_extensions.inlay_hints").setup_autocmd()
      -- require("clangd_extensions.inlay_hints").set_inlay_hints()
    end

    -- Tsserver usually works poorly. Sorry you work with bad languages
    -- You can remove this line if you know what you're doing :)
    if client.name == "tsserver" then return end

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

-- default lspconfig {{{2
local capabilities = require("cmp_nvim_lsp").default_capabilities()
util.default_config = vim.tbl_deep_extend("force", util.default_config, {
  capabilities = capabilities,
})
-- }}}

-- tsserver {{{2
local mason_registry = require("mason-registry")
local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
  .. "/node_modules/@vue/language-server"
require("typescript-tools").setup({
  disable_commands = false, -- prevent the plugin from creating Vim commands
  go_to_source_definition = {
    fallback = true, -- fall back to standard LSP definition on failure
  },
  server = {
    on_attach = function(client, bufnr)
      client.server_capabilities.document_formatting = false
      client.server_capabilities.document_range_formatting = false
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  },
})
-- }}}

-- lua lsp {{{2
local function get_lua_library()
  local library = {}
  local path = vim.split(package.path, ";")

  -- this is the ONLY correct way to setup your path
  table.insert(path, "lua/?.lua")
  table.insert(path, "lua/?/init.lua")

  local function add(lib)
    for _, p in pairs(vim.fn.expand(lib, false, true)) do
      local rp = vim.loop.fs_realpath(p)
      if rp then table.insert(library, rp) end
    end
  end

  -- add runtime
  add("$VIMRUNTIME")

  -- add your config
  add("$VIMFILES/lua")

  -- add plugins
  add("$VIMFILES/lazy/plenary.nvim/lua")
  add("$VIMFILES/lazy/nvim-cmp/lua")
  add("$VIMFILES/lazy/nvim-lspconfig/lua")
  -- TOO SLOW
  -- local paths = vim.api.nvim_get_runtime_file("", true)
  -- for _, p in pairs(paths) do
  --   table.insert(library, p)
  -- end
  table.insert(library, "${3rd}/luv/library")
  return library
end

lspconfig["lua_ls"].setup({
  root_dir = function(fname)
    local primary =
      util.root_pattern(".luarc.json", ".luarc.jsonc", ".project", "package.json", "pyproject.toml", ".git")(fname)
    local fallback = vim.loop.cwd()
    return primary or fallback
  end,
  on_init = function(client)
    -- local path = client.workspace_folders[1].name
    -- if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
    --   return
    -- end
    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "hs" },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        -- Make the server aware of Neovim runtime files
        library = get_lua_library(),
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
        -- maxPreload = 1000,
        -- preloadFileSize = 500,
        -- checkThirdParty = false,
      },
    })
  end,
  settings = {
    Lua = {},
  },
})
-- }}}

-- rust {{{2
require("rust-tools").setup({
  server = {
    on_attach = function(client, bufnr)
      local set_option = api.nvim_set_option_value
      set_option("formatexpr", "v:lua.vim.lsp.formatexpr()", { buf = bufnr })
      set_option("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
      set_option("tagfunc", "v:lua.vim.lsp.tagfunc", { buf = bufnr })
    end,
    dap = {
      adapter = require("dap").adapters.codelldb,
    },
  },
})
-- }}}

local function getPythonPath()
  local p
  local python = is_window and "python.exe" or "python"
  if vim.env.VIRTUAL_ENV then
    p = vim.fs.joinpath(vim.env.VIRTUAL_ENV, "bin", python)
    if vim.uv.fs_stat(p) then return p end
  end

  p = vim.fs.joinpath(".venv", "Scripts", python)
  if vim.uv.fs_stat(p) then return p end
  p = vim.fs.joinpath(".venv", "bin", python)
  if vim.uv.fs_stat(p) then return p end

  return python
end

-- pyright {{{2
-- https://github.com/microsoft/pyright/blob/main/docs/configuration.md
lspconfig.pyright.setup({
  before_init = function(_, config)
    local p = getPythonPath()
    vim.defer_fn(function() vim.notify("Python (pyright): " .. p) end, 300)
    config.settings.python.pythonPath = p
  end,
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        -- ignore = { '*' },
        -- typeCheckingMode = "basic",
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
      },
    },
  },
})

-- lspconfig.basedpyright.setup({
--   basedpyright  = {
--     analysis = {
--       -- Ignore all files for analysis to exclusively use Ruff for linting
--       -- ignore = { '*' },
--       -- typeCheckingMode = "basic",
--       autoSearchPaths = true,
--       diagnosticMode = "openFilesOnly",
--       useLibraryCodeForTypes = true
--     },
--   },
-- })
-- }}}

-- vue/volar {{{2
-- https://github.com/vuejs/language-tools
lspconfig.volar.setup({
  init_options = {
    vue = {
      hybridMode = false,
    },
  },
})
-- }}}

-- yaml {{{2
--
local yamlls_cfg = require("yaml-companion").setup({
  schemas = {
    {
      name = "openapi-3.0 local",
      uri = vim.fn.expand("$VIMFILES/openapi-schema.json"),
    },
  },
  lspconfig = {
    settings = {
      redhat = { telemetry = { enabled = false } },
      http = { proxy = vim.g.proxy },
      yaml = {
        hover = true,
        schemaStore = {
          enable = true,
          url = "https://www.schemastore.org/api/json/catalog.json",
        },
        schemaDownload = { enable = true },
        -- Use schemastore
        -- schemaStore = {
        --   -- You must disable built-in schemaStore support if you want to use
        --   -- this plugin and its advanced options like `ignore`.
        --   enable = false,
        --   -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        --   url = "",
        -- },
        -- schemas = require("schemastore").yaml.schemas({
        --   extra = {
        --     {
        --       description = "Local openapi schema",
        --       fileMatch = "*openapi.yaml",
        --       name = "openapi.yaml",
        --       url = vim.fn.expand("$VIMFILES/openapi-schema.json"),
        --     },
        --   },
        -- }),
      },
    },
  },
})
lspconfig.yamlls.setup(yamlls_cfg)
-- }}}

-- other languages {{{2
local lsp_settings = {
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },
}

local servers =
  { "cmake", "bashls", "clangd", "angularls", "cssls", "ansiblels", "jsonls", "gopls", "emmet_language_server", "ruff" }
for _, name in ipairs(servers) do
  local opts = {
    capabilities = capabilities,
  }
  if lsp_settings[name] then opts = vim.tbl_deep_extend("force", opts, lsp_settings[name]) end
  lspconfig[name].setup(opts)
end
-- }}}

-- Rounded border floating windows {{{2
local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function()
  return hover({
    border = "single",
    -- max_width = 100,
    max_width = math.floor(vim.o.columns * 0.7),
    max_height = math.floor(vim.o.lines * 0.7),
  })
end

local signature_help = vim.lsp.buf.signature_help
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.signature_help = function()
  return signature_help({
    border = "single",
    max_width = math.floor(vim.o.columns * 0.7),
    max_height = math.floor(vim.o.lines * 0.7),
  })
end
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
