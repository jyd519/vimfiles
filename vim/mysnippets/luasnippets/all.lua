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
-- examples
ss(parse({trig = "lspc"}, "$1 is ${2|hard,easy,challenging|}"))

-- add vim modeline
ss(s("modeline", t("vim:set et sw=2 ts=2:")))
ss(s("modl", t("vim:set et sw=2 ts=2:")))

-- End SNIPPETS --
--
return snippets
