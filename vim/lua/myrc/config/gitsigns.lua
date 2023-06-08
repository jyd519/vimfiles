-- gitsigns -- {{{1
-- https://github.com/lewis6991/gitsigns.nvim
local gitsigns = require("gitsigns")
local Hydra, _ = prequire("hydra")

local hint = [[
 _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
 _K_: prev hunk   _u_: undo last stage   _p_: preview hunk   _B_: blame show full 
 ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
 ^
 ^ ^              _<Enter>_: Neogit              _q_: exit
]]

local setupBufMapping = function(bufnr)
  if Hydra then
    Hydra({
      name = "Git",
      bufnr = bufnr,
      hint = hint,
      config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
          border = "rounded",
        },
        on_enter = function()
          vim.cmd("mkview")
          vim.cmd("silent! %foldopen!")
          vim.bo.modifiable = false
          gitsigns.toggle_signs(true)
          gitsigns.toggle_linehl(true)
        end,
        on_exit = function()
          local cursor_pos = vim.api.nvim_win_get_cursor(0)
          vim.cmd("loadview")
          vim.api.nvim_win_set_cursor(0, cursor_pos)
          vim.cmd("normal zv")
          gitsigns.toggle_signs(false)
          gitsigns.toggle_linehl(false)
          gitsigns.toggle_deleted(false)
        end,
      },
      mode = { "n", "x" },
      body = "<leader>g",
      heads = {
        {
          "J",
          function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gitsigns.next_hunk()
            end)
            return "<Ignore>"
          end,
          { expr = true, desc = "next hunk" },
        },
        {
          "K",
          function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gitsigns.prev_hunk()
            end)
            return "<Ignore>"
          end,
          { expr = true, desc = "prev hunk" },
        },
        { "s", ":Gitsigns stage_hunk<CR>", { silent = true, desc = "stage hunk" } },
        { "u", gitsigns.undo_stage_hunk, { desc = "undo last stage" } },
        { "S", gitsigns.stage_buffer, { desc = "stage buffer" } },
        { "p", gitsigns.preview_hunk, { desc = "preview hunk" } },
        { "d", gitsigns.toggle_deleted, { nowait = true, desc = "toggle deleted" } },
        { "b", gitsigns.blame_line, { desc = "blame" } },
        {
          "B",
          function()
            gitsigns.blame_line({ full = true })
          end,
          { desc = "blame show full" },
        },
        { "/", gitsigns.show, { exit = true, desc = "show base file" } }, -- show the base of the file
        { "<Enter>", "<Cmd>Neogit<CR>", { exit = true, desc = "Neogit" } },
        { "q", nil, { exit = true, nowait = true, desc = "exit" } },
      },
    })
    return
  end

  local gs = package.loaded.gitsigns

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

  map("n", "<leader>tb", gs.toggle_current_line_blame)
  map("n", "<leader>td", gs.toggle_deleted)

  -- Text object
  map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
end

gitsigns.setup({
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  on_attach = function(bufnr)
    setupBufMapping(bufnr)
  end,
})
