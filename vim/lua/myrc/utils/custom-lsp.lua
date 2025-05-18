local M = {}

-- examples:
-- require("myrc.utils.custom-lsp").patch_lsp_settings("sumneko_lua", function(settings)
--   settings.Lua.diagnostics.globals = { "hs", "spoon" }
--
--   settings.Lua.workspace.library = {}
--
--   local hammerspoon_emmpylua_annotations = vim.fn.expand("~/.config/hammerspoon/Spoons/EmmyLua.spoon/annotations")
--   if vim.fn.isdirectory(hammerspoon_emmpylua_annotations) == 1 then
--     table.insert(settings.Lua.workspace.library, hammerspoon_emmpylua_annotations)
--   end
--
--   return settings
-- end)

---@param server_name string
---@param settings_patcher fun(settings: table): table | nil
function M.patch_settings(server_name, settings_patcher)
  local function patch_settings(client)
    local settings = settings_patcher(client.config.settings)
    if settings then
      client.config.settings = settings
    end
    client.notify("workspace/didChangeConfiguration", {
      settings = client.config.settings,
    })
  end

  local clients = vim.lsp.get_clients({ name = server_name })
  if #clients > 0 then
    patch_settings(clients[1])
    return
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("CustomLspConfig", {}),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client.name == server_name then
        patch_settings(client)
        return true
      end
    end,
  })
end

return M
