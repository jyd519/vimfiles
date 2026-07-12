local map = vim.keymap.set

-- venn.nvim: enable or disable keymappings {{{1
-- https://github.com/jbyuki/venn.nvim
function _G.Toggle_venn()
  local venn_enabled = vim.inspect(vim.b.venn_enabled)
  if venn_enabled == "nil" then
    vim.b.venn_enabled = true
    vim.cmd([[setlocal ve=all]])
    -- draw a line on HJKL keystokes
    vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
    vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
    vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
    vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
    -- draw a box by pressing "b" with visual selection
    vim.api.nvim_buf_set_keymap(0, "v", "b", ":VBox<CR>", { noremap = true })
  else
    vim.cmd([[setlocal ve=]])
    vim.cmd([[mapclear <buffer>]])
    vim.b.venn_enabled = nil
  end
end

-- toggle keymappings for venn using <leader>v
map("n", "<leader>v", ":lua Toggle_venn()<CR>", { noremap = true, desc = "Toggle Venn" })
-- }}}

return {
  -- Hop {{{1
  {
    "smoka7/hop.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      local hop = require("hop")
      hop.setup({ keys = "etovxqpdygfblzhckisuran" })
      vim.keymap.set({ "n", "v" }, "s", "<cmd>HopChar2AC<CR>", { noremap = false })
      vim.keymap.set(
        { "n", "v" },
        "<leader>ll",
        function() return hop.hint_lines({}) end,
        { silent = true, noremap = true, desc = "Hop to down line" }
      )
      vim.keymap.set(
        { "n", "v" },
        "<leader>ww",
        function() return hop.hint_words({}) end,
        { silent = true, noremap = true, desc = "Hop to up line" }
      )
      vim.keymap.set("n", "<leader>jw", "<cmd>HopWord<cr>", { desc = "Hop to word" })
      vim.keymap.set("n", "<leader>jl", "<cmd>HopLine<cr>", { desc = "Hop to line" })
    end,
  },
  -- }}}
  -- Marks {{{1
  {
    "chentoast/marks.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "MarksListBuf" },
    opts = {
      default_mappings = true,
      builtin_marks = { ".", "<", ">", "^" },
      cyclic = true,
      force_write_shada = false,
      refresh_interval = 250,
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      excluded_filetypes = { "nerdtree" },
      mappings = {},
    },
  },
  -- }}}
  -- Surround {{{1
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {
      indent_lines = false,
      surrounds = {
        ["f"] = {
          add = function() return { { "💥" }, { "💥" } } end,
        },
      },
    },
  },
  -- }}}
  -- Bookmarks {{{1
  {
    "tomasky/bookmarks.nvim",
    keys = { "mm", "mt", "ml", "mc" },
    config = function()
      local bm = require("bookmarks")
      local toggle = function()
        if vim.bo.filetype == "nerdtree" then return end
        bm.bookmark_toggle()
      end
      bm.setup({
        on_attach = function()
          map("n", "mt", toggle)
          map("n", "mi", bm.bookmark_ann)
          map("n", "mc", bm.bookmark_clean)
          map("n", "mn", bm.bookmark_next)
          map("n", "mp", bm.bookmark_prev)
          map("n", "ml", bm.bookmark_list)
        end,
      })
    end,
  },
  -- }}}
  -- Markdown, reStructuredText, textile {{{1
  {
    "yaocccc/nvim-hl-mdcodeblock.lua",
    enabled = false,
    after = "nvim-treesitter",
    config = function() require("hl-mdcodeblock").setup({}) end,
  },
  { "img-paste-devs/img-paste.vim", ft = "markdown" },
  -- }}}
  -- autopairs {{{1
  {
    "windwp/nvim-autopairs",
    enabled = true,
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      npairs.setup({
        map_cr = false,
        disable_in_visualblock = true,
        fast_wrap = {},
      })
      for _, i in ipairs(npairs.config.rules) do
        i.key_map = nil
      end
    end,
  },
  -- }}}
}
-- vim: set fdm=marker fdl=1:
