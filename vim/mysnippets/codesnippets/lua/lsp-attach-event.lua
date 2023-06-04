    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("CustomLspConfig", {}),
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client.name == "null-ls" then
              print("nullls: LspAttach")
            end
        end
      }
    )