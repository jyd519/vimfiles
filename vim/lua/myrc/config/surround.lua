require("nvim-surround").setup(
    {
        surrounds = {
            ["f"] = {
                add = function()
                    return {{"💥"}, {"💥"}}
                end
            }
        }
    }
)
