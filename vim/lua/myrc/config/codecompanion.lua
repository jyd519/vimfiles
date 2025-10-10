local default_proxy = vim.env.HTTP_PROXY or vim.g.proxy
local default_lang = "English"

-- [codecompanion] system prompt needs to be in C locale
os.setlocale("C", "time")

-- Function to set proxy
local function set_proxy()
  local config = require("codecompanion.config").config
  config.adapters.http.opts["proxy"] = default_proxy
  -- vim.notify("codecompanion: " .. tostring(config.adapters.http.opts["proxy"]), vim.log.levels.INFO)
end

-- Function to unset proxy
local function unset_proxy()
  local config = require("codecompanion.config").config
  config.adapters.http.opts["proxy"] = nil
  -- vim.notify("codecompanion: proxy cleared", vim.log.levels.INFO)
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
  ["DeepSeek Explain In Chinese"] = {
    strategy = "chat",
    description = "解释代码",
    opts = {
      index = 5,
      is_default = true,
      is_slash_cmd = false,
      modes = { "v" },
      short_name = "explain in chinese",
      auto_submit = true,
      user_prompt = false,
      stop_context_insertion = true,
      adapter = {
        name = "deepseek",
        model = "deepseek-chat",
      },
    },
    prompts = {
      {
        role = "system",
        content = [[当被要求解释代码时，请遵循以下步骤：

  1. 识别编程语言。
  2. 描述代码的目的，并引用该编程语言的核心概念。
  3. 解释每个函数或重要的代码块，包括参数和返回值。
  4. 突出说明使用的任何特定函数或方法及其作用。
  5. 如果适用，提供该代码如何融入更大应用程序的上下文。]],
        opts = {
          visible = false,
        },
      },
      {
        role = "user",
        content = function(context)
          local input = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

          return string.format(
            [[请解释 buffer %d 中的这段代码:

  ```%s
  %s
  ```
  ]],
            context.bufnr,
            context.filetype,
            input
          )
        end,
        opts = {
          contains_code = true,
        },
      },
    },
  },
}

-- setup
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
    chat = { adapter = "gemini" },
    inline = {
      adapter = "kimi",
      keymaps = {
        accept_change = {
          modes = { n = "ga" },
          description = "Accept the suggested change",
        },
        reject_change = {
          modes = { n = "gr" },
          description = "Reject the suggested change",
        },
      },
    },
    agent = { adapter = "kimi" },
  },
  adapters = {
    http = {
      opts = {
        show_defaults = false,
        allow_insecure = true,
        show_model_choices = true,
      },
      gemini = function(a)
        local api_key = check_api_key("gemini_key")
        if not api_key then return nil end
        return require("codecompanion.adapters").extend("gemini", {
          env = {
            api_key = api_key,
          },
          schema = {
            model = {
              default = "gemini-2.5-flash",
            },
          },
        })
      end,
      deepseek = function()
        local api_key = check_api_key("deepseek_key")
        if not api_key then return nil end
        return require("codecompanion.adapters").extend("deepseek", {
          env = {
            api_key = api_key,
          },
          schema = {
            model = {
              default = "deepseek-chat",
            },
          },
        })
      end,
      openrouter_claude = function()
        local default_model = "anthropic/claude-sonnet-4.5"
        local current_model = default_model
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
              default = "doubao-seed-1-6-flash-250828",
              choices = {
                "doubao-seed-1-6-flash-250828",
                "doubao-seed-1-6-250615",
                ["doubao-seed-1-6-thinking-250715"] = { opts = { can_reason = true } },
                ["deepseek-r1-250528"] = { opts = { can_reason = true } },
                "deepseek-v3-1-terminus",
                "kimi-k2-250905",
              },
            },
          },
        })
      end,
      kimi = function()
        -- https://platform.moonshot.cn/console/account
        local api_key = check_api_key("kimi_key")
        if not api_key then return nil end
        return require("codecompanion.adapters").extend("openai_compatible", {
          formatted_name = "Kimi",
          env = {
            url = "https://api.moonshot.cn",
            api_key = api_key,
            chat_url = "/v1/chat/completions",
          },
        })
      end,
      groq = function()
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
    acp = {
      opts = {},
      gemini_cli = function() return require("codecompanion.adapters").extend("gemini_cli", {
        commands = {
          default = {
            "gemini",
            "--experimental-acp",
            "--proxy",
            default_proxy,
          },
          yolo = {
            "gemini",
            "--yolo",
            "--experimental-acp",
            "--proxy",
            default_proxy,
          },
        },
      }) end,
    },
  },
  prompt_library = prompt_library,
  extensions = {
    spinner = {},
    mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        make_vars = true,
        make_slash_commands = true,
        show_result_in_chat = true,
      },
    },
  },
})

--- Add commands
vim.api.nvim_create_user_command("AIConfig", function(args)
  local config = require("codecompanion.config").config
  if #args.fargs == 0 then put(config.opts["language"], config.adapters.http.opts) end
  for _, v in pairs(args.fargs) do
    if v == "proxy" then
      config.adapters.http.opts["proxy"] = vim.g.proxy
      vim.notify("codecompanion: " .. tostring(config.adapters.http.opts["proxy"]), vim.log.levels.INFO)
    end
    if v == "noproxy" then config.adapters.http.opts["proxy"] = nil end
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

-- Set or unset proxy based on the adapter name
local adapter_proxy = {
  gemini = true,
  openrouter_claude = true,
  groq = true,
}

local http = require("codecompanion.http")
local origin_http_new = http.new
http.new = function(opts)
  if adapter_proxy[opts.adapter.name] then
    set_proxy()
  else
    unset_proxy()
  end
  return origin_http_new(opts)
end
