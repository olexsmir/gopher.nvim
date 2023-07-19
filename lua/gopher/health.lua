local health = {}
local cmd = require("gopher.config").commands
local u = require "gopher._utils.health"

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
  u.start "required plugins"
  for _, plugin in ipairs(deps.plugin) do
    if u.is_lualib_found(plugin.lib) then
      u.ok(plugin.lib .. " installed")
    else
      if plugin.optional then
        u.warn(plugin.lib .. " not found, " .. plugin.msg)
      else
        u.error(plugin.lib .. " not found, " .. plugin.msg)
      end
    end
  end

  u.start "required binaries"
  u.info "all those binaries can be installed by `:GoInstallDeps`"
  for _, bin in ipairs(deps.bin) do
    if u.is_lualib_found(bin.bin) then
      u.ok(bin.bin .. " installed")
    else
      if bin.optional then
        u.warn(bin.bin .. " not found, " .. bin.msg)
      else
        u.error(bin.bin .. " not found, " .. bin.msg)
      end
    end
  end
end

return health
