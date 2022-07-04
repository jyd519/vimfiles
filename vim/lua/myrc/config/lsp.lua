-- Setup lspconfig.
--
-- jsonls  cssls
--    install: npm i -g vscode-langservers-extracted
--
-- Reference: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
--
local api = vim.api
local fn = vim.fn

-- Setup $PATH for nvim-lsp-installer managed language servers
require("nvim-lsp-installer").setup {}

vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
vim.lsp.set_log_level("debug")

local lsp_defaults = {
  flags = { debounce_text_changes = 150, },
  capabilities = require('cmp_nvim_lsp').update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  ),
  -- Callback function that will be executed when a language server is attached to a buffer
  ---@diagnostic disable-next-line: unused-local
  on_attach = function(client, bufnr)
    api.nvim_exec_autocmds('User', {pattern = 'LspAttached'})
  end
}

api.nvim_create_autocmd('User', {
  pattern = 'LspAttached',
  desc = 'LSP actions',
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = true}
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Displays hover information about the symbol under the cursor
    bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

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
    bufmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

    -- Renames all references to the symbol under the cursor
    bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')

    -- Selects a code action available at the current cursor position
    bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')

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

local servers = { 'cmake', 'bashls', 'pyright', 'tsserver', 'cssls', 'ansiblels' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = function(client, bufnr)
      lspconfig.util.default_config.on_attach(client, bufnr)
    end,
  }
end

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
  on_new_config = function(new_config, new_root_dir)
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
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
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
      print("rust-tools attached")
      vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
      vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
      lspconfig.util.default_config.on_attach(client, bufnr)
    end,
	}
}
