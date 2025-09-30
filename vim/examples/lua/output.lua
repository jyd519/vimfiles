put(">>", vim.api.nvim_exec("echom 'xxxx'", true))
put(">>", vim.api.nvim_command_output("set ft?"))

local scripts = vim.api.nvim_exec("scriptnames", true)
local tab = vim.split(scripts, "\n")
for key, value in pairs(tab) do
    print(key, value)
    do
        return
    end
end

local function prepare_output_table()
    local lines = {}
    local scripts = vim.api.nvim_command_output("scriptnames")
    for script in scripts:gmatch("[\r\n]+") do
        table.insert(lines, script)
    end
    return lines
end

put(prepare_output_table())
