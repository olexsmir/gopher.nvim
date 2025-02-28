local r = require "gopher._utils.runner"
local c = require("gopher.config").commands
local u = require "gopher._utils"
local log = require "gopher._utils.log"
local gocmd = {}

---@param args string[]
---@return string[]
local function handle_get_cmd(args)
  for i, arg in ipairs(args) do
    local m = string.match(arg, "^https?://(.*)$") or arg
    table.remove(args, i)
    table.insert(args, i, m)
  end
  return args
end

---@param args string[]
---@return string[]
local function handle_generate_cmd(args)
  if #args == 1 and args[1] == "%" then
    args[1] = vim.fn.expand "%"
  end
  return args
end

---@param subcmd string
---@param args string[]
function gocmd.run(subcmd, args)
  args = args or {}
  if subcmd == "get" then
    args = handle_get_cmd(args)
  elseif subcmd == "generate" then
    args = handle_generate_cmd(args)
  end

  r.async({ c.go, subcmd, unpack(args) }, function(opt)
    if opt.code ~= 0 then
      log.error("go " .. subcmd .. "  failed: " .. vim.inspect(opt))
      error("go " .. subcmd .. "  failed: " .. opt.stderr)
    end

    u.deferred_notify("go " .. subcmd .. "ran successfully, output: " .. opt.stdout)
  end)
end

return gocmd
