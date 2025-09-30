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

return yamlls_cfg
