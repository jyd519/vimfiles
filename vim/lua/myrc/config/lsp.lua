-- Setup lspconfig.
-- >> Reference: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- Globals {{{2
local api = vim.api
local fn = vim.fn

local lspconfig = require('lspconfig')

require("mason").setup()
require("mason-lspconfig").setup()

vim.lsp.set_log_level("warn")

local bufmap = function(mode, lhs, rhs, opts)
  local options = { buffer = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

local has_file = function(root, ...)
  local patterns = vim.tbl_flatten({ ... })
  local join = lspconfig.util.path.join
  for _, name in ipairs(patterns) do
    if vim.loop.fs_stat(join(root, name)) ~= nil then
      return true
    end
  end
  return false
end

-- }}}

-- set keymap on on_attach {{{2
---@diagnostic disable-next-line: unused-local
local function setup_client(client, bufnr)
  -- Jump to the definition
  bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

  -- Jump to declaration
  bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

  -- Lists all the implementations for the symbol under the cursor
  bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

  -- Jumps to the definition of the type symbol
  bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

  -- Lists all the references
  bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')

  -- Displays a function's signature information
  bufmap('n', '<leader>gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

  -- Renames all references to the symbol under the cursor
  bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
  bufmap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>')

  -- formatting code
  bufmap('n', '<leader>cf', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')

  -- Selects a code action available at the current cursor position
  bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
  bufmap('n', 'gx', '<cmd>lua vim.lsp.buf.code_action()<cr>')

  -- Show diagnostics in a floating window
  bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

  -- Move to the previous diagnostic
  bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

  -- Move to the next diagnostic
  bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
end
-- }}}

-- default lspconfig {{{2
local lsp_defaults = {
  flags = { debounce_text_changes = 150, },
  capabilities = require('cmp_nvim_lsp').default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  ),
  on_attach = function(client, bufnr)
    -- nvim 0.7 nvim_exec_autocmds's functionality's is limited
    -- api.nvim_exec_autocmds('User', {pattern = 'LspAttached', data=client.id})
    setup_client(client, bufnr)
  end
}

lspconfig.util.default_config = vim.tbl_deep_extend(
  'force',
  lspconfig.util.default_config,
  lsp_defaults
)
_G.lspconfig = lspconfig
-- }}}

-- null-ls{{{2
-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
local null_ls = require("null-ls")
local augroup = api.nvim_create_augroup("LspFormatting", {})
-- local gotest = require("go.null_ls").gotest()
local gotest_codeaction = require("go.null_ls").gotest_action()
local golangci_lint = require("go.null_ls").golangci_lint()

local lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      -- apply whatever logic you want (in this example, we'll only use null-ls)
      return client.name == "null-ls"
    end,
    bufnr = bufnr,
  })
end

local eslinrc_patterns = { ".eslintrc", ".eslintrc.json", ".eslintrc.yml", ".eslintrc.yaml" }
local prettierrc_patterns = { ".prettierrc", ".prettierrc.json", ".prettierrc.yml", ".prettierrc.yaml" }

local find_in_virtualenv = function(name)
    local utils = require("null-ls.utils")
    local venv_path = os.getenv("VIRTUAL_ENV")
    if venv_path then
      local fullpath = utils.path.join(venv_path, "bin",  name)
      if utils.path.exists(fullpath) then
        return fullpath
      end
    end
    return name
end

null_ls.setup({
  log_level = "warn",
  debounce = 500,
  default_timeout = 10000,
  diagnostics_format = "[#{c}] #{m} (#{s})",
  should_attach = function(bufnr)
    return not api.nvim_buf_get_name(bufnr):match("node_modules")
  end,
  sources = {
    -- golang
    -- gotest,
    gotest_codeaction,
    golangci_lint,
    null_ls.builtins.formatting.golines.with({
      extra_args = {
        "--max-len=180",
        "--base-formatter=gofumpt",
      },
    }),
    -- python
    null_ls.builtins.diagnostics.pylint.with({
      command = find_in_virtualenv("pylint"),
    }),
    -- null_ls.builtins.formatting.pyflyby,
    null_ls.builtins.formatting.black,
    null_ls.builtins.diagnostics.mypy.with{
      command = find_in_virtualenv("mypy"),
      runtime_condition = function(params)
        local utils = require("null-ls.utils")
        return utils.path.exists(params.bufname)
      end,
      extra_args = {
        "--ignore-missing-imports",
      },
    },
    -- typescript
    require("typescript.extensions.null-ls.code-actions"),
    null_ls.builtins.code_actions.eslint.with({
      runtime_condition = function(params)
        return string.match(params.bufname, "node_modules") == nil
      end
    }),
    -- null_ls.builtins.code_actions.gitsigns,  -- blame current line
    null_ls.builtins.code_actions.refactoring,
    null_ls.builtins.diagnostics.eslint.with({
      runtime_condition = function(params)
        if vim.b.large_buf then
          return false
        end
        local root = vim.fn.getcwd()
        if not has_file(root, eslinrc_patterns) then
          return false
        end
        return string.match(params.bufname, "node_modules") == nil
      end,
      -- condition = function(utils)
      --   return utils.root_has_file(eslinrc_patterns) and not vim.b.large_buf
      -- end
    }),
    null_ls.builtins.formatting.prettier.with({
      runtime_condition = function(params)
        local root = vim.fn.getcwd()
        if not has_file(root, prettierrc_patterns) then
          return false
        end
        return string.match(params.bufname, "node_modules") == nil
      end,
      -- condition = function(utils)
      --   return utils.root_has_file(prettierrc_patterns) and not vim.b.large_buf
      -- end
    }),
  },
  on_attach = function(client, bufnr)
    lspconfig.util.default_config.on_attach(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- lsp_formatting(bufnr)
        end,
      })
    end
  end
})

vim.api.nvim_create_user_command("NullLsEnable", function(args)
  require("null-ls.sources").enable(args.fargs[1])
end, {
    nargs = 1,
    complete = function(ArgLead, CmdLine, CursorPos)
      return require("null-ls.sources").get_supported(vim.bo.filetype).diagnostics
    end,
    desc = "Null-ls: Enable Sources",
})

vim.api.nvim_create_user_command("NullLsDisable", function(args)
  require("null-ls.sources").disable(args.fargs[1])
end, {
    nargs = 1,
    complete = function(ArgLead, CmdLine, CursorPos)
      return require("null-ls.sources").get_supported(vim.bo.filetype).diagnostics
    end,
    desc = "Null-ls: Disable Sources",
})
-- }}}

