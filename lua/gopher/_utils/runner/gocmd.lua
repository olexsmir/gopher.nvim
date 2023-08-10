local r = require "gopher._utils.runner"
local c = require("gopher.config").commands
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
    error("please provice any arguments", vim.log.levels.ERROR)
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
      if not status == 0 then
        error("gocmd failed: " .. data, vim.log.levels.ERROR)
      end
      vim.notify(c.go .. " " .. subcmd .. " successful runned", vim.log.levels.INFO)
    end,
  })
end

return gocmd
