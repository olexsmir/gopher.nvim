local c = require("gopher.config").config.commands

local requried_for_work_msg = "Gopher.nvim will not work without it!"
local M = {
  _required = {
    plugins = {
      { lib = "plenary", help = requried_for_work_msg },
      { lib = "nvim-treesitter", help = requried_for_work_msg },
      { lib = "dap", help = "Required for set upping debugger" },
    },
    binarys = {
      { bin = c.go, help = "required for GoMod, GoGet, GoGenerate command" },
      { bin = c.gomodifytags, help = "required for modify struct tags" },
      { bin = c.impl, help = "required for interface implementing" },
      { bin = c.gotests, help = "required for test(s) generation" },
      { bin = c.dlv, help = "required for debugger(nvim-dap)" },
    },
  },
}

function M.check()
  local health = vim.health or require "health"
  local u = require "gopher._utils._health"

  health.report_start "Required plugins"
  for _, plugin in ipairs(M._required.plugins) do
    if u.lualib_is_found(plugin.lib) then
      health.report_ok(plugin.lib .. " installed.")
    else
      health.report_error(plugin.lib .. " not found. " .. plugin.help)
    end
  end

  health.report_start "Required go tools"
  for _, binary in ipairs(M._required.binarys) do
    if u.binary_is_found(binary.bin) then
      health.report_ok(binary.bin .. " installed")
    else
      health.report_warn(binary.bin .. " is not installed but " .. binary.help)
    end
  end
end

return M
