local g = vim.g

return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      { "rafamadriz/friendly-snippets" },
      { "honza/vim-snippets" },
    },
    config = function()
      local luasnip = require("luasnip")
      -- Use existing vs-code style snippets from a plugin (eg. rafamadriz/friendly-snippets)
      -- require("luasnip.loaders.from_vscode").lazy_load()

      -- snipmate format
      --    https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#from_snipmate
      require("luasnip.loaders.from_snipmate").lazy_load()
      require("luasnip.loaders.from_snipmate").lazy_load({ paths = vim.fn.expand("$VIMFILES/mysnippets/snippets") })

      luasnip.filetype_extend("all", { "_" })
      luasnip.filetype_extend("typescript", { "javascript" })

      vim.api.nvim_create_user_command(
        "ReloadSnippet",
        function()
          require("luasnip.loaders.from_snipmate").lazy_load({ paths = vim.fn.expand("$VIMFILES/mysnippets/snippets") })
        end,
        { nargs = 0 }
      )

      vim.api.nvim_create_user_command("EditSnippet", function(args)
        local typ = args.args
        if typ == "" then typ = vim.bo.filetype end
        if typ == "" then typ = "all" end
        local _, dot = string.find(typ, "%.")
        if dot ~= nil then typ = string.sub(typ, dot + 1, -1) end
        local snippet_file = vim.fn.expand("$VIMFILES/mysnippets/snippets/" .. typ .. ".snippets")
        vim.cmd("e " .. snippet_file)
      end, { nargs = "?" })

      local types = require("luasnip.util.types")
      luasnip.config.setup({
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { "⛏️ ", "GruvboxOrange" } },
            },
          },
          [types.insertNode] = {
            active = {
              virt_text = { { "✍️ ", "GruvboxBlue" } },
            },
          },
        },
      })
    end,
  },

  {
    "SirVer/ultisnips",
    lazy = true,
    config = function()
      vim.keymap.set({ "i", "s" }, "<C-l>", "<C-R>=UltiSnips#ListSnippets()<CR>", { silent = true })
    end,
    event = { "BufReadPost", "BufNewFile" },
  },

  {
    "saghen/blink.cmp",
    event = "VeryLazy",
    version = '1.*',
    dependencies = {
      { "saghen/blink.lib" },
    },
    build = function() require("blink.cmp").build():pwait() end,
    config = function()
      local luasnip = require("luasnip")

      local is_insert_keys = function(keys)
        if type(keys) == "string" and not (keys == "" or keys == "\\<C-N>" or keys == "\t") then return true end
        return false
      end

      require("blink.cmp").setup({
        snippets = { preset = "luasnip" },
        keymap = {
          ["<C-b>"] = { function(cmp) return cmp.scroll_documentation_up(4) end },
          ["<C-f>"] = { function(cmp) return cmp.scroll_documentation_down(4) end },
          ["<C-x><C-o>"] = { "show" },
          ["<C-e>"] = {
            function(cmp)
              luasnip.unlink_current()
              cmp.hide()
              return true
            end,
          },
          ["<Esc>"] = {
            function(cmp) luasnip.unlink_current() end,
            "fallback",
          },
          ["<C-y>"] = { "select_and_accept", "fallback" },
          ["<CR>"] = { "accept", "fallback" },
          ["<C-h>"] = {
            function(cmp)
              if luasnip.jumpable(-1) then
                luasnip.jump(-1)
                return true
              end
            end,
            "fallback",
          },
          ["<C-k>"] = {
            function(cmp)
              -- local codeium_keys = vim.fn["codeium#Accept"]()
              if luasnip.jumpable() then
                luasnip.expand_or_jump()
                return true
              end
              if vim.g.neocodeium_enable then
                local neocodeium = require("neocodeium")
                if neocodeium.visible() then
                  neocodeium.accept()
                  return true
                end
              end
              -- if is_insert_keys(codeium_keys) then
              --   vim.api.nvim_feedkeys(codeium_keys, "i", true)
              --   return true
              -- end
            end,
            "select_and_accept",
            function(cmp)
              if luasnip.expandable() then
                luasnip.expand_or_jump()
                return true
              end
            end,
            "fallback",
          },
          ["<C-p>"] = {
            "select_prev",
            function(cmp)
              if luasnip.choice_active() then
                luasnip.change_choice(-1)
                return true
              end
              if vim.g.neocodeium_enable then
                local neocodeium = require("neocodeium")
                neocodeium.cycle_or_complete(-1)
              end
              -- if (vim.b._codeium_status or 0) > 0 then
              --   vim.fn["codeium#CycleCompletions"](1)
              --   return true
              -- end
            end,
            "fallback_to_mappings",
          },

          ["<C-n>"] = {
            "select_next",
            function(cmp)
              if luasnip.choice_active() then
                luasnip.change_choice(1)
                return true
              end

              if vim.g.neocodeium_enable then
                local neocodeium = require("neocodeium")
                neocodeium.cycle_or_complete(1)
              end
              -- if (vim.b._codeium_status or 0) > 0 then
              --   vim.fn["codeium#CycleCompletions"](-1)
              --   return true
              -- end
            end,
            "fallback_to_mappings",
          },

          ["<C-l>"] = {
            function(cmp)
              if luasnip.choice_active() then
                luasnip.change_choice(-1)
                return true
              end
            end,
            "fallback",
          },

          ["<C-u>"] = {
            function(cmp)
              if luasnip.choice_active() then
                require("luasnip.extras.select_choice")()
                return true
              end
            end,
            "fallback",
          },

          ["<Tab>"] = {
            function(cmp)
              -- local codeium_keys = vim.fn["codeium#Accept"]()
              if luasnip.jumpable() then
                luasnip.expand_or_jump()
                return true
              end
              if vim.g.neocodeium_enable then
                local neocodeium = require("neocodeium")
                if neocodeium.visible() then
                  neocodeium.accept()
                  return true
                end
              end
              -- if is_insert_keys(codeium_keys) then
              --   vim.api.nvim_feedkeys(codeium_keys, "i", true)
              --   return true
              -- end
            end,
            "select_and_accept",
            function(cmp)
              if luasnip.expandable() then
                luasnip.expand_or_jump()
                return true
              end
            end,
            "fallback",
          },

          ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        },

        completion = {
          documentation = {
            auto_show = true,
            window = { border = "rounded" },
          },
          menu = {
            border = "rounded",
            draw = {
              columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
            },
          },
          list = {
            selection = {
              preselect = true,
              auto_insert = false,
            },
          },
        },

        sources = {
          default = { "lsp", "snippets", "path", "buffer", },
          providers = {
            lsp = { max_items = 20 },
            -- codeium = { name = 'Codeium', module = 'codeium.blink', async = true },
          },
        },
        cmdline = {
          keymap = {
            ["<Tab>"] = { "accept" },
            ["<CR>"] = { "accept_and_enter", "fallback" },
          },
          completion = { menu = { auto_show = true } },
        },
        fuzzy = { implementation = "rust" },
      })
    end,
  },
}
