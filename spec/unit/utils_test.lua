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

return T
