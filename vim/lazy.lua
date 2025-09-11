-- My Neovim configuration
----------------------------------------------------------------------------------
local g, env, fn = vim.g, vim.env, vim.fn

-- local VIMFILES=fn.fnamemodify(fn.resolve(fn.expand('<sfile>:p')), ':h')
local VIMFILES=fn.expand('<sfile>:p:h')

vim.opt.rtp:prepend(VIMFILES)
vim.opt.rtp:append(VIMFILES .. '/after')

g.VIMFILES, env.VIMFILES = VIMFILES, VIMFILES
g.myinitrc=VIMFILES .. '/lazy.lua'
g.mysnippets_dir=VIMFILES .. '/mysnippets/codesnippets'

if env.DARK ~= nil then
  vim.o.background = env.DARK == "1" and "dark" or "light"
end

vim.loader.enable()

-- load global variables
vim.cmd('runtime config/globals.vim')

if vim.g.vscode then
   vim.g.did_load_filetypes = 1
   require("myrc.vscode.plugins")
   require("myrc.vscode.setting")
else
  require('myrc.options')
  require('myrc.lazy')
  require('myrc.keymaps')
  require('myrc.autocmds')
end

