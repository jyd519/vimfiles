local g = vim.g
local env = vim.env
local fn = vim.fn

local VIMFILES=fn.fnamemodify(fn.resolve(fn.expand('<sfile>:p')), ':h')

g.VIMFILES=VIMFILES
env.VIMFILES=VIMFILES
env.MYVIMRC=VIMFILES .. '/init.lua'

vim.cmd('set rtp^=' .. VIMFILES)
vim.cmd('set rtp+=' .. VIMFILES .. '/after')
vim.cmd('set packpath+=' .. VIMFILES)

g.mysnippets_dir=VIMFILES .. '/mysnippets'
g.did_load_filetypes=1

if fn.filereadable('~/.vimrc.local') == 0 then
  vim.cmd('source ~/.vimrc.local')
end

-- load plugins
require('myrc.plugins')
require('myrc.packer_compiled')

-- load options
local scripts = {'config/globals.vim',
                 'config/options.vim',
                 'config/mappings.vim',
               }
for _, s in pairs(scripts) do
  vim.cmd('source ' .. VIMFILES .. '/' .. s)
end

-- colorscheme
vim.cmd([[colorscheme vscode]])
