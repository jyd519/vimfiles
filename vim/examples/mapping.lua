local map = function(key)
  -- get the extra options
  local opts = {noremap = true}
  for i, v in pairs(key) do
    if type(i) == 'string' then opts[i] = v end
  end

  -- basic support for buffer-scoped keybindings
  local buffer = opts.buffer
  opts.buffer = nil

  if buffer then
    vim.api.nvim_buf_set_keymap(0, key[1], key[2], key[3], opts)
  else
    vim.api.nvim_set_keymap(key[1], key[2], key[3], opts)
  end
end

local function map2(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map {'n', '<Leader>w', ':write<CR>'}
map {noremap = false, 'n', '<Leader>e', '%'}

--[[
 -- 1) `vim.keymap.set` is a wrapper around `nvim_set_keymap`
 -- 2) The advantage of `vim.keymap.set` over `vim.api.nvim_set_keymap` is that it allows directly calling lua functions
 -- 3) vim.keymap.set supports buffer scoped mapping
 --
vim.keymap.set({mode}, {lhs}, {rhs}, {options})
vim.api.nvim_set_keymap({mode}, {lhs}, {rhs}, {options}) 
]]

-- vim.keymap.set('n', '<leader>w', ':w<CR>',{noremap = true})
vim.keymap.set('n', 'Y', 'yy', {noremap = false})

vim.keymap.set('n', '<leader>h', function ()
  print("hello, vim.keymap is awesome!")
end, { noremap=true })

vim.keymap.del('n', ',x')
-- not work:
--   vim.keymap.set('n', ',x', ',h')
-- which is same as
--   vim.keymap.set('n', ',x', ',h', { remap=false })
--
-- keymap使用remap参数(缺省false)
vim.keymap.set('n', ',x', ',h', { remap = true})
--
-- not work
-- vim.keymap.set('n', ',x', ',h', { noremap = false })

map2('n', '<leader>w', ':w<CR>', {buffer= true})
map2('n', '<leader>q', ':q!<CR>')
-- map2('n', '<leader>s', ':so %<CR>')

-- https://www.scien.cx/2021/08/02/everything-you-need-to-know-to-configure-neovim-using-lua/
