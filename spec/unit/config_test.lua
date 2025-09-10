local t = require "spec.testutils"
local _, T, config = t.setup "config"

config["can be called without any arguments passed"] = function()
  ---@diagnostic disable-next-line: missing-parameter
  require("gopher").setup()
end

config["can be called with empty table"] = function()
  ---@diagnostic disable-next-line: missing-fields
  require("gopher").setup {}
end

config["should change option"] = function()
  local log_level = 1234567890

  ---@diagnostic disable-next-line: missing-fields
  require("gopher").setup {
    log_level = log_level,
  }

  t.eq(log_level, require("gopher.config").log_level)
end

return T
