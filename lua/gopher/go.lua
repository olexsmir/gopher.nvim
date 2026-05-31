local go = {}

local function run(subcmd, args)
  local c = require "gopher.config"
  local u = require "gopher._utils"
  local r = require "gopher._utils.runner"

  local rs = r.sync { c.commands.go, subcmd, unpack(args) }
  if rs.code ~= 0 then
    error("go " .. subcmd .. " failed: " .. rs.stderr)
  end

  u.notify(c.commands.go .. " " .. subcmd .. " ran successful")
  return rs.stdout
end

---@param args string[]
function go.get(args)
  for i, arg in ipairs(args) do
    local m = string.match(arg, "^https://(.*)$") or string.match(arg, "^http://(.*)$") or arg
    table.remove(args, i)
    table.insert(args, i, m)
  end

  local gopls = require("gopher._utils.gopls").get_current()
  if gopls then
    gopls:get { pkg = args }
    return
  end

  run("get", args)
end

---@param args string[]
function go.mod(args)
  local gopls = require("gopher._utils.gopls").get_current()
  if gopls and args[1] == "tidy" then
    gopls:tidy()
    return
  end

  run("mod", args)
end

---@param args string[]
function go.work(args)
  run("work", args)
end

-- Executes `go generate`.
-- If no arguments provided, go generate will be run in cwd of current buffer.
-- To run `go generate` recursively pass `./...` as it's argument.
---@param args string[]
function go.generate(args)
  local recursive = (#args == 1 and args[1] == "./...")

  local gopls = require("gopher._utils.gopls").get_current()
  if gopls then
    gopls:generate { recursive = recursive }
    return
  end

  -- fallback to `go generate`
  run("generate", recursive and "./..." or vim.fn.expand "%:p:h")
end

return go
