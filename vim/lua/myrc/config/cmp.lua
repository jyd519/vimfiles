-- Setup auto completion
local cmp = require('cmp')
local luasnip = require('luasnip')

-- Setup nvim-cmp {{{

-- Source Kind Icons {{{2
local kind_icons = {
	Text = "",
	Method = "m",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}
-- }}}

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
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
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-x><C-o>'] = cmp.mapping(function()
        cmp.complete()
      end, {'i', 's', 'c'}),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm{
      behavior = cmp.ConfirmBehavior.Replace,
      -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      select = false,
    },

    -- jump backward
    ['<C-h>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      elseif vim.call("UltiSnips#CanJumpBackwards") == 1 then
        vim.call("UltiSnips#JumpBackwards")
      else
        fallback()
      end
    end, {'i', 's'}),

    -- expand or jump forward
    ['<C-k>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif vim.call("UltiSnips#CanJumpForwards") == 1 then
        vim.call("UltiSnips#JumpForwards")
      else
        -- fallback()
      end
    end, {'i', 's'}),

    -- choose alternatives
    ['<C-l>'] = cmp.mapping(function(fallback)
      if luasnip.choice_active() then
        luasnip.change_choice(1)
      else
        fallback()
      end
    end, {'i', 's'}),

    -- select next item
    ['<C-n>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.choice_active() then
        luasnip.change_choice(-1)
      else
        fallback()
      end
    end, {'i', 's'}),

    -- choose with vim.ui.select
    ['<C-u>'] = cmp.mapping(function(fallback)
      if luasnip.choice_active() then
        require("luasnip.extras.select_choice")()
      else
        fallback()
      end
    end, {'i', 's'}),

    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			-- Kind icons
			vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
			-- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
			vim_item.menu = ({
				copilot = "[Copilot]",
				luasnip = "[LuaSnip]",
				cmp_tabnine = "[TN]",
				nvim_lua = "[NVim Lua]",
				nvim_lsp = "[LSP]",
				buffer = "[Buffer]",
				path = "[Path]",
			})[entry.source.name]
			return vim_item
		end,
	},
  sources = cmp.config.sources({
    { name = 'nvim_lua' },
    { name = 'nvim_lsp', max_item_count = 6 },
    { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
    { name = "path" },
    { name = "copilot" },
    { name = "crates" },
    { name = 'cmp_tabnine' },
  }, {
    { name = 'buffer', max_item_count = 6 },
  })
})

-- Set configuration for specific filetype {{{1
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  -- completion = { autocomplete = false },
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path', option = { trailing_slash = true } }
  }, {
    -- Do not show completion for words starting with 'Man'
    -- https://github.com/hrsh7th/cmp-cmdline/issues/47
    -- { name = 'cmdline', keyword_pattern = [[^\@<!Man\s]] }
    { name = 'cmdline' }
  })
})


-- Setup luasnip {{{1

-- Use existing vs-code style snippets from a plugin (eg. rafamadriz/friendly-snippets)
require("luasnip.loaders.from_vscode").lazy_load()

-- snipmate format
--    https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#from_snipmate
require("luasnip.loaders.from_snipmate").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load({paths = vim.fn.expand("$VIMFILES/mysnippets/snippets")})

-- luasnip format
---@diagnostic disable-next-line: missing-parameter
require("luasnip.loaders.from_lua").load({paths = vim.fn.expand("$VIMFILES/mysnippets/luasnippets")})

vim.api.nvim_create_user_command("ReloadSnippet", function(args)
  require("luasnip.loaders.from_snipmate").lazy_load({paths = vim.fn.expand("$VIMFILES/mysnippets/snippets")})
end, {nargs=0})

vim.api.nvim_create_user_command("EditSnippet", function(args)
  local typ = args.args;
  if typ == "" then
    typ = vim.bo.filetype
  end
  if typ == "" then
    typ  = "all"
  end
  local _, dot = string.find(typ, "%.")
  if dot ~= nil then
    typ = string.sub(typ, dot+1, -1)
  end
---@diagnostic disable-next-line: missing-parameter
  local snippet_file = vim.fn.expand("$VIMFILES/mysnippets/snippets/" .. typ .. ".snippets")
  if typ == "lua2" then
---@diagnostic disable-next-line: missing-parameter
    snippet_file = vim.fn.expand("$VIMFILES/mysnippets/luasnippets/all.lua")
  end
  vim.cmd("e " .. snippet_file)
end, {nargs="?"})

-- Virtual Text {{{2
local types = require("luasnip.util.types")
luasnip.config.set_config({
	-- history = true, --keep around last snippet local to jump back
	updateevents = "TextChanged,TextChangedI", --update changes as you type
	-- enable_autosnippets = true,
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
}) --}}}

-- Key Mapping --{{{2
vim.cmd([[autocmd BufEnter */mysnippets/luasnippets/*.lua nnoremap <silent> <buffer> <CR> /-- End SNIPPETS --<CR>kI<Esc>O]])

-- }}}
-- vim: set fdm=marker fen fdl=0: }}}
