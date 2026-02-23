local c = require "gopher.config"
local health = {}

local deps = {
  vim_version = "nvim-0.10",
  bin = {
    {
      bin = c.commands.go,
      msg = "required for `:GoGet`, `:GoMod`, `:GoGenerate`, `:GoWork`, `:GoInstallDeps`, `:GoInstallDepsSync`",
    },
    { bin = c.commands.gomodifytags, msg = "required for `:GoTagAdd`, `:GoTagRm`" },
    { bin = c.commands.impl, msg = "required for `:GoImpl`" },
    { bin = c.commands.iferr, msg = "required for `:GoIfErr`" },
    { bin = c.commands.gotests, msg = "required for `:GoTestAdd`, `:GoTestsAll`, `:GoTestsExp`" },
    { bin = c.commands.json2go, msg = "required for `:GoJson`" },
  },
  treesitter = {
    { parser = "go", msg = "required for most of the parts of `gopher.nvim`" },
  },
}

---@param bin {bin:string, msg:string, optional:boolean}
local function check_binary(bin)
  if vim.fn.executable(bin.bin) == 1 then
    vim.health.ok(bin.bin .. " is found oh PATH: `" .. vim.fn.exepath(bin.bin) .. "`")
  else
    vim.health.error(bin.bin .. " not found on PATH, " .. bin.msg)
  end
end

---@param ts {parser:string, msg:string}
local function check_treesitter(ts)
  local ok, parser = pcall(vim.treesitter.get_parser, 0, ts.parser)
  if ok and parser ~= nil then
    vim.health.ok("`" .. ts.parser .. "` parser is installed")
  else
    vim.health.error("`" .. ts.parser .. "` parser not found")
  end
end

function health.check()
  vim.health.start "Neovim version"
  if vim.fn.has(deps.vim_version) == 1 then
    vim.health.ok "Neovim version is compatible"
  else
    vim.health.error(deps.vim_version .. " or newer is required")
  end

  vim.health.start "Required binaries (those can be installed with `:GoInstallDeps`)"
  for _, bin in ipairs(deps.bin) do
    check_binary(bin)
  end

  vim.health.start "Treesitter"
  for _, parser in ipairs(deps.treesitter) do
    check_treesitter(parser)
  end
end

return health
