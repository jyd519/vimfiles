local cmd = vim.api.nvim_create_user_command

-- Editing a protected file as 'sudo'
cmd("W", "w !sudo tee % > /dev/null", { bang = true })

-- Zoom / Restore window
cmd("ZoomToggle", function() vim.fn["misc#ZoomToggle"]() end, {})

-- Lookup ansible-doc
cmd("Adoc", function(args)
  vim.cmd(
    "new | setlocal buftype=nofile bufhidden=hide noswapfile ft=man sw=4 |" .. "r !ansible-doc " .. args.args .. ""
  )
  vim.defer_fn(function() vim.cmd('exec "norm ggM"') end, 100)
end, {
  nargs = "+",
  desc = "Lookup ansible document",
})

-- Toggle Dark-Mode
cmd("Dark", function(args)
  if vim.env.LC_TERMINAL ~= "iTerm2" then
    if vim.o.background == "light" then
      vim.o.background = "dark"
    else
      vim.o.background = "light"
    end
    return
  end
  --  Switch iTerm2 profile based on light/dark mode
  if vim.o.background == "light" then
    vim.o.background = "dark"
    vim.loop.fs_write(2, "\27Ptmux;\27\27]1337;SetProfile=Default-dark\7\27\\", -1)
  else
    vim.o.background = "light"
    vim.loop.fs_write(2, "\27Ptmux;\27\27]1337;SetProfile=Default\7\27\\", -1)
  end
end, {
  desc = "Toggle dark mode",
})

-- Make {{{2
cmd(
  "Make",
  function(opts) require("myrc.utils.term_run").gulp(opts.fargs) end,
  { nargs = "*", desc = "Run Build Tools" }
)
--}}}

-- Lsp formatting
cmd("Format", function() vim.lsp.buf.format({ async = true }) end, {
  desc = "Format the current buffer",
})

-- Toggle LSP Inlay-Hint
cmd("InlayHintToggle", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = vim.api.nvim_get_current_buf() }))
  if vim.lsp.inlay_hint.is_enabled() then
    vim.g.enable_inlay_hint = true
    vim.notify("Inlay hints disabled", vim.log.levels.INFO, { title = "LSP" })
  else
    vim.g.enable_inlay_hint = false
    vim.notify("Inlay hints enabled", vim.log.levels.INFO, { title = "LSP" })
  end
end, {
  desc = "Toggle LSP Inlay-Hint",
})
