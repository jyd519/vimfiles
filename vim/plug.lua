-- My Neovim configuration
-- Jyd  Last-Modified: 2023-01-08
-- ~/.config/nvim/init.vim
-- let g:loaded_perl_provider = 0
-- let g:loaded_ruby_provider = 0
-- let g:loaded_python3_provider = 1
-- let g:loaded_node_provider = 1
-- let g:python3_host_prog = expand('~/.pyenv/versions/3.10.2/bin/python3.10')
-- let g:node_host_prog = '/usr/local/bin/neovim-node-host'
-- let g:node_path = expand('~/.nvm/versions/node/v16.10.0/bin/node')
-- let g:copilot_node_command=g:node_path
-- let g:notes_dir = '/Volumes/dev/notes'
--
-- let g:enabled_plugins = {}
--
-- source path/to/plug.lua
--
-- set background=light
-- colorscheme vscode
----------------------------------------------------------------------------------
local g, env, fn = vim.g, vim.env, vim.fn
local VIMFILES=fn.fnamemodify(fn.resolve(fn.expand('<sfile>:p')), ':h')

vim.cmd('set rtp^=' .. VIMFILES)
vim.cmd('set rtp+=' .. VIMFILES .. '/after')

g.VIMFILES, env.VIMFILES = VIMFILES, VIMFILES
g.myinitrc=VIMFILES .. '/plug.lua'

-- load global variables
vim.cmd('runtime config/globals.vim')

-- load plugins
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
