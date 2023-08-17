---@diagnostic disable: undefined-global
-- vim: set ft=lua:
-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
local snippets = {}

local function ss(...)
  for _, v in pairs({ ... }) do
    table.insert(snippets, v)
  end
end

--
--
-- Begin SNIPPETS --
-- examples
ss(parse({ trig = "lspc" }, "$1 is ${2|hard,easy,challenging|}"))
ss(s(
  "trig",
  c(1, {
    t("Ugh boring, a text node"),
    i(nil, "At least I can edit something now..."),
    f(function(args)
      return "Still only counts as text!!"
    end, {}),
  })
))

-- add vim modeline
ss(s("modeline", t("vim:set et sw=2 ts=2:")))

ss(
  postfix(".br", {
    f(function(_, parent)
      return "[" .. parent.snippet.env.POSTFIX_MATCH .. "]"
    end, {}),
  })
  -- , s("trig", { i(1), t("text"), i(2), t("text again"), i(3) })
  -- ,s("example1", fmt("just an {iNode1}", {
  --   iNode1 = i(1, "example")
  -- }))
)

-- ss(s("trigger", {
--   -- 两行
--   t({ "Wow! Text!", "And another line." }),
-- }))

-- ss(s("trig", {
--   t("text: "),
--   i(1),
--   t({ "", "copy: " }),
--   d(2, function(args)
--     -- the returned snippetNode doesn't need a position; it's inserted
--     -- "inside" the dynamicNode.
--     return sn(nil, {
--       -- jump-indices are local to each snippetNode, so restart at 1.
--       i(1, args[1]),
--     })
--   end, { 1 }),
-- })
-- )

ss(s("paren_change", {
  c(1, {
    sn(nil, { t("("), r(1, "user_text"), t(")") }),
    sn(nil, { t("["), r(1, "user_text"), t("]") }),
    sn(nil, { t("{"), r(1, "user_text"), t("}") }),
  }),
}, {
  stored = {
    -- key passed to restoreNodes.
    ["user_text"] = i(1, "default_text"),
  },
}))

-- End SNIPPETS --
--
return snippets
