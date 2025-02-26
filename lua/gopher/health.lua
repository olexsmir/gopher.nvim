local health = {}
local cmd = require("gopher.config").commands
local u = require "gopher._utils.health_util"

local deps = {
  plugin = {
    { lib = "nvim-treesitter", msg = "required for basically everything in gopher.nvim" },
  },
  bin = {
    {
      bin = cmd.go,
      msg = "required for `:GoGet`, `:GoMod`, `:GoGenerate`, `:GoWork`, `:GoInstallDeps`",
      optional = false,
    },
    { bin = cmd.gomodifytags, msg = "required for `:GoTagAdd`, `:GoTagRm`", optional = false },
    { bin = cmd.impl, msg = "required for `:GoImpl`", optional = false },
    { bin = cmd.iferr, msg = "required for `:GoIfErr`", optional = false },
    {
      bin = cmd.gotests,
      msg = "required for `:GoTestAdd`, `:GoTestsAll`, `:GoTestsExp`",
      optional = false,
    },
  },
  treesitter = {
    { parser = "go", msg = "required for `gopher.nvim`", optional = false },
  },
}

function health.check()
  u.start "required plugins"
  for _, plugin in ipairs(deps.plugin) do
    if u.is_lualib_found(plugin.lib) then
      u.ok(plugin.lib .. " installed")
    else
      u.error(plugin.lib .. " not found, " .. plugin.msg)
    end
  end

  u.start "required binaries"
  u.info "all those binaries can be installed by `:GoInstallDeps`"
  for _, bin in ipairs(deps.bin) do
    if u.is_binary_found(bin.bin) then
      u.ok(bin.bin .. " installed")
    else
      if bin.optional then
        u.warn(bin.bin .. " not found, " .. bin.msg)
      else
        u.error(bin.bin .. " not found, " .. bin.msg)
      end
    end
  end

  u.start "required treesitter parsers"
  for _, parser in ipairs(deps.treesitter) do
    if u.is_treesitter_parser_available(parser.parser) then
      u.ok(parser.parser .. " parser installed")
    else
      u.error(parser.parser .. " parser not found, " .. parser.msg)
    end
  end
end

return health
