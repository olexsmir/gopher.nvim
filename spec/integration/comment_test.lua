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
T["comment"] = MiniTest.new_set {}

T["comment"]["should add comment to package"] = function()
  MiniTest.skip "come back daddy"
end

T["comment"]["should add comment to struct"] = function()
  MiniTest.skip "come back daddy"
end

T["comment"]["should add comment to function"] = function()
  MiniTest.skip "come back daddy"
end

T["comment"]["should add comment to method"] = function()
  MiniTest.skip "come back daddy"
end

T["comment"]["should add comment to interface"] = function()
  MiniTest.skip "come back daddy"
end

T["comment"]["otherwise should add // above cursor"] = function()
  MiniTest.skip "come back daddy"
end

return T
