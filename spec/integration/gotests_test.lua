local t = require "spec.testutils"

local child = MiniTest.new_child_neovim()
local T = MiniTest.new_set {
  hooks = {
    post_once = child.stop,
    pre_case = function()
      child.restart { "-u", t.mininit_path }
    end,
  },
}
T["gotests"] = MiniTest.new_set {}

--- NOTE: :GoTestAdd is the only place that has actual logic
--- All other parts are handled `gotests` tool itself.

T["gotests"]["should add test for function under cursor"] = function()
  MiniTest.skip "come back daddy"
end

T["gotests"]["should add test for method under cursor"] = function()
  MiniTest.skip "come back daddy"
end

return T
