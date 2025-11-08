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

local function codecompanion_adapter_name()
  local chat = require("codecompanion").buf_get_chat(vim.api.nvim_get_current_buf())
  if not chat then return nil end

  return chat.adapter.formatted_name
end

local function codecompanion_current_model_name()
  local chat = require("codecompanion").buf_get_chat(vim.api.nvim_get_current_buf())
  if not chat then return nil end

  return chat.settings.model
end

local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})
local ai_processing = false
local ai_spinner_symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

local ai_spinner_index = 1
vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "CodeCompanionRequest*",
  group = group,
  callback = function(request)
    if request.match == "CodeCompanionRequestStarted" then
      ai_processing = true
    elseif request.match == "CodeCompanionRequestFinished" then
      ai_processing = false
    end
  end,
})

local function ai_status()
  if ai_processing then
    ai_spinner_index = (ai_spinner_index % #ai_spinner_symbols) + 1
    return ai_spinner_symbols[ai_spinner_index]
  else
    return ""
  end
end

local spinner_symbols = { "🌑 ", "🌒 ", "🌓 ", "🌔 ", "🌕 ", "🌖 ", "🌗 ", "🌘 " }
local ale_spinner = 0
local _, hydra = pcall(require, "hydra.statusline")
local default_sections = {
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
        local ok, data = pcall(vim.fn["ale#engine#IsCheckingBuffer"], vim.api.nvim_get_current_buf())
        if ok and data == 1 then
          ale_spinner = (ale_spinner + 1) % #spinner_symbols
          return spinner_symbols[ale_spinner] .. "Checking ..."
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
    "lsp_progress",
  },
  lualine_x = {
    {
      -- Hydra.nvim
      function()
        if hydra and hydra.is_active() then return hydra.get_name() end
        return ""
      end,
    },
    "encoding",
    "fileformat",
    "filetype",
  },
  lualine_y = { "progress" },
  lualine_z = { "location" },
}

-- Deep copy function for tables (simplified for this use case)
local function deep_copy(t)
  if type(t) ~= "table" then return t end
  local new_t = {}
  for k, v in pairs(t) do
    new_t[k] = deep_copy(v)
  end
  return new_t
end

-- Create the http sections based on default and then modify
local http_lualine_sections = deep_copy(default_sections)
-- Modify only the lualine_x section for http
table.insert(http_lualine_sections.lualine_x, 1, "kulala") -- Insert "kulala" at the beginning

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
        lualine_x = {
          { ai_status, color = { fg = "white" } },
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
        lualine_x = {
          { ai_status, color = { fg = "white" } },
        },
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
