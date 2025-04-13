local luasnip = require("luasnip")

-- Use existing vs-code style snippets from a plugin (eg. rafamadriz/friendly-snippets)
require("luasnip.loaders.from_vscode").lazy_load()

-- snipmate format
--    https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#from_snipmate
-- require("luasnip.loaders.from_snipmate").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load({ paths = vim.fn.expand("$VIMFILES/mysnippets/snippets") })

-- luasnip format
---@diagnostic disable-next-line: missing-parameter
-- require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.expand("$VIMFILES/mysnippets/luasnippets") })

luasnip.filetype_extend("all", { "_" })

-- Commands {{{2
vim.api.nvim_create_user_command(
  "ReloadSnippet",
  function()
    require("luasnip.loaders.from_snipmate").lazy_load({ paths = vim.fn.expand("$VIMFILES/mysnippets/snippets") })
  end,
  { nargs = 0 }
)

-- vim.api.nvim_create_user_command("EditLuaSnippet", function(args)
--   local typ = args.args
--   if typ == "" then typ = vim.bo.filetype end
--   if typ == "" then typ = "all" end
--   local _, dot = string.find(typ, "%.")
--   if dot ~= nil then typ = string.sub(typ, dot + 1, -1) end
--   local snippet_file = vim.fn.expand("$VIMFILES/mysnippets/luasnippets/" .. typ .. ".lua")
--   vim.cmd("e " .. snippet_file)
-- end, { nargs = "?" })

vim.api.nvim_create_user_command("EditSnippet", function(args)
  local typ = args.args
  if typ == "" then typ = vim.bo.filetype end
  if typ == "" then typ = "all" end
  local _, dot = string.find(typ, "%.")
  if dot ~= nil then typ = string.sub(typ, dot + 1, -1) end
  local snippet_file = vim.fn.expand("$VIMFILES/mysnippets/snippets/" .. typ .. ".snippets")
  vim.cmd("e " .. snippet_file)
end, { nargs = "?" })

-- }}}

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
-- vim.cmd(
--   [[autocmd BufEnter */mysnippets/luasnippets/*.lua nnoremap <silent> <buffer> <CR> /-- End SNIPPETS --<CR>kI<Esc>O]]
-- )

-- vim: set fdm=marker fdl=1: }}}
