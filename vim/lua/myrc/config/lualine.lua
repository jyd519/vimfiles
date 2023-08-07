-- lualine {{{1
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

local hydra_status = require("hydra.statusline")
local spinner_symbols = { '🌑 ', '🌒 ', '🌓 ', '🌔 ', '🌕 ', '🌖 ', '🌗 ', '🌘 ' }
local ale_spinner = 0

require("lualine").setup({
  options = {
    theme = "auto",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      "branch",
      { "diff", source = diff_source },
      {
        "diagnostics",
        sources = { "nvim_lsp", "ale" },
      },
      {
        function()
          if hydra_status.is_active() then
            return hydra_status.get_name()
          end
          local ok, data = pcall(vim.fn["ale#engine#IsCheckingBuffer"], vim.api.nvim_get_current_buf())
          if ok and data == 1 then
            ale_spinner = (ale_spinner + 1) % #spinner_symbols
            return spinner_symbols[ale_spinner] .. "Checking ..."
          end
          return ""
        end,
        -- icon = { "🔍", color={fg="green"} },
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
      "lsp_progress",
    },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  -- winbar = {
  -- ...
  -- },
})
