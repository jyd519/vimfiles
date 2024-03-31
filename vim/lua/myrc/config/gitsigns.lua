-- gitsigns -- {{{1
-- https://github.com/lewis6991/gitsigns.nvim
local gs = require("gitsigns")

local setupBufMapping = function(bufnr)
  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end

  -- Navigation
  map("n", "]c", function()
    if vim.wo.diff then
      return "]c"
    end
    vim.schedule(function()
      gs.next_hunk()
    end)
    return "<Ignore>"
  end, { expr = true })

  map("n", "[c", function()
    if vim.wo.diff then
      return "[c"
    end
    vim.schedule(function()
      gs.prev_hunk()
    end)
    return "<Ignore>"
  end, { expr = true })

  -- Actions
  map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
  map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
  map("n", "<leader>hS", gs.stage_buffer)
  map("n", "<leader>hu", gs.undo_stage_hunk)
  map("n", "<leader>hR", gs.reset_buffer)
  map("n", "<leader>hp", gs.preview_hunk)
  map("n", "<leader>hB", function()
    gs.blame_line({ full = true })
  end)
  map("n", "<leader>hd", gs.diffthis)
  map("n", "<leader>hD", function()
    gs.diffthis("~")
  end)

  map("n", "<leader>hb", gs.toggle_current_line_blame)
  map("n", "<leader>td", gs.toggle_deleted)

  -- Text object
  map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
end

gs.setup({
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  on_attach = function(bufnr)
    -- setupBufMapping(bufnr)
  end,
})

local Hydra = require("hydra")

local hint = [[
 _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
 _K_: prev hunk   _u_: undo last stage   _p_: preview hunk   _B_: blame show full 
 ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
 ^
 ^ ^              _<Enter>_: Neogit              _q_: exit
]]

Hydra({
   name = 'Git',
   hint = hint,
   config = {
      buffer = bufnr,
      color = 'pink',
      invoke_on_body = true,
      hint = {
        float_opts = {
            -- row, col, height, width, relative, and anchor should not be
            -- overridden
            style = "minimal",
            focusable = false,
            noautocmd = true,
        },
      },
      on_enter = function()
         vim.cmd 'mkview'
         vim.cmd 'silent! %foldopen!'
         vim.bo.modifiable = false
         gs.toggle_signs(true)
         gs.toggle_linehl(true)
      end,
      on_exit = function()
         local cursor_pos = vim.api.nvim_win_get_cursor(0)
         vim.cmd 'loadview'
         vim.api.nvim_win_set_cursor(0, cursor_pos)
         vim.cmd 'normal zv'
         gs.toggle_signs(false)
         gs.toggle_linehl(false)
         gs.toggle_deleted(false)
      end,
   },
   mode = {'n','x'},
   body = '<leader>g',
   heads = {
      { 'J',
         function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
         end,
         { expr = true, desc = 'next hunk' } },
      { 'K',
         function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
         end,
         { expr = true, desc = 'prev hunk' } },
      { 's', ':Gitsigns stage_hunk<CR>', { silent = true, desc = 'stage hunk' } },
      { 'u', gs.undo_stage_hunk, { desc = 'undo last stage' } },
      { 'S', gs.stage_buffer, { desc = 'stage buffer' } },
      { 'p', gs.preview_hunk, { desc = 'preview hunk' } },
      { 'd', gs.toggle_deleted, { nowait = true, desc = 'toggle deleted' } },
      { 'b', gs.blame_line, { desc = 'blame' } },
      { 'B', function() gs.blame_line{ full = true } end, { desc = 'blame show full' } },
      { '/', gs.show, { exit = true, desc = 'show base file' } }, -- show the base of the file
      { '<Enter>', '<Cmd>Neogit<CR>', { exit = true, desc = 'Neogit' } },
      { 'q', nil, { exit = true, nowait = true, desc = 'exit' } },
   }
})

