local t = require "spec.testutils"
local child, T = t.setup "comment"

local function do_the_test(fixture, pos)
  local rs = t.setup_test("comment/" .. fixture, child, pos)
  child.cmd "GoCmt"
  child.cmd "write"

  t.eq(t.readfile(rs.tmp), rs.fixtures.output)
  t.cleanup(rs)
end

T["comment"]["should add comment to package"] = function()
  do_the_test("package", { 1, 1 })
end

T["comment"]["should add comment to struct"] = function()
  do_the_test("struct", { 4, 1 })
end

T["comment"]["should add comment to function"] = function()
  do_the_test("func", { 3, 1 })
end

T["comment"]["should add comment to method"] = function()
  do_the_test("method", { 5, 1 })
end

T["comment"]["should add comment to interface"] = function()
  do_the_test("interface", { 3, 6 })
end

T["comment"]["otherwise should add // above cursor"] = function()
  do_the_test("empty", { 1, 1 })
end

return T
