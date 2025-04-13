vim.cmd[[
augroup vimrc
  autocmd!
augroup END
]]

local function augroup(name) return vim.api.nvim_create_augroup("myrc_" .. name, { clear = true }) end

-- Handling large file{{{2
-- https://www.reddit.com/r/neovim/comments/z85s1l/disable_lsp_for_very_large_files/
vim.api.nvim_create_autocmd({ "BufReadPre" }, {
  group = augroup("large_buf"),
  callback = function()
    vim.b.large_buf = false
    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
    if vim.fn.fnamemodify(bufname, ":e") == "log" then
      if vim.api.nvim_buf_line_count(vim.api.nvim_get_current_buf()) > 200000 then
        vim.b.large_buf = true
        vim.b.copilot_enabled = false
        vim.b.codeium_enabled = false
        vim.opt.foldmethod = "manual"
        vim.opt.spell = false
      end
      return
    end
    local ok, stats = pcall(vim.loop.fs_stat, bufname)
    if ok and stats and (stats.size > 1000000) then
      vim.b.large_buf = true
      vim.cmd("syntax off")
      vim.g.indent_blankline_enabled = false
      vim.b.copilot_enabled = false
      vim.b.codeium_enabled = false
      vim.opt.foldmethod = "manual"
      vim.opt.spell = false
    end
  end,
  pattern = "*",
})
-- }}}

-- Highlight Yanked Text
if vim.g.is_nvim then
  vim.api.nvim_create_augroup('YankHighlight', { clear = true })
  vim.api.nvim_create_autocmd('TextYankPost', {
    group = 'YankHighlight',
    callback = function()
      vim.highlight.on_yank()
    end,
  })
end

vim.api.nvim_create_autocmd('TermOpen', {
  group = 'vimrc',
  callback = function ()
    vim.keymap.set('n', 'q', '<c-w>c', { buffer = true, noremap = true })
  end,
})

-- Auto switching IME
if vim.fn.has("mac") == 1 and vim.fn.executable("im-select") == 1 then
  vim.api.nvim_create_autocmd('InsertLeave', {
    group = 'vimrc',
    callback = function()
      require('misc').Ime_en()
    end,
  })
  vim.api.nvim_create_autocmd('InsertEnter', {
    group = 'vimrc',
    callback = function()
      require('misc').Ime_zh()
    end,
  })
end

-- Close some filetypes with <q> {{{2
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query", -- :InspectTree
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
-- }}}

-- vim-test
vim.api.nvim_create_autocmd("Filetype", {
  pattern = { "javascript", "typescript", "go", "rust", "python" },
  group = vim.api.nvim_create_augroup("vimrc", { clear = true }),
  callback = function()
    vim.keymap.set("n", "<leader>rt", ":TestNearest<cr>", { buffer = true, silent = true })
    vim.keymap.set("n", "<leader>tt", ":TestNearest<cr>", { buffer = true, silent = true })
  end,
})

vim.api.nvim_create_autocmd("Filetype", {
  pattern = { "javascript", "typescript", "go", "python" },
  group = vim.api.nvim_create_augroup("vimrc", { clear = true }),
  callback = function()
    vim.keymap.set("n", "<leader>tf", ":TestFile<cr>", { buffer = true, silent = true })
  end,
})
