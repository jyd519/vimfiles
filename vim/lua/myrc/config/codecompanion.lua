local default_proxy = vim.env.HTTP_PROXY or vim.g.proxy
local default_adapter = vim.g.llm_adapter or "gemini"
local default_lang = "English"

local function set_proxy()
  local config = require("codecompanion.config").config
  config.adapters.opts["proxy"] = default_proxy
end

-- Function to unset proxy
local function unset_proxy()
  local config = require("codecompanion.config").config
  config.adapters.opts["proxy"] = nil
end

local function check_api_key(key_name)
  local api_key = vim.g[key_name]
  if not api_key then
    vim.notify("Error: " .. key_name .. " not set in vim.g", vim.log.levels.ERROR)
    return nil
  end
  return api_key
end

local prompt_library = {
  ["ExplainIt"] = {
    strategy = "chat",
    description = "explain",
    prompts = {
      {
        role = "system",
        content = "You are an experienced developer",
      },
      {
        role = "user",
        content = "Explain this code as I'm five years old.",
      },
    },
  },
}

require("codecompanion").setup({
  opts = {
    language = default_lang,
    log_level = "ERROR", -- TRACE|DEBUG|ERROR|INFO
    show_defaults = false,
  },
  display = {
    chat = {
      window = {
        position = "right",
        width = 0.40,
      },
    },
  },
  strategies = {
    chat = { adapter = default_adapter },
    inline = { adapter = default_adapter },
    agent = { adapter = default_adapter },
  },
  adapters = {
    opts = {
      allow_insecure = true,
      proxy = default_proxy,
    },
    gemini = function()
      set_proxy()
      local api_key = check_api_key("gemini_key")
      if not api_key then return nil end
      return require("codecompanion.adapters").extend("gemini", {
        env = {
          api_key = api_key,
        },
        schema = {
          model = {
            default = "gemini-2.0-flash-exp",
          },
        },
      })
    end,
    deepseek = function()
      unset_proxy()
      local api_key = check_api_key("deepseek_key")
      if not api_key then return nil end
      return require("codecompanion.adapters").extend("deepseek", {
        env = {
          api_key = api_key,
        },
      })
    end,
    openrouter_claude = function()
      local default_model = "anthropic/claude-3.5-sonnet"
      local available_models = {
        "anthropic/claude-3.7-sonnet",
        "anthropic/claude-3.5-sonnet",
        "openai/gpt-4o-mini",
      }
      local current_model = default_model
      local function select_model()
        vim.ui.select(available_models, {
          prompt = "Select  Model:",
        }, function(choice)
          if choice then
            current_model = choice
            vim.notify("Selected model: " .. current_model)
          end
        end)
      end
      local api_key = check_api_key("openrouter_key")
      if not api_key then return nil end
      return require("codecompanion.adapters").extend("openai_compatible", {
        env = {
          url = "https://openrouter.ai/api",
          api_key = api_key,
          chat_url = "/v1/chat/completions",
        },
        schema = {
          model = {
            default = current_model,
          },
        },
      })
    end,
    volengine = function()
      unset_proxy()
      local api_key = check_api_key("volcengine_key")
      if not api_key then return nil end
      return require("codecompanion.adapters").extend("openai_compatible", {
        formatted_name = "volengine",
        env = {
          url = "https://ark.cn-beijing.volces.com/api",
          api_key = api_key,
          chat_url = "/v3/chat/completions",
        },
        schema = {
          model = {
            default = "ep-20250207214324-pqmgx",
            choices = {
              "ep-20250207214324-pqmgx",
              ["ep-20250209143728-fqwwh"] = { opts = { can_reason = true } },
              "ep-20250207214959-56z42",
            },
          },
        },
      })
    end,
    groq = function()
      set_proxy()
      local api_key = check_api_key("groq_key")
      if not api_key then return nil end
      return require("codecompanion.adapters").extend("openai_compatible", {
        formatted_name = "Groq",
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
  prompt_library = prompt_library,
})

--- Add commands
vim.api.nvim_create_user_command("AIConfig", function(args)
  local config = require("codecompanion.config").config
  if #args.fargs == 0 then put(config.opts["language"], config.adapters.opts) end
  for _, v in pairs(args.fargs) do
    if v == "proxy" then
      default_proxy = vim.env.HTTP_PROXY or vim.g.proxy
      config.adapters.opts["proxy"] = vim.g.proxy
      vim.notify("codecompanion: " .. tostring(config.adapters.opts["proxy"]), vim.log.levels.INFO)
    end
    if v == "noproxy" then
      default_proxy = nil
      config.adapters.opts["proxy"] = nil
    end
    if v == "zh" then
      default_lang = "Chinese"
      config.opts.language = "Chinese"
    end
    if v == "en" then
      default_lang = "English"
      config.opts.language = "English"
    end
  end
end, {
  nargs = "*",
  desc = "Config codecompanion: proxy, language",
  complete = function() return { "proxy", "noproxy", "zh", "en" } end,
})
