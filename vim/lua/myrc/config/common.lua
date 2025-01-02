-- Globals {{{2
local vim, g, api = vim, vim.g, vim.api
local keymap = vim.keymap
keymap.amend = prequire("keymap-amend")

local function augroup(name)
  return api.nvim_create_augroup("myrc_" .. name, { clear = true })
end
-- }}}

-- Cancel search highlighting {{{2
if keymap.amend then
  keymap.amend("n", "<Esc>", function(original)
    if vim.v.hlsearch and vim.v.hlsearch == 1 then
      vim.cmd("nohlsearch")
    end
    original()
  end, { desc = "disable search highlight" })
end
-- }}}

-- Lookup ansible-doc {{{2
vim.api.nvim_create_user_command("Adoc", function(args)
  vim.cmd(
    "new | setlocal buftype=nofile bufhidden=hide noswapfile ft=man sw=4 |" .. "r !ansible-doc " .. args.args .. ""
  )
  vim.defer_fn(function()
    vim.cmd('exec "norm ggM"')
  end, 100)
end, {
  nargs = "+",
  desc = "Lookup ansible document",
})
-- }}}

-- Toggle Dark-Mode{{{2
vim.api.nvim_create_user_command("Dark", function(args)
  if vim.env.LC_TERMINAL ~= "iTerm2" then
    if vim.o.background == "light" then
      vim.o.background = "dark"
    else
      vim.o.background = "light"
    end
    return
  end
  --  Switch iTerm2 profile based on light/dark mode
  if vim.o.background == "light" then
    vim.o.background = "dark"
    vim.loop.fs_write(2, "\27Ptmux;\27\27]1337;SetProfile=Default-dark\7\27\\", -1)
  else
    vim.o.background = "light"
    vim.loop.fs_write(2, "\27Ptmux;\27\27]1337;SetProfile=Default\7\27\\", -1)
  end
end, {
  desc = "Toggle dark mode",
})
api.nvim_set_keymap("n", "<leader>td", "<cmd>Dark<CR>", { noremap = true })
-- }}}

-- Handling large file{{{2
-- https://www.reddit.com/r/neovim/comments/z85s1l/disable_lsp_for_very_large_files/
vim.api.nvim_create_autocmd({ "BufReadPre" }, {
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
  group = augroup("large_buf"),
  pattern = "*",
})
-- }}}

-- Lsp formatting {{{2
api.nvim_create_user_command("Format", function()
  vim.lsp.buf.format({ async = true })
end, {
  desc = "Format the current buffer",
})
-- }}}

-- close some filetypes with <q> {{{2
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
-- vim: set fdm=marker fdl=1: }}}
