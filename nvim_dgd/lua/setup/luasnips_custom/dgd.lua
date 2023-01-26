print('hello again from dgd.lua')

local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("all", {
    -- ls.parser.parse_snippet("expand", "--This was just expanded"),
    s("trig", { t("Wow! Text!") }),
    s("foo", {
        t("-- This is a sexy snippet with: "),
        c(1, { t("choice 1"), t("choice 2") }),
        t(" "),
        i(0),
    }),
})

ls.add_snippets("lua", {
    -- ls.parser.parse_snippet("expand", "--This was just expanded"),
    s("trigger", { t("Trigger! Text!") }),
  }
)

-- This is a sexy snippet with: choice 1 adfadfqsdf
