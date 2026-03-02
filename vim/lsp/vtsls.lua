-- Dynamically point to the path of @vue/language-server
-- which contains @vue/typescript-plugin
local vue_typescript_plugin =
  vim.fn.expand(vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server")

if not vim.loop.fs_stat(vue_typescript_plugin) then
  vim.notify("Unable to find @vue/language-server. Please run :MasonInstall @vue/language-server")
end

local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }

local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = vue_typescript_plugin,
  languages = { "vue" },
  configNamespace = "typescript",
}

return {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
    typescript = {
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
  },
  filetypes = tsserver_filetypes,
}
