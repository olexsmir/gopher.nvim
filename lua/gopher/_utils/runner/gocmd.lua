local r = require "gopher._utils.runner"
local c = require("gopher.config").commands
local u = require "gopher._utils"
local gocmd = {}

---@param args string[]
---@return string[]
local function if_get(args)
  for i, arg in ipairs(args) do
    local m = string.match(arg, "^https://(.*)$") or string.match(arg, "^http://(.*)$") or arg
    table.remove(args, i)
    table.insert(args, i, m)
  end
  return args
end

---@param args unknown[]
---@return string[]
local function if_generate(args)
  if #args == 1 and args[1] == "%" then
    args[1] = vim.fn.expand "%"
  end
  return args
end

---@param subcmd string
---@param args string[]
---@return string[]|nil
function gocmd.run(subcmd, args)
  if #args == 0 then
    error "please provide any arguments"
  end

  if subcmd == "get" then
    args = if_get(args)
  end

  if subcmd == "generate" then
    args = if_generate(args)
  end

  return r.sync(c.go, {
    args = { subcmd, unpack(args) },
    on_exit = function(data, status)
      if status ~= 0 then
        error("gocmd failed: " .. data)
      end
      u.notify(c.go .. " " .. subcmd .. " ran successful")
    end,
  })
end

return gocmd
