-- My Neovim configuration
-- Jyd  Last-Modified: 2021-12-17
--
-- let g:loaded_python_provider = 0
-- let g:python_host_prog = expand('~/.pyenv/versions/2.7.18/bin/python2')
-- let g:python3_host_prog = expand('~/.pyenv/versions/3.10.2/bin/python3.10')
-- let g:node_host_prog = '/usr/local/bin/neovim-node-host'
-- let g:copilot_node_command=expand('~/.nvm/versions/node/v16.10.0/bin/node')
--
-- let g:use_heavy_plugin = 1
-- let g:use_treesitter = 1
--
-- let g:test#javascript#runner = 'jest'
--
-- set background="light"
-- let g:colorscheme='vscode'
-- let g:notes_dir = '/Volumes/dev/notes'
--
-- source path/to/init.lua
----------------------------------------------------------------------------------
local g, env, fn = vim.g, vim.env, vim.fn
local VIMFILES=fn.fnamemodify(fn.resolve(fn.expand('<sfile>:p')), ':h')

vim.cmd('set rtp^=' .. VIMFILES)
vim.cmd('set rtp+=' .. VIMFILES .. '/after')
vim.cmd('set packpath+=' .. VIMFILES)

g.VIMFILES, env.VIMFILES = VIMFILES, VIMFILES
g.MYINITRC=VIMFILES .. '/init.lua'
g.did_load_filetypes=1
g.do_filetype_lua = 1
env.MYSNIPPETS = VIMFILES .. '/mysnippets'
g.mapleader = ","
g.maplocalleader = ","

local function prequire(m)
  local ok, err = pcall(require, m)
  if not ok then return nil, err end
  return err
end
_G.prequire = prequire

function _G.put(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
end
_G.dump = _G.put

prequire('impatient')

-- load plugins
require('myrc.plugins')
if PACKER_BOOTSTRAP then
  print("plugins installed, you need restart vim to take effect.")
  vim.cmd('sleep 2')
  return
end

prequire('myrc.packer_compiled')

-- load options
local scripts = {'config/globals.vim',
                 'config/options.vim',
                 'config/mappings.vim',
                 'config/plugins/shared.vim',
                 'lua/myrc/config/common.lua',
               }
for _, s in pairs(scripts) do
  vim.cmd('source ' .. VIMFILES .. '/' .. s)
end

-- colorscheme
if g.colorscheme == nil then
  g.colorscheme = 'vscode'
end
vim.cmd('colorscheme ' .. g.colorscheme)
