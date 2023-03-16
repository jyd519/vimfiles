-- Setup lspconfig.
--
-- Reference: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
--
local api = vim.api
local fn = vim.fn

require("mason").setup()
require("mason-lspconfig").setup()

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.lsp.set_log_level("info")

local bufmap = function(mode, lhs, rhs, opts)
  local options = { buffer = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

local function show_documentation()
  if dap.session() then
    require "dapui".eval()
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
      vim.cmd('RustHoverActions')
    else
      vim.lsp.buf.hover()
    end
  end
end

vim.keymap.set('n', 'K', show_documentation, { noremap = true, silent = true, desc = "show document for underline word" })

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

local lsp_defaults = {
  flags = { debounce_text_changes = 150, },
  capabilities = require('cmp_nvim_lsp').default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  ),
  -- Callback function that will be executed when a language server is attached to a buffer
  ---@diagnostic disable-next-line: unused-local
  on_attach = function(client, bufnr)
    -- nvim 0.7 nvim_exec_autocmds's functionality's is limited
    -- api.nvim_exec_autocmds('User', {pattern = 'LspAttached', data=client.id})
    setup_client(client, bufnr)
  end
}

api.nvim_create_autocmd('User', {
  pattern = 'LspAttached',
  desc = 'LSP actions',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.hoverProvider then
      -- Displays hover information about the symbol under the cursor
      bufmap('n', 'K', show_documentation, { desc = 'dap eval or lsp.buf.hover' })
    end

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

    -- Selects a code action available at the current cursor position
    bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')
    bufmap('n', 'gx', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('x', 'gx', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')

    -- Show diagnostics in a floating window
    bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

    -- Move to the previous diagnostic
    bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

    -- Move to the next diagnostic
    bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  end
})

-- Setup lspconfig.
local lspconfig = require('lspconfig')
lspconfig.util.default_config = vim.tbl_deep_extend(
  'force',
  lspconfig.util.default_config,
  lsp_defaults
)
_G.lspconfig = lspconfig

-- Setup LSP Server
--

local servers = { 'cmake', 'bashls', 'pyright', 'cssls', 'ansiblels' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = function(client, bufnr)
      lspconfig.util.default_config.on_attach(client, bufnr)
    end,
  }
end

-- null-ls
local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local gotest = require("go.null_ls").gotest()
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
null_ls.setup({
  debug = false,
  debounce = 1000, default_timeout = 5000,
  should_attach = function(bufnr)
    return not vim.api.nvim_buf_get_name(bufnr):match("node_modules")
  end,
  sources = {
    require("typescript.extensions.null-ls.code-actions"),
    gotest,
    gotest_codeaction,
    golangci_lint,
    null_ls.builtins.code_actions.eslint.with({
      condition = function(utils)
        return utils.root_has_file(eslinrc_patterns)
      end
    }),
    -- null_ls.builtins.code_actions.gitsigns,  -- blame current line
    -- null_ls.builtins.code_actions.refactoring,
    null_ls.builtins.diagnostics.eslint.with({
      condition = function(utils)
        return utils.root_has_file(eslinrc_patterns) and not vim.b.large_buf
      end
    }),
    null_ls.builtins.formatting.prettier.with({
      condition = function(utils)
        return utils.root_has_file(prettierrc_patterns)
      end
    }),
    null_ls.builtins.formatting.golines.with({
      extra_args = {
        "--max-len=180",
        "--base-formatter=gofumpt",
      },
    })
  },
  on_attach = function(client, bufnr)
    lspconfig.util.default_config.on_attach(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          lsp_formatting(bufnr)
        end,
      })
    end
  end
})

-- tsserver
require("typescript").setup({
  disable_commands = false, -- prevent the plugin from creating Vim commands
  debug = false, -- enable debug logging for commands
  go_to_source_definition = {
    fallback = true, -- fall back to standard LSP definition on failure
  },
  server = { -- pass options to lspconfig's setup method
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

-- jsonls
lspconfig.jsonls.setup {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
}

-- angularls
require 'lspconfig'.angularls.setup{}

-- GoLang
require('go').setup{
  lsp_cfg = false,
  lsp_codelens = false,
  lsp_inlay_hints = {
    -- parameter_hints_prefix = " ",
    parameter_hints_prefix = "f ",
  },
}
local golspcfg = require'go.lsp'.config() -- config() return the go.nvim gopls setup
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

-- lua lsp
local function get_lua_library()
  local library = {}

  local path = vim.split(package.path, ";")

  -- this is the ONLY correct way to setup your path
  table.insert(path, "lua/?.lua")
  table.insert(path, "lua/?/init.lua")

  local function add(lib)
    for _, p in pairs(vim.fn.expand(lib, false, true)) do
      p = vim.loop.fs_realpath(p)
      library[p] = true
    end
  end

  -- add runtime
  add("$VIMRUNTIME/lua")

  -- add your config
  add("$VIMFILES/lua")

  -- add plugins
  add("$VIMFILES/pack/packer/start/plenary.nvim/lua")
  add("$VIMFILES/pack/packer/start/nvim-cmp/lua")
  add("$VIMFILES/pack/packer/start/nvim-lspconfig/lua")
  add("$VIMFILES/pack/packer/opt/neodev.nvim/types")
  return library
end

lspconfig['lua_ls'].setup {
  single_file_support = true,
  on_attach = function(client, bufnr)
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
        preloadFileSize = 150,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

require('rust-tools').setup {
  server = {
    on_attach = function(client, bufnr)
      local set_option = vim.api.nvim_buf_set_option
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

-- vue
local function get_typescript_server_path(root_dir)
  local global_ts = '~/.npm/lib/node_modules/typescript/lib'
  -- Alternative location if installed as root:
  -- local global_ts = '/usr/local/lib/node_modules/typescript/lib'
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
  filetypes = { 'vue' },
  on_attach = function(client, bufnr)
    lspconfig.util.default_config.on_attach(client, bufnr)
  end,
  on_new_config = function(new_config, new_root_dir)
    new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
  end,
}

-- lsp formatting
vim.api.nvim_create_user_command("Format", function()
  vim.lsp.buf.format({ async = true })
end, {
  desc = "Format the current buffer",
})
