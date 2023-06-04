local M = {_setup = false, before_hooks = {}, after_hooks = {}}

local function get_source(name)
    return require("null-ls").get_source(name)[1]
end

---@param name string
---@param cb fun(params: table): boolean
M.patch = function(name, cb)
    local patch_source = function()
        local source = get_source(name)
        if source then
            source.generator.opts.runtime_condition = cb
            return true
        end
        return false
    end

    if patch_source() then
        return
    end

    M.patch_setup(
        function()
            patch_source()
        end,
        true
    )
end

---@param cb fun(user_config: table)
-- @param after boolean
M.patch_setup = function(cb, after_setup)
    if after_setup then
        table.insert(M.after_hooks, cb)
    else
        table.insert(M.before_hooks, cb)
    end

    if M._setup then
        return
    end

    local null_ls = require("null-ls")
    local origin_setup = null_ls.setup
    M._setup = true
    ---@diagnostic disable-next-line: duplicate-set-field
    null_ls.setup = function(user_config)
        for _, hook in ipairs(M.before_hooks) do
            hook(user_config)
        end
        origin_setup(user_config)
        for _, hook in ipairs(M.after_hooks) do
            hook(user_config)
        end
    end
end

return M
