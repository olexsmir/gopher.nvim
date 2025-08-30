local t = require "spec.testutils"
local child, T = t.setup "impl"

T["impl"]["should do impl with 'w io.Writer'"] = function()
  local rs = t.setup_test("impl/writer", child, { 3, 0 })
  child.cmd "GoImpl w io.Writer"
  child.cmd "write"

  -- NOTE: since "impl" won't implement interface if it's already implemented i went with this hack
  local rhs = rs.fixtures.output:gsub("Test2", "Test")
  t.eq(t.readfile(rs.tmp), rhs)
  t.cleanup(rs)
end

T["impl"]["should work with full input, 'r Read io.Reader'"] = function()
  local rs = t.setup_test("impl/reader", child)
  child.cmd "GoImpl r Read io.Reader"
  child.cmd "write"

  local rhs = rs.fixtures.output:gsub("Read2", "Read")
  t.eq(t.readfile(rs.tmp), rhs)
  t.cleanup(rs)
end

T["impl"]["should work with minimal input 'io.Closer'"] = function()
  local rs = t.setup_test("impl/closer", child, { 3, 6 })
  child.cmd "GoImpl io.Closer"
  child.cmd "write"

  local rhs = rs.fixtures.output:gsub("Test2", "Test")
  t.eq(t.readfile(rs.tmp), rhs)
  t.cleanup(rs)
end

return T
