require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "groq",
    },
    inline = {
      adapter = "groq",
    },
  },
  opts = {
    language = "English",
    -- log_level = "DEBUG",
  },
  adapters = {
    opts = {
      -- allow_insecure = true,
      proxy = vim.g.proxy,
    },
    gemini = function()
      local api_key = vim.g.gemini_key
      if not api_key then
        print("Error: gemini_key not set in vim.g")
        return nil -- or handle the error appropriately
      end
      return require("codecompanion.adapters").extend("gemini", {
        env = {
          api_key = api_key,
        },
      })
    end,
    deepseek = function()
      local api_key = vim.g.deepseek_key
      if not api_key then
        print("Error: deepseek_key not set in vim.g")
        return nil -- or handle the error appropriately
      end
      return require("codecompanion.adapters").extend("openai_compatible", {
        env = {
          url = "https://api.deepseek.com",
          api_key = api_key,
          chat_url = "/chat/completions",
          language = "Chinese",
          proxy = "",
        },
      })
    end,
    groq = function()
      local api_key = vim.g.groq_key
      if not api_key then
        print("Error: groq_key not set in vim.g")
        return nil -- or handle the error appropriately
      end
      return require("codecompanion.adapters").extend("openai_compatible", {
        env = {
          url = "https://api.groq.com/openai",
          api_key = api_key,
          chat_url = "/v1/chat/completions",
        },
        handlers = {
          form_parameters = function()
            return {
              model = "llama-3.3-70b-versatile",
            }
          end,
        },
      })
    end,
  },
})
