local c = require("gopher.config").config.commands
local h = vim.health or require "health"
local health = {}

local function is_lualib_found(lib)
  local is_found, _ = pcall(require, lib)
  return is_found
end

local function is_bin_found(bin)
  if vim.fn.executable(bin) == 1 then
    return true
  end
  return false
end

local lua_deps = {
  { lib = "plenary", msg = "Required for running commands" },
  { lib = "nvim-treesitter", msg = "For getting data from AST" },
  { lib = "dap", msg = "Uses only for configuring DAP(gopher.dap)" },
}

local bin_deps = {
  { bin = c.go, msg = "uses by :GoMod, :GoGet, :GoGenerate" },
  { bin = c.gomodifytags, msg = "uses by :GoTagAdd, :GoTagRm" },
  { bin = c.impl, msg = "uses by :GoImpl" },
  { bin = c.gotests, msg = "uses by :GoTestAdd, :GoTestsAll, :GoTestsExp" },
  { bin = c.dlv, msg = "uses by debugger" },
  { bin = c.iferr, msg = "uses to generate `if err` blocks" },
}

function health.check()
  h.report_start "Checking for Lua deps"
  for _, lib in ipairs(lua_deps) do
    if is_lualib_found(lib.lib) then
      h.report_ok(lib.lib .. " is installed")
    else
      h.report_error(lib.lib .. " is not found but " .. lib.msg)
    end
  end

  h.report_start "Checking for external deps"
  for _, bin in ipairs(bin_deps) do
    if is_bin_found(bin.bin) then
      h.report_ok(bin.bin .. " is installed")
    else
      h.report_warn(bin.bin .. " is not found but " .. bin.msg)
    end
  end
end

return health
