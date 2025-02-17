local t = require "spec.testutils"

local T = MiniTest.new_set {}
T["struct_tags"] = MiniTest.new_set {}
T["struct_tags"]["fuck it"] = function()
  t.eq(1, 1)
end

return T
