return {
-- Lualine {{{1
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      -- The icon font for Visual Studio Code
      { "ChristianChiarulli/neovim-codicons", lazy = true },
    },
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    config = function()
      local function diff_source()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
          }
        end
      end

      -- Cache chat lookup to avoid duplicate buf_get_chat calls per refresh
      local _chat_cache_buf, _chat_cache
      local function get_codecompanion_chat()
        local buf = vim.api.nvim_get_current_buf()
        if _chat_cache_buf ~= buf then
          _chat_cache_buf = buf
          _chat_cache = require("codecompanion").buf_get_chat(buf)
        end
        return _chat_cache
      end

      local function codecompanion_adapter_name()
        local chat = get_codecompanion_chat()
        if not chat then return nil end
        return chat.adapter.formatted_name
      end

      local function codecompanion_current_model_name()
        local chat = get_codecompanion_chat()
        if not chat then return nil end
        return chat.settings.model
      end

      local function kuala_env()
        local _, mod = pcall(require, "kulala")
        if not mod then return nil end
        return "🔨 " .. mod.get_selected_env()
      end

      local ale_spinner_symbols = { "🌑 ", "🌒 ", "🌓 ", "🌔 ", "🌕 ", "🌖 ", "🌗 ", "🌘 " }
      local ale_spinner = 0
      local _ale_checking = false
      local _ale_check_time = 0
      local _hydra_statusline
      local default_sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          {
            -- Hydra.nvim
            function()
              if package.loaded["hydra"] == nil then return "" end
              if _hydra_statusline == nil then
                local ok, mod = pcall(require, "hydra.statusline")
                if ok then _hydra_statusline = mod end
              end
              if _hydra_statusline and _hydra_statusline.is_active() then
                return " " .. _hydra_statusline.get_name()
              end
              return ""
            end,
            color = { bg = "red", fg = "white" },
          },
          { "diff", source = diff_source },
          {
            "diagnostics",
            sources = { "nvim_lsp", "ale" },
          },
          {
            function()
              local now = vim.uv.now()
              if now - _ale_check_time > 500 then
                _ale_check_time = now
                local ok, data = pcall(vim.fn["ale#engine#IsCheckingBuffer"], vim.api.nvim_get_current_buf())
                _ale_checking = (ok and data == 1)
              end
              if _ale_checking then
                ale_spinner = (ale_spinner % #ale_spinner_symbols) + 1
                return ale_spinner_symbols[ale_spinner] .. "Checking ..."
              end
              return ""
            end,
            color = { fg = "green" },
          },
        },
        lualine_c = {
          {
            "filename",
            file_status = true, -- Displays file status (readonly status, modified status)
            newfile_status = false, -- Display new file status (new file means no write after created)
            path = 1, -- 0: Just the filename
            -- 1: Relative path
            -- 2: Absolute path
            -- 3: Absolute path, with tilde as the home directory
            -- 4: Filename and parent dir, with tilde as the home directory
            shorting_target = 40, -- Shortens path to leave 40 spaces in the window
            -- for other components. (terrible name, any suggestions?)
            symbols = {
              modified = "[+]", -- Text to show when the file is modified.
              readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
              unnamed = "[No Name]", -- Text to show for unnamed buffers.
              newfile = "[New]", -- Text to show for newly created file before first write
            },
          },
        },
        lualine_x = {
          "encoding",
          "fileformat",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      }

      -- Create the http sections based on default and then modify
      local http_lualine_sections = vim.deepcopy(default_sections)
      table.insert(http_lualine_sections.lualine_x, 1, kuala_env) -- Insert "kulala" at the beginning

      require("lualine").setup({
        options = {
          theme = "powerline",
        },
        sections = default_sections,
        extensions = {
          {
            filetypes = { "http" },
            sections = http_lualine_sections,
          },
          {
            filetypes = { "codecompanion" },
            sections = {
              lualine_a = {
                "mode",
              },
              lualine_b = {
                codecompanion_adapter_name,
              },
              lualine_c = {
                codecompanion_current_model_name,
              },
              lualine_y = {
                "progress",
              },
              lualine_z = {
                "location",
              },
            },
            inactive_sections = {
              lualine_a = {},
              lualine_b = {
                codecompanion_adapter_name,
              },
              lualine_c = {},
              lualine_y = {
                "progress",
              },
              lualine_z = {},
            },
          },
        },

        -- winbar = {
        -- ...
        -- },
      })
    end,
  },
-- }}}
}
-- vim: set fdm=marker fdl=1:
