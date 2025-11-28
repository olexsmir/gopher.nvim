local t = require "spec.testutils"
local child, T, json2go = t.setup "json2go"

json2go["should convert interativly"] = function()
  local rs = t.setup_test("json2go/interativly", child, { 2, 0 })
  child.cmd "GoJson"
  child.type_keys [[{"json": true}]]
  child.type_keys "<Esc>"
  child.cmd "wq" -- quit prompt
  child.cmd "write" -- the fixture file

  t.eq(t.readfile(rs.tmp), rs.fixtures.output)
  t.cleanup(rs)
end

json2go["should convert argument"] = function()
end

return T
