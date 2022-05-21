-- My Neovim configuration
-- Jyd  Last-Modified: 2021-12-17
----------------------------------------------------------------------------------
local g, env, fn = vim.g, vim.env, vim.fn

local VIMFILES=fn.fnamemodify(fn.resolve(fn.expand('<sfile>:p')), ':h')

vim.cmd('set rtp^=' .. VIMFILES)
vim.cmd('set rtp+=' .. VIMFILES .. '/after')
vim.cmd('set packpath+=' .. VIMFILES)

g.VIMFILES, env.VIMFILES = VIMFILES, VIMFILES
env.MYVIMRC=VIMFILES .. '/init.lua'
g.did_load_filetypes=1

if fn.filereadable(fn.expand('~/.vimrc.local')) == 1 then
  vim.cmd('source ~/.vimrc.local')
end

-- load plugins
require('myrc.plugins')
require('myrc.packer_compiled')

-- load options
local scripts = {'config/globals.vim',
                 'config/options.vim',
                 'config/mappings.vim',
                 'config/plugins/shared.vim',
                 'lua/myrc/plugins_config.lua',
               }
for _, s in pairs(scripts) do
  vim.cmd('source ' .. VIMFILES .. '/' .. s)
end

-- colorscheme
if g.colorscheme == nil then
  g.colorscheme = 'vscode'
end
vim.cmd('colorscheme ' .. g.colorscheme)
-- vim.cmd([[colorscheme PaperColor]])
