-- My Neovim configuration
-- Jyd  Last-Modified: 2021-12-17
----------------------------------------------------------------------------------
local g, env, fn = vim.g, vim.env, vim.fn

local VIMFILES=fn.fnamemodify(fn.resolve(fn.expand('<sfile>:p', 0, 0)), ':h')

vim.cmd('set rtp^=' .. VIMFILES)
vim.cmd('set rtp+=' .. VIMFILES .. '/after')
vim.cmd('set packpath+=' .. VIMFILES)

g.VIMFILES, env.VIMFILES = VIMFILES, VIMFILES
env.MYVIMRC=VIMFILES .. '/init.lua'
g.did_load_filetypes=1
g.do_filetype_lua = 1

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

if fn.filereadable(fn.expand('~/.vimrc.local', 1, 0)) == 1 then
  vim.cmd('source ~/.vimrc.local')
end

-- load plugins
require('myrc.plugins')
if PACKER_BOOTSTRAP then
  print("plugins installed, you need restart vim to take effect.")
  vim.cmd('sleep 2')
  return
end

pcall(require, 'myrc.packer_compiled')

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
