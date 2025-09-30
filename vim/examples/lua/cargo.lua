local metadata_json = vim.fn.system("cargo metadata --format-version 1 --no-deps")
local metadata = vim.fn.json_decode(metadata_json)
local target_dir = metadata.target_directory
put(target_dir, metadata.packages[1].targets)

-- local target_name = metadata.packages[1].targets[1].name
