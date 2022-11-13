local M = {}

---setup nvim-dap for golang using
function M.setup()
  local cfg = require "gopher.dap.config"
  local u = require "gopher._utils"

  local dap = u.sreq "dap"
  dap.adapters.go = cfg.adapter
  dap.configurations.go = cfg.configuration
end

return M
