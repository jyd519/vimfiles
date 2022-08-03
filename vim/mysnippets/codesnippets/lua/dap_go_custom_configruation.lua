local t = dap.configurations.go
local rem_key = {}

for i, value in pairs(t) do
    if value.name == nil then
        table.insert(rem_key, 1, i)
    else
        if string.match(value.name, "Debug XXX") then
            table.insert(rem_key, 1, i)
        end
    end
end

for _, v in pairs(rem_key) do
    table.remove(t, v)
end

table.insert(
    dap.configurations.go,
    {
        name = "Debug XXX",
        program = "${file}",
        request = "launch",
        env = {DBHOST = "XXXXX"}, -- Set the environment variables for the command
        args = {"--BB", "CC"},
        type = "go"
    }
)