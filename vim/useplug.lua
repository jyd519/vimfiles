-- My Neovim configuration
-- Jyd  Last-Modified: 2023-01-08
--
-- let g:loaded_python_provider = 0
-- let g:python_host_prog = expand('~/.pyenv/versions/2.7.18/bin/python2')
-- let g:python3_host_prog = expand('~/.pyenv/versions/3.10.2/bin/python3.10')
-- let g:node_host_prog = '/usr/local/bin/neovim-node-host'
-- let g:copilot_node_command=expand('~/.nvm/versions/node/v16.10.0/bin/node')
--
-- let g:test#javascript#runner = 'jest'
--
-- set background="light"
-- let g:colorscheme='vscode'
-- let g:notes_dir = '/Volumes/dev/notes'
-- let g:enabled_plugins = {}
--
-- source path/to/plug.lua
----------------------------------------------------------------------------------
local g, env, fn = vim.g, vim.env, vim.fn
local VIMFILES=fn.fnamemodify(fn.resolve(fn.expand('<sfile>:p')), ':h')

vim.cmd('set rtp^=' .. VIMFILES)
vim.cmd('set rtp+=' .. VIMFILES .. '/after')

g.VIMFILES, env.VIMFILES = VIMFILES, VIMFILES
g.MYINITRC=VIMFILES .. '/plug.lua'

-- load global variables
vim.cmd('runtime config/globals.vim')

-- load plugins
prequire('impatient')
require('myrc.plug')

-- load options, mappings and configurations
local scripts = {'config/options.vim',
                 'config/mappings.vim',
                 'config/plugins/shared.vim',
                 'lua/myrc/config/common.lua',
               }
for _, s in pairs(scripts) do
  vim.cmd('runtime ' .. s)
end

-- colorscheme
if g.colorscheme == nil then
  g.colorscheme = 'vscode'
end
vim.cmd('colorscheme ' .. g.colorscheme)
