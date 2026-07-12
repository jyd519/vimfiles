return {
  {
    "Exafunction/windsurf.vim",
    event = { "BufEnter" },
    keys = {
      {
        "<leader>ait",
        function()
          if not vim.fn["codeium#Enabled"]() then
            vim.cmd("CodeiumEnable")
            vim.defer_fn(function() vim.notify("Codeium enabled", vim.log.levels.INFO, { title = "Codeium" }) end, 100)
          else
            vim.cmd("CodeiumDisable")
            vim.defer_fn(function() vim.notify("Codeium disabled", vim.log.levels.WARN, { title = "Codeium" }) end, 100)
          end
        end,
        desc = "Toggle Codeium",
      },
    },
    config = function()
      vim.g.codeium_no_map_tab = 1
      vim.g.codeium_enabled = true
      vim.g.codeium_filetypes = { ["dap-repl"] = false }

      local mapkey = require("keymap-amend")
      vim.keymap.set("i", "<C-g>", function() return vim.fn["codeium#Accept"]() end, { expr = true, desc = "Accept Codeium" })
      vim.keymap.set("i", "<C-;>", function() return vim.fn["codeium#CycleOrComplete"]() end, { expr = true, desc = "Trigger autocompletion" })
      mapkey("i", "<C-j>", function(fallback)
        if vim.b._codeium_completions ~= nil then
          return vim.fn["codeium#Clear"]()
        else
          fallback()
        end
      end, { silent = true, desc = "Clear Codeium Completions" })
    end,
  },
  {
    "github/copilot.vim",
    enabled = false,
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    cmd = {
      "CodeCompanion",
      "CodeCompanionCmd",
      "CodeCompanionChat",
      "CodeCompanionActions",
      "AIConfig",
    },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Code Companion Chat" },
      { "<leader>ae", function() require("codecompanion").prompt("explain") end, mode = "v", desc = "Explain code" },
      { "<leader>al", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions" },
      { "<leader>am", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "AI Chat Add" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "franco-ruggeri/codecompanion-spinner.nvim",
      "georgeharker/codecompanion-kimi.nvim",
      "ravitemer/codecompanion-history.nvim",
      {
        "ravitemer/mcphub.nvim",
        cmd = "MCPHub",
        build = "npm install -g mcp-hub@latest",
        config = true,
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        lazy = true,
        opts = {
          enabled = false,
          on = {
            attach = function()
              if vim.bo.ft == "codecompanion" then require("render-markdown").buf_enable() end
            end,
          },
        },
        ft = { "markdown", "codecompanion" },
      },
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        cmd = "PasteImage",
        opts = {
          filetypes = {
            codecompanion = {
              prompt_for_file_name = false,
              template = "[Image]($FILE_PATH)",
              use_absolute_path = true,
            },
          },
        },
      },
    },
    config = function()
      local default_proxy = vim.env.HTTP_PROXY or vim.g.proxy
      local default_lang = "Chinese"

      os.setlocale("C", "time")

      local function set_proxy()
        local config = require("codecompanion.config").config
        config.adapters.http.opts["proxy"] = default_proxy
      end

      local function unset_proxy()
        local config = require("codecompanion.config").config
        config.adapters.http.opts["proxy"] = nil
      end

      local function check_api_key(key_name)
        local api_key = vim.g[key_name]
        if not api_key then
          vim.notify("Error: " .. key_name .. " not set in vim.g", vim.log.levels.ERROR)
          return nil
        end
        return api_key
      end

      require("codecompanion").setup({
        opts = {
          language = default_lang,
          log_level = "ERROR",
          show_defaults = true,
        },
        display = {
          chat = {
            window = {
              position = "right",
              width = 0.50,
            },
          },
        },
        strategies = {
          chat = { adapter = "deepseek" },
          inline = {
            adapter = "deepseek",
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
          agent = { adapter = "deepseek" },
        },
        adapters = {
          http = {
            opts = {
              show_model_choices = true,
              show_defaults = false,
              allow_insecure = true,
            },
            gemini = function()
              local api_key = check_api_key("gemini_key")
              if not api_key then return nil end
              return require("codecompanion.adapters").extend("gemini", {
                env = { api_key = api_key },
                schema = { model = { default = "gemini-2.5-flash" } },
              })
            end,
            deepseek = function()
              local api_key = check_api_key("deepseek_key")
              if not api_key then return nil end
              return require("codecompanion.adapters").extend("deepseek", {
                env = { api_key = api_key },
                schema = {
                  model = { default = "deepseek-v4-flash" },
                  temperature = { default = 0.0 },
                },
              })
            end,
            deepseek2 = function()
              local api_key = check_api_key("deepseek_key")
              if not api_key then return nil end
              return require("codecompanion.adapters").extend("deepseek", {
                env = { api_key = api_key },
                schema = {
                  model = { default = "deepseek-v4-flash" },
                  ["thinking.type"] = { default = "disabled" },
                  temperature = { default = 0.0 },
                },
              })
            end,
            openrouter_claude = function()
              local api_key = check_api_key("openrouter_key")
              if not api_key then return nil end
              return require("codecompanion.adapters").extend("openai_compatible", {
                env = {
                  url = "https://openrouter.ai/api",
                  api_key = api_key,
                  chat_url = "/v1/chat/completions",
                },
                schema = { model = { default = "anthropic/claude-sonnet-4.6" } },
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
                    },
                  },
                },
              })
            end,
            kimi = function()
              local api_key = check_api_key("kimi_key")
              if not api_key then return nil end
              return require("codecompanion.adapters").extend("kimi", {
                env = {
                  url = "https://api.moonshot.cn",
                  api_key = api_key,
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
                    return { model = "llama-3.3-70b-versatile" }
                  end,
                },
              })
            end,
            tavily = function()
              local api_key = check_api_key("tavily_key")
              if not api_key then return nil end
              return require("codecompanion.adapters").extend("tavily", {
                env = { api_key = api_key },
              })
            end,
          },
          acp = {
            opts = {},
            gemini_cli = function()
              return require("codecompanion.adapters").extend("gemini_cli", {
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
              })
            end,
          },
        },
        prompt_library = {
          markdown = {
            dirs = {
              vim.fn.getcwd() .. "/.prompts",
              vim.g.VIMFILES .. "/prompts",
            },
          },
        },
        extensions = {
          spinner = {},
        },
        mcp = {
          servers = {
            ["context7"] = {
              cmd = {
                "npx",
                "-y",
                "@upstash/context7-mcp@latest",
                "--api-key",
                "ctx7sk-d036a870-7911-454f-82c4-bf1de82c0ef1",
              },
            },
          },
        },
      })

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

      -- Auto set/unset proxy based on adapter
      local proxy_adapters = {
        gemini = true,
        openrouter_claude = true,
        groq = true,
      }

      local http = require("codecompanion.http")
      local origin_http_new = http.new
      http.new = function(opts)
        if proxy_adapters[opts.adapter.name] then
          set_proxy()
        else
          unset_proxy()
        end
        return origin_http_new(opts)
      end

      vim.cmd([[cab cc CodeCompanion]])
      vim.cmd([[cab ccc CodeCompanionChat]])
    end,
  },
}
