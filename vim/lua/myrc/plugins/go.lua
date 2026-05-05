return {
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod" },
    enabled = vim.g.enabled_plugins.go == 1,
    dependencies = { "ray-x/guihua.lua" },
    config = function()
      local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function() require("go.format").goimports() end,
        group = format_sync_grp,
      })

      require("go").setup({
        ai = {
          enable = false, -- set to true to enable AI features (GoAI, GoCmtAI)
          provider = "copilot", -- 'copilot' or 'openai' (any OpenAI-compatible endpoint)
          model = nil, -- model name, default: 'gpt-4o' for copilot, 'gpt-4o-mini' for openai
          api_key_env = "OPENAI_API_KEY", -- env var name that holds the API key, env only! DO NOT put your key here.
          base_url = nil, -- for openai-compatible APIs, e.g.: 'https://api.openai.com/v1'
          confirm = true, -- confirm before executing the translated command
        },
        luasnip = true,
      })
    end,
  },
}
