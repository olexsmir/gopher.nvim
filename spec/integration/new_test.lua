local t = require "spec.testutils"
local child, T, new = t.setup "new"

---@param fixture string
---@param pos number[]
local function do_the_test(fixture, pos)
  local rs = t.setup_test("new/" .. fixture, child, pos)
  child.cmd "GoNew"
  child.cmd "write"

  t.eq(t.readfile(rs.tmp), rs.fixtures.output)
  t.cleanup(rs)
end

new["should generate constructor"] = function()
  do_the_test("new", { 5, 6 })
end

new["should generate constructor for generic struct"] = function()
  do_the_test("generic", { 5, 7 })
end

new["should ignore embedded fields in constructor params"] = function()
  do_the_test("embedded", { 8, 7 })
end

new["should generate constructor for empty struct"] = function()
  do_the_test("empty", { 3, 7 })
end

new["should not generate constructor for var struct"] = function()
  do_the_test("var_struct", { 3, 8 })
end

return T
