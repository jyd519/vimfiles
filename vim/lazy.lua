-- My Neovim configuration
-- Jyd  Last-Modified: 2023-08-07
----------------------------------------------------------------------------------
local g, env, fn = vim.g, vim.env, vim.fn

-- local VIMFILES=fn.fnamemodify(fn.resolve(fn.expand('<sfile>:p')), ':h')
local VIMFILES=fn.expand('<sfile>:p:h')

vim.opt.rtp:prepend(VIMFILES)
vim.opt.rtp:append(VIMFILES .. '/after')

g.VIMFILES, env.VIMFILES = VIMFILES, VIMFILES
g.myinitrc=VIMFILES .. '/lazy.lua'

if env.DARK ~= nil then
  vim.o.background = env.DARK == "1" and "dark" or "light"
end

vim.loader.enable()

-- load global variables
vim.cmd('runtime config/globals.vim')

require('myrc.lazy') -- load plugins
require('myrc.mapping')

-- load options, mappings and configurations
local scripts = {'config/options.vim',
                 'config/mappings.vim',
                 'config/plugins/shared.vim', -- plugins dependent
                 'lua/myrc/config/common.lua',
               }
for _, s in pairs(scripts) do
  vim.cmd('runtime ' .. s)
end
