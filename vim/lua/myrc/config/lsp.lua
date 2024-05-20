-- Setup lspconfig.
-- >> Reference: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- Globals {{{2
local api = vim.api
local fn = vim.fn
local lsp = vim.lsp

local lspconfig = require("lspconfig")

require("mason").setup()
require("mason-lspconfig").setup()

vim.lsp.set_log_level("warn")

local bufmap = function(mode, lhs, rhs, opts)
  local options = { buffer = true }
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
end

local has_file = function(root, ...)
  local patterns = vim.tbl_flatten({ ... })
  local join = lspconfig.util.path.join
  for _, name in ipairs(patterns) do
    if vim.loop.fs_stat(join(root, name)) ~= nil then return true end
  end
  return false
end

local function get_typescript_server_path(root_dir)
  local found_ts = ""
  local function check_dir(path)
    found_ts = lspconfig.util.path.join(path, "node_modules", "typescript", "lib")
    if lspconfig.util.path.exists(found_ts) then return path end
  end
  if lspconfig.util.search_ancestors(root_dir, check_dir) then
    return found_ts
  else
    put(">> typescript/lib not found")
    return found_ts
  end
end

--- Make an on_new_config function that sets the settings
---@param on_new_config function
---@return function
local make_on_new_config = function(on_new_config)
  return lspconfig.util.add_hook_before(on_new_config, function(new_config, root_dir)
    local server_name = new_config.name
    if vim.b.large_buf then
      print(server_name .. " disabled for the file is too large")
      new_config.enabled = false
      return new_config
    end

    local nlspsettings = require("nlspsettings")
    local config = nlspsettings.get_settings(root_dir, server_name)

    local settings = vim.empty_dict()
    settings = vim.tbl_deep_extend("keep", settings, new_config.settings)
    settings = vim.tbl_deep_extend("force", settings, config)
    if server_name == "jsonls" then vim.list_extend(settings.json.schemas, new_config.settings.json.schemas) end
    new_config.settings = settings
    return new_config
  end)
end

-- }}}

-- set lsp keymap {{{2
---@diagnostic disable-next-line: unused-local
local function setup_client(client, bufnr)
  -- Jump to the definition
  bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to definition" })

  -- Jump to declaration
  bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { desc = "Go to declaration" })

  -- Lists all the implementations for the symbol under the cursor
  bufmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", { desc = "Go to implementation" })

  -- Jumps to the definition of the type symbol
  bufmap("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { desc = "Go to type definition" })

  -- Lists all the references
  bufmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "List references" })

  -- Displays a function's signature information
  bufmap("n", "<leader>gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "Show signature" })

  -- Renames all references to the symbol under the cursor
  bufmap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename symbol" })

  -- formatting code
  bufmap("n", "<leader>cf", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", { desc = "Format code" })

  -- Selects a code action available at the current cursor position
  bufmap("n", "gx", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code action" })

  -- -- Show diagnostics in a floating window
  bufmap("n", "<leader>xd", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Show diagnostics" })
  --
  -- The blow command will highlight the current variable and its usages in the buffer.
  if client.server_capabilities.documentHighlightProvider then
    vim.cmd([[
      hi! link LspReferenceRead Visual
      hi! link LspReferenceText Visual
      hi! link LspReferenceWrite Visual
    ]])

    local gid = api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    api.nvim_create_autocmd("CursorHold", {
      group = gid,
      buffer = bufnr,
      callback = function() lsp.buf.document_highlight() end,
    })

    api.nvim_create_autocmd("CursorMoved", {
      group = gid,
      buffer = bufnr,
      callback = function() lsp.buf.clear_references() end,
    })
  end
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
  callback = function(args)
    local client_id = args.data.client_id
    local client = vim.lsp.get_client_by_id(client_id)
    local bufnr = args.buf

    setup_client(client, bufnr)

    --
    -- format on save
    --
    if not client.server_capabilities.documentFormattingProvider then return end

    -- Tsserver usually works poorly. Sorry you work with bad languages
    -- You can remove this line if you know what you're doing :)
    if client.name == "tsserver" then return end

    -- Enable inlay hints
    if client.name == "clangd" then
      -- require("clangd_extensions.inlay_hints").setup_autocmd()
      -- require("clangd_extensions.inlay_hints").set_inlay_hints()
    end

    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, { clear = true }),
      buffer = bufnr,
      callback = function()
        if not format_is_enabled then return end
        vim.lsp.buf.format({
          async = false,
          filter = function(c) return c.id == client.id end,
        })
      end,
    })
  end,
})
-- }}}

