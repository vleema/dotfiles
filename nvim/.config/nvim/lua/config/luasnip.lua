local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("markdown", {
  s("obhead", {
    t({
      "---",
      "id: ",
      "aliases: []",
      "tags: []",
      "---",
    }),
  }),
  s("ttt", {
    t("\\texttt{"),
    i(1), -- Cursor lands here
    t("}"),
  }),
})

ls.add_snippets("cpp", {
  s("cmain", {
    t({ "#include <bits/stdc++.h>", "", "using namespace std;", "", "int main() {", "\t" }),
    i(1, "//"),
    t({ "", "\treturn 0;", "}" }),
  }),
})
