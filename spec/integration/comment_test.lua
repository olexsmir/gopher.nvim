local t = require "spec.testutils"
local child, T, comment = t.setup "comment"

local function do_the_test(fixture, pos)
  local rs = t.setup_test("comment/" .. fixture, child, pos)
  child.cmd "GoCmt"
  child.cmd "write"

  t.eq(t.readfile(rs.tmp), rs.fixtures.output)
  t.cleanup(rs)
end

comment["should add comment to package"] = function()
  do_the_test("package", { 1, 1 })
end

comment["should add comment to struct"] = function()
  do_the_test("struct", { 4, 1 })
end

comment["should add a comment on struct field"] = function()
  do_the_test("struct_fields", { 5, 8 })
end

comment["should add a comment on var struct field"] = function()
  do_the_test("var_struct_fields", { 6, 4 })
end

comment["should add a comment on one field of many structs"] = function()
  do_the_test("many_structs_fields", { 10, 4 })
end

comment["should add comment to function"] = function()
  do_the_test("func", { 3, 1 })
end

comment["should add comment to method"] = function()
  do_the_test("method", { 5, 1 })
end

comment["should add comment to interface"] = function()
  do_the_test("interface", { 3, 6 })
end

comment["should add comment on interface method"] = function()
  do_the_test("interface_method", { 4, 2 })
end

comment["should add a comment on interface with many method"] = function()
  do_the_test("interface_many_method", { 5, 2 })
end

comment["otherwise should add // above cursor"] = function()
  do_the_test("empty", { 1, 1 })
end

return T