-- default lspconfig {{{2
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
local lsp_defaults = {
  capabilities = capabilities,
  on_new_config = make_on_new_config(lspconfig.util.default_config.on_new_config),
}
lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, lsp_defaults)
-- }}}

-- tsserver {{{2
local mason_registry = require("mason-registry")
local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path() .. "/node_modules/@vue/language-server"
require("typescript").setup({
  disable_commands = false, -- prevent the plugin from creating Vim commands
  go_to_source_definition = {
    fallback = true, -- fall back to standard LSP definition on failure
  },
  -- root_dir = lspconfig.util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git"),
  server = {
    init_options = {
      plugins = {
        {
          name = "@vue/typescript-plugin",
          location = vue_language_server_path,
          languages = { "vue" },
        },
      },
    },
    on_new_config = function(new_config, new_root_dir)
      ---@diagnostic disable-next-line: undefined-field
      -- if new_root_dir:match("node_modules") or vim.b.large_buf then
      --   print("tsserver disabled for this buffer")
      --   new_config.enabled = false
      -- end
      return new_config
    end,
    on_attach = function(client, bufnr)
      client.server_capabilities.document_formatting = false
      client.server_capabilities.document_range_formatting = false
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  },
})
-- }}}

-- GoLang  {{{2
-- require("go").setup({
--   lsp_cfg = false,
--   verbose = false,
--   luasnip = true,
-- })
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
      if rp then library[rp] = true end
    end
  end

  -- add runtime
  add("$VIMRUNTIME/lua")

  -- add your config
  add("$VIMFILES/lua")

  -- add plugins
  add("$VIMFILES/lazy/plenary.nvim/lua")
  add("$VIMFILES/lazy/nvim-cmp/lua")
  add("$VIMFILES/lazy/nvim-lspconfig/lua")
  -- TOO SLOW
  -- local paths = vim.api.nvim_get_runtime_file("", true)
  -- for _, p in pairs(paths) do
  --   library[p] = true
  -- end
  return library
end

lspconfig["lua_ls"].setup({
  autostart = false,
  single_file_support = true,
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  root_dir = function(fname)
    return lspconfig.util.root_pattern(".git", ".project", "package.json", "pyproject.toml")(fname) or fn.getcwd()
  end,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim", "hs" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = get_lua_library(),
        maxPreload = 1000,
        preloadFileSize = 500,
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})
-- }}}

-- rust {{{2
require("rust-tools").setup({
  server = {
    on_attach = function(client, bufnr)
      local set_option = api.nvim_buf_set_option
      set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
      set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
      set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
    end,
    dap = {
      adapter = require("dap").adapters.codelldb,
    },
  },
})
-- }}}

-- pyright {{{2
-- https://github.com/microsoft/pyright/blob/main/docs/configuration.md
lspconfig.pyright.setup({
  before_init = function(_, config)
    local join = lspconfig.util.path.join
    local p = "python3"
    if vim.env.VIRTUAL_ENV then p = join(vim.env.VIRTUAL_ENV, "bin", "python3") end
    print("Python (pyright): ", p)
    config.settings.python.pythonPath = p
  end,
})
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
  { "cmake", "bashls", "clangd", "angularls", "cssls", "ansiblels", "jsonls", "gopls", "emmet_language_server" }
for _, name in ipairs(servers) do
  local opts = {
    capabilities = capabilities,
  }
  if lsp_settings[name] then opts = vim.tbl_deep_extend("force", opts, lsp_settings[name]) end
  lspconfig[name].setup(opts)
end
-- }}}

-- diagnostic signs {{{2
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  signs = {
    severity = vim.diagnostic.severity.HINT,
  },
  virtual_text = {
    severity = vim.diagnostic.severity.WARN,
  },
})
-- }}}

-- vim: set fdm=marker fen fdl=1:
