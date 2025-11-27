local t = require "spec.testutils"
local _, T, utils = t.setup "utils"

utils["should .remove_empty_lines()"] = function()
  local u = require "gopher._utils"
  local inp = { "hi", "", "a", "", "", "asdf" }

  t.eq(u.remove_empty_lines(inp), { "hi", "a", "asdf" })
end

utils["should .readfile_joined()"] = function()
  local data = "line1\nline2\nline3"
  local tmp = t.tmpfile()
  local u = require "gopher._utils"

  t.writefile(tmp, data)
  t.eq(u.readfile_joined(tmp), data)
end

utils["should .trimend()"] = function()
  local u = require "gopher._utils"
  t.eq(u.trimend "  hi   ", "  hi")
end

utils["should add .indent() spaces"] = function()
  local u = require "gopher._utils"
  local line = "    func Test() error {"
  local indent = 4

  t.eq("    ", u.indent(line, indent))
end

utils["should add .indent() a tab"] = function()
  local u = require "gopher._utils"
  local line = "\tfunc Test() error {"
  local indent = 1

  t.eq("\t", u.indent(line, indent))
end

utils["should add .indent() 2 tabs"] = function()
  local u = require "gopher._utils"
  local line = "\t\tfunc Test() error {"
  local indent = 2

  t.eq("\t\t", u.indent(line, indent))
end

utils["should .list_unique on list with duplicates"] = function()
  local u = require "gopher._utils"
  t.eq({ "json", "xml" }, u.list_unique { "json", "xml", "json" })
end

utils["should .list_unique on list with no duplicates"] = function()
  local u = require "gopher._utils"
  t.eq({ "json", "xml" }, u.list_unique { "json", "xml" })
end

return T