-- tsserver {{{2
require("typescript").setup({
  disable_commands = false, -- prevent the plugin from creating Vim commands
  debug = false,            -- enable debug logging for commands
  go_to_source_definition = {
    fallback = true,        -- fall back to standard LSP definition on failure
  },
  server = {
    autostart = false,      -- use volar first
    on_new_config = function(new_config, new_root_dir)
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

-- jsonls{{{2
lspconfig.jsonls.setup {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
}
-- }}}

-- GoLang  {{{2
require('go').setup {
  lsp_cfg = false,
  lsp_codelens = false,
  luasnip = true,
  lsp_inlay_hints = {
    -- parameter_hints_prefix = " ",
    parameter_hints_prefix = "f ",
  },
}
local golspcfg = require 'go.lsp'.config() -- config() return the go.nvim gopls setup
golspcfg.on_attach = function(client, bufnr)
  lspconfig.util.default_config.on_attach(client, bufnr)
end
lspconfig.gopls.setup(golspcfg)
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
      p = vim.loop.fs_realpath(p)
      if p then
        library[p] = true
      end
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
  add("$VIMFILES/lazy/null-ls.nvim/lua")
  return library
end

lspconfig['lua_ls'].setup {
  single_file_support = true,
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false -- we use null-ls to format code
    client.server_capabilities.documentRangeFormattingProvider = false
    lspconfig.util.default_config.on_attach(client, bufnr)
  end,
  root_dir = function(fname)
    return lspconfig.util.root_pattern('.git', '.project', 'package.json', 'pyproject.toml')(fname) or fn.getcwd()
  end,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim', 'hs' },
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
}
-- }}}

-- rust {{{2
require('rust-tools').setup {
  server = {
    on_attach = function(client, bufnr)
      local set_option = api.nvim_buf_set_option
      set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
      set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
      set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
      lspconfig.util.default_config.on_attach(client, bufnr)
    end,
    dap = {
      adapter = require('dap').adapters.codelldb
    }
  }
}
-- }}}

-- pyright {{{2
-- https://github.com/microsoft/pyright/blob/main/docs/configuration.md
lspconfig.pyright.setup {
  on_attach = function(client, bufnr)
    lspconfig.util.default_config.on_attach(client, bufnr)
  end,
  before_init = function(_, config)
      local join = lspconfig.util.path.join
      local p
      if vim.env.VIRTUAL_ENV then
          p = join(vim.env.VIRTUAL_ENV, "bin", "python3")
      else
          p = "python3"
      end
      print("Python (pyright): ", p)
      config.settings.python.pythonPath = p
      config.setttings.diagnostics.pylint.enabled = false
  end,
}
-- }}}

-- vue/volar {{{2
local function get_typescript_server_path(root_dir)
  local global_ts = '~/.npm/lib/node_modules/typescript/lib'
  local found_ts = ''
  local function check_dir(path)
    found_ts = lspconfig.util.path.join(path, 'node_modules', 'typescript', 'lib')
    if lspconfig.util.path.exists(found_ts) then
      return path
    end
  end
  if lspconfig.util.search_ancestors(root_dir, check_dir) then
    return found_ts
  else
    return global_ts
  end
end

lspconfig.volar.setup {
  filetypes = { 'vue', "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact",
    "typescript.tsx" },

  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false -- we use null-ls to format code
    client.server_capabilities.documentRangeFormattingProvider = false
    lspconfig.util.default_config.on_attach(client, bufnr)
  end,

  on_new_config = function(new_config, new_root_dir)
    if new_root_dir:match("node_modules") or vim.b.large_buf then
      print("Volar disabled")
      new_config.enabled = false
      return new_config
    end
    new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
    return new_config
  end,
}
-- }}}

-- other languages {{{2
local servers = { 'cmake', 'bashls', 'angularls', 'cssls', 'ansiblels' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = function(client, bufnr)
      lspconfig.util.default_config.on_attach(client, bufnr)
    end,
  }
end
-- }}}

-- supper K mapping {{{2
local function show_documentation()
  if dap.session() then
    require("dapui").eval()
  else
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ 'markdown' }, filetype) then
      local clients = { "Vim", "Man" }
      vim.ui.select(clients, {
        prompt = 'Select a action:',
        format_item = function(client)
          return string.lower(client)
        end,
      }, function(item)
        if item == "Vim" then
          vim.cmd('h ' .. fn.expand('<cword>'))
        elseif item == "Man" then
          vim.cmd('Man ' .. fn.expand('<cword>'))
        end
      end)
      return
    end

    if vim.tbl_contains({ 'vim', 'help' }, filetype) then
      ---@diagnostic disable-next-line: missing-parameter
      vim.cmd('h ' .. fn.expand('<cword>'))
    elseif vim.tbl_contains({ 'man' }, filetype) then
      ---@diagnostic disable-next-line: missing-parameter
      vim.cmd('Man ' .. fn.expand('<cword>'))
      ---@diagnostic disable-next-line: missing-parameter
    elseif fn.expand('%:t') == 'Cargo.toml' then
      require('crates').show_popup()
    elseif filetype == 'rust' then
      vim.cmd("RustHoverActions")
    else
      vim.lsp.buf.hover()
    end
  end
end

vim.keymap.set('n', 'K', show_documentation, { noremap = true, silent = true, desc = "show document for underline word" })
-- }}}
--
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    signs = {
      severity= vim.diagnostic.severity.HINT,
      -- severity_limit = "Hint",
    },
    virtual_text = {
      severity = vim.diagnostic.severity.WARN
      -- severity_limit = "Warning",
    },
  }
)
-- vim: set fdm=marker fen fdl=1:
