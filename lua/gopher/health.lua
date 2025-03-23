local health = {}
local cmd = require("gopher.config").commands

local deps = {
  plugin = {
    { lib = "nvim-treesitter", msg = "required for everything in gopher.nvim" },
  },
  bin = {
    {
      bin = cmd.go,
      msg = "required for `:GoGet`, `:GoMod`, `:GoGenerate`, `:GoWork`, `:GoInstallDeps`",
      optional = false,
    },
    { bin = cmd.gomodifytags, msg = "required for `:GoTagAdd`, `:GoTagRm`", optional = true },
    { bin = cmd.impl, msg = "required for `:GoImpl`", optional = true },
    { bin = cmd.iferr, msg = "required for `:GoIfErr`", optional = true },
    {
      bin = cmd.gotests,
      msg = "required for `:GoTestAdd`, `:GoTestsAll`, `:GoTestsExp`",
      optional = true,
    },
  },
  treesitter = {
    { parser = "go", msg = "required for `gopher.nvim`" },
  },
}

---@param module string
---@return boolean
local function is_lualib_found(module)
  local is_found, _ = pcall(require, module)
  return is_found
end

---@param bin string
---@return boolean
local function is_binary_found(bin)
  return vim.fn.executable(bin) == 1
end

---@param ft string
---@return boolean
local function is_treesitter_parser_available(ft)
  local ok, parser = pcall(vim.treesitter.get_parser, 0, ft)
  return ok and parser ~= nil
end

function health.check()
  vim.health.start "required plugins"
  for _, plugin in ipairs(deps.plugin) do
    if is_lualib_found(plugin.lib) then
      vim.health.ok(plugin.lib .. " installed")
    else
      vim.health.error(plugin.lib .. " not found, " .. plugin.msg)
    end
  end

  vim.health.start "required binaries"
  vim.health.info "all those binaries can be installed by `:GoInstallDeps`"
  for _, bin in ipairs(deps.bin) do
    if is_binary_found(bin.bin) then
      vim.health.ok(bin.bin .. " installed")
    else
      if bin.optional then
        vim.health.warn(bin.bin .. " not found, " .. bin.msg)
      else
        vim.health.error(bin.bin .. " not found, " .. bin.msg)
      end
    end
  end

  vim.health.start "required treesitter parsers"
  for _, parser in ipairs(deps.treesitter) do
    if is_treesitter_parser_available(parser.parser) then
      vim.health.ok(parser.parser .. " parser installed")
    else
      vim.health.error(parser.parser .. " parser not found, " .. parser.msg)
    end
  end
end

return health
