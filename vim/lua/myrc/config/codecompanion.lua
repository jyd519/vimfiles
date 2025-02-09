local default_proxy = vim.env.HTTP_PROXY or vim.g.proxy
local default_adapter = vim.g.llm_adapter or "gemini"

local function restoreProxy()
  local config = require("codecompanion.config").config
  config.adapters.opts["proxy"] = default_proxy
end

require("codecompanion").setup({
  display = {
    chat = {
      window = {
        position = "right",
      },
    },
  },
  strategies = {
    chat = { adapter = default_adapter },
    inline = { adapter = default_adapter },
    agent = { adapter = default_adapter },
  },
  opts = {
    language = "English",
    log_level = "ERROR", -- TRACE|DEBUG|ERROR|INFO
  },
  adapters = {
    opts = {
      allow_insecure = true,
      proxy = default_proxy,
    },
    gemini = function()
      restoreProxy()
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
      local config = require("codecompanion.config").config
      config.adapters.opts["proxy"] = nil

      local api_key = vim.g.deepseek_key
      if not api_key then
        print("Error: deepseek_key not set in vim.g")
        return nil
      end
      return require("codecompanion.adapters").extend("deepseek", {
        env = {
          api_key = api_key,
        },
      })
    end,
    groq = function()
      restoreProxy()
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

--- Add commands
vim.api.nvim_create_user_command("AIConfig", function(args)
  local config = require("codecompanion.config").config
  if #args.fargs == 0 then
    put(config.opts["language"], config.adapters.opts)
  end
  for _, v in pairs(args.fargs) do
    if v == "proxy" then
      default_proxy = vim.env.HTTP_PROXY or vim.g.proxy
      config.adapters.opts["proxy"] = vim.g.proxy
      print("codecompanion: ", config.adapters.opts["proxy"])
    end
    if v == "noproxy" then
      default_proxy = nil
      config.adapters.opts["proxy"] = nil
    end
    if v == "zh" then config.opts.language = "Chinese" end
    if v == "en" then config.opts.language = "English" end
  end
end, {
  nargs = "*",
  desc = "Config codecompanion: proxy, language",
  complete = function() return { "proxy", "noproxy", "zh", "en" } end,
})
