local t = require "spec.testutils"
local _, T = t.setup "config"

T["config"]["can be called without any arguments passed"] = function()
  ---@diagnostic disable-next-line: missing-parameter
  require("gopher").setup()
end

T["config"]["can be called with empty table"] = function()
  require("gopher").setup {}
end

T["config"]["should change option"] = function()
  local log_level = 1234567890
  require("gopher").setup {
    log_level = log_level,
  }

  t.eq(log_level, require("gopher.config").log_level)
end

return T
