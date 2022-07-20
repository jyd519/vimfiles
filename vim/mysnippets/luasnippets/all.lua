 -- vim: set ft=lua:
 -- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
local snippets = {}

local function ss(...)
  for _, v in pairs({...}) do
    table.insert(snippets, v)
  end
end

--
--
-- Begin SNIPPETS --

ss(parse({trig = "lsp"}, "$1 is ${2|hard,easy,challenging|}"))

ss(s("aaa", t("hello aaaa")))

-- End SNIPPETS --
--
return snippets
