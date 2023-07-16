local health = {}
local cmd = require("gopher.config").config.commands
local u = require "gopher._utils._health"

local _h = vim.health or require "health"
local start = _h.start or _h.report_start
local ok = _h.ok or _h.report_ok
local warn = _h.warn or _h.report_warn
local error = _h.error or _h.report_error
local info = _h.info or _h.report_info

local deps = {
  plugin = {
    { lib = "dap", msg = "required for `gopher.dap`", optional = true },
    { lib = "plenary", msg = "required for everyting in gopher.nvim", optional = false },
    { lib = "nvim-treesitter", msg = "required for everyting in gopher.nvim", optional = false },
  },
  bin = {
    {
      bin = cmd.go,
      msg = "required for :GoGet, :GoMod, :GoGenerate, :GoWork, :GoInstallDeps",
      optional = false,
    },
    { bin = cmd.gomodifytags, msg = "required for :GoTagAdd, :GoTagRm", optional = false },
    { bin = cmd.impl, msg = "required for :GoImpl", optional = false },
    { bin = cmd.iferr, msg = "required for :GoIfErr", optional = false },
    {
      bin = cmd.gotests,
      msg = "required for :GoTestAdd, :GoTestsAll, :GoTestsExp",
      optional = false,
    },
    { bin = cmd.dlv, msg = "required for debugging, (nvim-dap, `gopher.dap`)", optional = true },
  },
}

function health.check()
  start "required plugins"
  for _, plugin in ipairs(deps.plugin) do
    if u.lualib_is_found(plugin.lib) then
      ok(plugin.lib .. " installed")
    else
      if plugin.optional then
        warn(plugin.lib .. " not found, " .. plugin.msg)
      else
        error(plugin.lib .. " not found, " .. plugin.msg)
      end
    end
  end

  start "required binaries"
  info "all those binaries can be installed by `:GoInstallDeps`"
  for _, bin in ipairs(deps.bin) do
    if u.binary_is_found(bin.bin) then
      ok(bin.bin .. " installed")
    else
      if bin.optional then
        warn(bin.bin .. " not found, " .. bin.msg)
      else
        error(bin.bin .. " not found, " .. bin.msg)
      end
    end
  end
end

return health
