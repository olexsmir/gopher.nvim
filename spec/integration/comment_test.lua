local t = require "spec.testutils"

local child = MiniTest.new_child_neovim()
local T = MiniTest.new_set {
  hooks = {
    post_once = child.stop,
    pre_case = function()
      MiniTest.skip "This module should be fixed first"
      child.restart { "-u", t.mininit_path }
    end,
  },
}
T["comment"] = MiniTest.new_set {}

T["comment"]["should add comment to package"] = function() end

T["comment"]["should add comment to struct"] = function() end

T["comment"]["should add comment to function"] = function() end

T["comment"]["should add comment to method"] = function() end

T["comment"]["should add comment to interface"] = function() end

T["comment"]["otherwise should add // above cursor"] = function() end

return T
