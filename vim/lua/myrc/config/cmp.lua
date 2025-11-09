-- Setup auto completion
local cmp = require("cmp")
local luasnip = require("luasnip")

-- Setup nvim-cmp {{{
-- Source Kind Icons {{{2
local kind_icons = {
  Text = "",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰇽",
  Variable = "󰆧",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰰥",
}
-- }}}
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local is_insert_keys = function(keys)
  if type(keys) == "string" and not (keys == "" or keys == "\\<C-N>" or keys == "\t") then return true end
  return false
end

cmp.setup({
  -- REQUIRED - you must specify a snippet engine
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-x><C-o>"] = cmp.mapping(function() cmp.complete() end, { "i", "s", "c" }),
    ["<C-e>"] = cmp.mapping(function()
      cmp.abort()
      luasnip.unlink_current()
    end, { "i" }),
    ["<Esc>"] = cmp.mapping(function(fallback)
      luasnip.unlink_current()
      fallback()
    end, { "i" }),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),

    -- jump backward
    ["<C-h>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),

    -- expand or jump forward
    ["<C-k>"] = cmp.mapping(function(fallback)
      local codeium_keys = vim.fn["codeium#Accept"]()
      -- vim.fn['copilot#Accept']()
      if luasnip.jumpable() then
        luasnip.expand_or_jump()
      elseif is_insert_keys(codeium_keys) then
        vim.api.nvim_feedkeys(codeium_keys, "i", true)
      elseif cmp.confirm({ select = true }) then
        --
      elseif luasnip.expandable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    -- select previous item
    ["<C-p>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.choice_active() then
        luasnip.change_choice(-1)
      elseif vim.b._codeium_status > 0 then
        vim.fn["codeium#CycleCompletions"](1)
      elseif vim.b._copilot then
        vim.call("copilot#Previous")
      else
        fallback()
      end
    end, { "i", "s" }),

    -- select next item
    ["<C-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.choice_active() then
        luasnip.change_choice(1)
      elseif vim.b._codeium_status > 0 then
        vim.fn["codeium#CycleCompletions"](-1)
      elseif vim.b._copilot then
        vim.call("copilot#Next")
      else
        fallback()
      end
    end, { "i", "s" }),

    -- choose alternatives
    ["<C-l>"] = cmp.mapping(function(fallback)
      if luasnip.choice_active() then
        luasnip.change_choice(-1)
      else
        fallback()
      end
    end, { "i", "s" }),

    -- choose with vim.ui.select
    ["<C-u>"] = cmp.mapping(function(fallback)
      if luasnip.choice_active() then
        require("luasnip.extras.select_choice")()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      local codeium_keys = vim.fn["codeium#Accept"]()
      -- vim.fn['copilot#Accept']()
      if luasnip.jumpable() then
        luasnip.expand_or_jump()
      elseif is_insert_keys(codeium_keys) then
        vim.api.nvim_feedkeys(codeium_keys, "i", true)
      elseif cmp.confirm({ select = true }) then
        --
      elseif luasnip.expandable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end

      -- -- local copilot_keys = vim.fn['copilot#Accept']()
      -- if cmp.visible() then
      --   cmp.select_next_item()
      -- elseif luasnip.expand_or_locally_jumpable() then
      --   luasnip.expand_or_jump()
      -- -- elseif copilot_keys ~= '' and type(copilot_keys) == 'string' then
      -- --   vim.api.nvim_feedkeys(copilot_keys, 'i', true)
      -- elseif has_words_before() then
      --   cmp.complete()
      -- else
      --   fallback()
      -- end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
      -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      vim_item.menu = ({
        copilot = "[Copilot]",
        luasnip = "[Snippet]",
        cmp_tabnine = "[TN]",
        codeium = "[Codeium]",
        nvim_lua = "[NVim Lua]",
        nvim_lsp = "[LSP]",
        buffer = "[Buffer]",
        path = "[Path]",
        go_pkgs = "[pkgs]",
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lua" },
    { name = "nvim_lsp", max_item_count = 20 },
    { name = "luasnip" }, -- For luasnip users.
    { name = "path" },
    { name = "codeium" },
    -- { name = "copilot" },
    -- { name = 'cmp_tabnine' },
    { name = "crates" },
  }, {
    { name = "buffer" },
    { name = "emoji" },
    { name = "go_pkgs" },
  }),
  matching = { disallow_symbol_nonprefix_matching = false }, -- to use . and / in urls
})

-- Set configuration for specific filetype {{{1
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    {
      name = "buffer",
      options = {
        -- https://github.com/hrsh7th/cmp-buffer#indexing-and-how-to-optimize-it
        get_bufnrs = function()
          if vim.b.large_buf then return {} end
          local buf = vim.api.nvim_get_current_buf()
          local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
          if byte_size > 2 * 1024 * 1024 then -- 2 Megabyte max
            return {}
          end
          return { buf }
        end,
      },
    },
  }),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    {
      name = "buffer",
      options = {
        -- https://github.com/hrsh7th/cmp-buffer#indexing-and-how-to-optimize-it
        get_bufnrs = function()
          if vim.b.large_buf then return {} end
          local buf = vim.api.nvim_get_current_buf()
          local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
          if byte_size > 2 * 1024 * 1024 then -- 2 Megabyte max
            return {}
          end
          return { buf }
        end,
      },
    },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  -- completion = { autocomplete = false },
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path", options = { label_trailing_slash = false } },
  }, {
    -- Do not show completion for words starting with 'Man'
    { name = "cmdline", option = {
      ignore_cmds = { "Man", "!" },
    } },
  }),
})

cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
  sources = {
    { name = "dap" },
  },
})
-- default lsp config {{{2
local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("*", {
  capabilities = capabilities
})
-- }}}
-- }}}
-- vim: set fdm=marker fdl=0: }}}
