local options = {noremap = true}
put(vim.tbl_extend('force', options, {noremap = false, buffer = true}))


local options = {noremap = true}
put(vim.tbl_extend('keep', options, {noremap = false}))

-- real example
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}

  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
