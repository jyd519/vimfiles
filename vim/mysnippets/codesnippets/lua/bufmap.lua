    local bufmap = function(mode, lhs, rhs, opts)
      local options = { buffer = true }
      if opts then
          options = vim.tbl_extend("force", options, opts)
      end
      vim.keymap.set(mode, lhs, rhs, options)
    end