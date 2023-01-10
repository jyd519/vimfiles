-- Setup lspconfig.
--
-- Reference: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
--
local api = vim.api
local fn = vim.fn

require("mason").setup()
require("mason-lspconfig").setup()

vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
vim.lsp.set_log_level("warn")

local bufmap = function(mode, lhs, rhs, opts)
  local options = { buffer = true }
  if opts then
      options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

local function show_documentation()
  if dap.session() then
    require"dapui".eval()
  else
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ 'markdown' }, filetype) then
      local clients = {"Vim", "Man"}
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

    if vim.tbl_contains({ 'vim','help' }, filetype) then
---@diagnostic disable-next-line: missing-parameter
      vim.cmd('h '.. fn.expand('<cword>'))
    elseif vim.tbl_contains({ 'man' }, filetype) then
---@diagnostic disable-next-line: missing-parameter
      vim.cmd('Man '..fn.expand('<cword>'))
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
vim.keymap.set('n', 'K', show_documentation, { noremap = true, silent = true, desc="show document for underline word" })

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
      bufmap('n', 'K', show_documentation, {desc = 'dap eval or lsp.buf.hover'})
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

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.code_actions.refactoring,
        null_ls.builtins.code_actions.eslint,
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.formatting.prettier
    },
    on_attach = function (client, bufnr)
      lspconfig.util.default_config.on_attach(client, bufnr)
    end
})

-- tsserver
lspconfig.tsserver.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = false
        client.server_capabilities.document_range_formatting = false
        local ts_utils = require("nvim-lsp-ts-utils")
        ts_utils.setup({})
        ts_utils.setup_client(client)
        -- buf_map(bufnr, "n", "gs", ":TSLspOrganize<CR>")
        -- buf_map(bufnr, "n", "gi", ":TSLspRenameFile<CR>")
        -- buf_map(bufnr, "n", "go", ":TSLspImportAll<CR>")
        --
        --
        vim.api.nvim_buf_create_user_command(bufnr, "Organize", ":TSLspOrganize", {
            nargs = 0,
            desc = "TSLspOrganize",
        })
        vim.api.nvim_buf_create_user_command(bufnr, "RenameFile", ":TSLspRenameFile", {
            nargs = 0,
            desc = "TSLspRenameFile",
        })
        vim.api.nvim_buf_create_user_command(bufnr, "Ips", ":TSLspImportAll", {
            nargs = 0,
            desc = "TSLspImportAll",
        })
        lspconfig.util.default_config.on_attach(client, bufnr)
    end,
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
local nodeRoot="/Users/jiyongdong/.nvm/versions/node/v12.22.12/"
local languageServerPath = nodeRoot .. "lib"
local cmd = {nodeRoot .. "bin/node", languageServerPath.."/node_modules/@angular/language-server/index.js", "--stdio", "--tsProbeLocations", languageServerPath, "--ngProbeLocations", languageServerPath}
require'lspconfig'.angularls.setup{
  cmd = cmd,
  on_new_config = function(new_config--[[ , new_root_dir ]])
    new_config.cmd = cmd
  end,
}

-- GoLang
lspconfig.gopls.setup{
  on_attach = function(client, bufnr)
    lspconfig.util.default_config.on_attach(client, bufnr)
  end,
  settings = {
    gopls = {
      experimentalPostfixCompletions = true,
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
    },
  },
  init_options = {
    usePlaceholders = true,
  }
}

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

lspconfig['sumneko_lua'].setup{
  single_file_support = true,
  on_attach = function(client, bufnr)
    lspconfig.util.default_config.on_attach(client, bufnr)
  end,
  root_dir = function(fname)
    return lspconfig.util.root_pattern('.git')(fname) or fn.getcwd()
  end,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim', 'hs'},
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

require('rust-tools').setup{
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
