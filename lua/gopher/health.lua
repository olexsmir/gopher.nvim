local utils = require "gopher._utils"
local M = {
  _required = {
    plugins = {
      { lib = "plenary" },
      { lib = "nvim-treesitter" },
    },
    binarys = {
      { bin = "go", help = "required for GoMod command" },
      { bin = "gomodifytags", help = "required for modify struct tags" },
    },
  },
}

function M.check()
  vim.health.report_start "Required plugins"
  for _, plugin in ipairs(M._required.plugins) do
    if utils.lualib_is_found(plugin.lib) then
      vim.health.report_ok(plugin.lib .. " installed.")
    else
      vim.health.report_error(plugin.lib .. " not found. Gopher.nvim will not work without it!")
    end
  end

  vim.health.report_start "Required go tools"
  for _, binary in ipairs(M._required.binarys) do
    if utils.binary_is_found(binary.bin) then
      vim.health.report_ok(binary.bin .. " installed")
    else
      vim.health.report_warn(binary.bin .. " is not installed but " .. binary.help)
    end
  end
end

return M
