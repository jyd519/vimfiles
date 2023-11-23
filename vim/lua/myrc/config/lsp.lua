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
    return vim.fn.expand("~/.nvm/versions/node/v16.19.1/lib/node_modules/typescript/lib")
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

    if server_name == "volar" then
      if root_dir:match("node_modules") then
        print("Volar disabled")
        new_config.enabled = false
        return new_config
      end
      new_config.init_options.typescript.tsdk = get_typescript_server_path(root_dir)
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

-- set keymap on on_attach {{{2
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

  -- Show diagnostics in a floating window
  bufmap("n", "<leader>xd", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Show diagnostics" })

  -- Move to the previous diagnostic
  bufmap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "Previous diagnostic" })

  -- Move to the next diagnostic
  bufmap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "Next diagnostic" })

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
-- }}}

-- default lspconfig {{{2
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
local lsp_defaults = {
  -- This is the default in Nvim 0.7+
  -- flags = { debounce_text_changes = 150 },
  capabilities = capabilities,
  on_new_config = make_on_new_config(lspconfig.util.default_config.on_new_config),
  on_attach = function(client, bufnr)
    -- nvim 0.7 nvim_exec_autocmds's functionality's is limited
    -- api.nvim_exec_autocmds('User', {pattern = 'LspAttached', data=client.id})
    setup_client(client, bufnr)
  end,
}

lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, lsp_defaults)
_G.lspconfig = lspconfig
-- }}}

-- tsserver {{{2
require("typescript").setup({
  disable_commands = false, -- prevent the plugin from creating Vim commands
  debug = false, -- enable debug logging for commands
  go_to_source_definition = {
    fallback = true, -- fall back to standard LSP definition on failure
  },
  server = {
    autostart = false, -- use volar first
    on_new_config = function(new_config, new_root_dir)
      ---@diagnostic disable-next-line: undefined-field
      if new_root_dir:match("node_modules") or vim.b.large_buf then
        print("tsserver disabled for this buffer")
        new_config.enabled = false
      end
      return new_config
    end,
    on_attach = function(client, bufnr)
      -- if vim.api.nvim_buf_get_name(bufnr):match("node_modules") then
      -- vim.lsp.stop_client(client.id, false)
      -- end
      client.server_capabilities.document_formatting = false
      client.server_capabilities.document_range_formatting = false
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      lspconfig.util.default_config.on_attach(client, bufnr)
    end,
  },
})
-- }}}

-- GoLang  {{{2
require("go").setup({
  lsp_cfg = true,
  lsp_codelens = true,
  luasnip = true,
  lsp_inlay_hints = {
    parameter_hints_prefix = " ",
    -- parameter_hints_prefix = "f ",
  },
  lsp_on_attach = function(client, bufnr) setup_client(client, bufnr) end,
})
-- local golspcfg = require("go.lsp").config() -- config() return the go.nvim gopls setup
-- lspconfig.gopls.setup(golspcfg)
-- lspconfig.gopls.setup {
--   on_attach = function(client, bufnr)
--     lspconfig.util.default_config.on_attach(client, bufnr)
--   end,
--   settings = {
--     gopls = {
--       experimentalPostfixCompletions = true,
--       analyses = {
--         unusedparams = true,
--         shadow = true,
--       },
--       staticcheck = true,
--     },
--   },
--   init_options = {
--     usePlaceholders = true,
--   }
-- }
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
  -- add("$VIMFILES/lazy/plenary.nvim/lua")
  -- add("$VIMFILES/lazy/nvim-cmp/lua")
  -- add("$VIMFILES/lazy/nvim-lspconfig/lua")
  local paths = vim.api.nvim_get_runtime_file("", true)
  for _, p in pairs(paths) do
    library[p] = true
  end
  return library
end

lspconfig["lua_ls"].setup({
  single_file_support = true,
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    lspconfig.util.default_config.on_attach(client, bufnr)
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
      lspconfig.util.default_config.on_attach(client, bufnr)
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
  on_attach = function(client, bufnr) lspconfig.util.default_config.on_attach(client, bufnr) end,
  before_init = function(_, config)
    local join = lspconfig.util.path.join
    local p = "python3"
    if vim.env.VIRTUAL_ENV then p = join(vim.env.VIRTUAL_ENV, "bin", "python3") end
    print("Python (pyright): ", p)
    config.settings.python.pythonPath = p
    config.setttings.diagnostics.pylint.enabled = false
  end,
})
-- }}}

-- vue/volar {{{2
lspconfig.volar.setup({
  filetypes = {
    "vue",
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  on_new_config = lspconfig.util.default_config.on_new_config,
  on_attach = function(client, bufnr) lspconfig.util.default_config.on_attach(client, bufnr) end,
})
-- }}}

-- other languages {{{2
local lsp_settings = {
  cssls = {
    settings = {
      css = {
        lint = {
          unknownAtRules = "ignore",
        },
      },
    },
  },
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },
}

local servers = { "cmake", "bashls", "angularls", "cssls", "ansiblels", "tailwindcss", "jsonls" }
for _, lsp in ipairs(servers) do
  local opts = {
    on_attach = function(client, bufnr) lspconfig.util.default_config.on_attach(client, bufnr) end,
  }
  if lsp_settings[lsp] ~= nil then opts = vim.tbl_deep_extend("force", lsp_settings[lsp], opts) end
  lspconfig[lsp].setup(opts)
end
-- }}}

-- supper K mapping {{{2
local function show_documentation()
  if dap.session() then
    require("dapui").eval()
  else
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ "markdown" }, filetype) then
      local clients = { "Vim", "Man" }
      vim.ui.select(clients, {
        prompt = "Select a action:",
        format_item = function(client) return string.lower(client) end,
      }, function(item)
        if item == "Vim" then
          vim.cmd("h " .. fn.expand("<cword>"))
        elseif item == "Man" then
          vim.cmd("Man " .. fn.expand("<cword>"))
        end
      end)
      return
    end

    if vim.tbl_contains({ "vim", "help" }, filetype) then
      ---@diagnostic disable-next-line: missing-parameter
      vim.cmd("h " .. fn.expand("<cword>"))
    elseif vim.tbl_contains({ "man" }, filetype) then
      ---@diagnostic disable-next-line: missing-parameter
      vim.cmd("Man " .. fn.expand("<cword>"))
    ---@diagnostic disable-next-line: missing-parameter
    elseif fn.expand("%:t") == "Cargo.toml" then
      require("crates").show_popup()
    elseif filetype == "rust" then
      vim.cmd("RustHoverActions")
    else
      vim.lsp.buf.hover()
    end
  end
end

vim.keymap.set(
  "n",
  "K",
  show_documentation,
  { noremap = true, silent = true, desc = "show document for underline word" }
)
-- }}}

-- diagnostic signs {{{2
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  signs = {
    severity = vim.diagnostic.severity.HINT,
    -- severity_limit = "Hint",
  },
  virtual_text = {
    severity = vim.diagnostic.severity.WARN,
    -- severity_limit = "Warning",
  },
})
-- }}}

-- vim: set fdm=marker fen fdl=1:
