local c = require "gopher.config"
local u = require "gopher._utils"
local lsp = require "gopher._utils.lsp"
local r = require "gopher._utils.runner"
local go = {}

local function run(subcmd, args)
  local rs = r.sync { c.commands.go, subcmd, unpack(args) }
  if rs.code ~= 0 then
    error("go " .. subcmd .. " failed: " .. rs.stderr)
  end

  u.notify(c.commands.go .. " " .. subcmd .. " ran successful")
  return rs.stdout
end

local function restart_lsp()
  if c.restart_lsp then
    lsp.restart()
  end
end

---@param args string[]
function go.get(args)
  for i, arg in ipairs(args) do
    local m = string.match(arg, "^https://(.*)$") or string.match(arg, "^http://(.*)$") or arg
    table.remove(args, i)
    table.insert(args, i, m)
  end

  run("get", args)
  restart_lsp()
end

---@param args string[]
function go.mod(args)
  run("mod", args)
  restart_lsp()
end

---@param args string[]
function go.work(args)
  -- TODO: use `gopls.tidy`

  run("work", args)
  restart_lsp()
end

---Executes `go generate`
---If only argument is `%` it's going to be equivalent to `go generate <path to current file>`
---@param args string[]
function go.generate(args)
  -- TODO: use `gopls.generate`

  if #args == 0 then
    error "please provide arguments"
  end

  if #args == 1 and args[1] == "%" then
    args[1] = vim.fn.expand "%"
  end

  run("generate", args)
end

return go
