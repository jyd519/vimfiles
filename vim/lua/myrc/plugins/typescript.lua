return {
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "javascript", "typescript" },
    opts = {},
    config = function(_, opts)
      -- typescript-tools {{{2
      require("typescript-tools").setup({
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
        },
        disable_commands = false,
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
        settings = {
          single_file_support = false,
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeCompletionsForModuleExports = true,
            -- includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            -- includeInlayFunctionParameterTypeHints = true,
            -- includeInlayVariableTypeHints = true,
            -- includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            -- includeInlayPropertyDeclarationTypeHints = true,
            -- includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
            quotePreference = "auto",
          },

          tsserver_plugins = {
            "@styled/typescript-styled-plugin",
          },
        },
      })
      -- }}}
    end,
  },
}
