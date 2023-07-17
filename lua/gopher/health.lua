local health = {}
local cmd = require("gopher.config").config.commands
local u = require "gopher._utils.health"

local _h = vim.health or require "health"
local h = {
  start = _h.start or _h.report_start,
  ok = _h.ok or _h.report_ok,
  warn = _h.warn or _h.report_warn,
  error = _h.error or _h.report_error,
  info = _h.info or _h.report_info,
}

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
  h.start "required plugins"
  for _, plugin in ipairs(deps.plugin) do
    if u.lualib_is_found(plugin.lib) then
      h.ok(plugin.lib .. " installed")
    else
      if plugin.optional then
        h.warn(plugin.lib .. " not found, " .. plugin.msg)
      else
        h.error(plugin.lib .. " not found, " .. plugin.msg)
      end
    end
  end

  h.start "required binaries"
  h.info "all those binaries can be installed by `:GoInstallDeps`"
  for _, bin in ipairs(deps.bin) do
    if u.binary_is_found(bin.bin) then
      h.ok(bin.bin .. " installed")
    else
      if bin.optional then
        h.warn(bin.bin .. " not found, " .. bin.msg)
      else
        h.error(bin.bin .. " not found, " .. bin.msg)
      end
    end
  end
end

return health
