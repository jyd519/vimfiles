let b:surround_{char2nr('-')} = "\"\"\" \r \"\"\""
let b:surround_{char2nr('d')} = "\"\"\" \r \"\"\""

if g:is_nvim
  lua  <<END
require("nvim-surround").buffer_setup(
    {
        surrounds = {
            ["-"] = {
                add = function()
                    return {{'"""'}, {'"""'}}
                end
            },
            ["d"] = {
                add = function()
                    return {{'"""'}, {'"""'}}
                end
            }
        }
    }
)
END
endif
