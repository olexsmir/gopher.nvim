local Job = require "plenary.job"
local c = require("gopher.config").config.commands
local u = require "gopher._utils"

---Run any go commands like `go generate`, `go get`, `go mod`
---@param cmd string
---@param ... string|string[]
return function(cmd, ...)
  local args = { ... }
  if #args == 0 then
    u.notify("please provice any arguments", "error")
    return
  end

  if cmd == "generate" and #args == 1 and args[1] == "%" then
    args[1] = vim.fn.expand "%" ---@diagnostic disable-line: missing-parameter
  elseif cmd == "get" then
    for i, arg in ipairs(args) do
      ---@diagnostic disable-next-line: param-type-mismatch
      local m = string.match(arg, "^https://(.*)$") or string.match(arg, "^http://(.*)$") or arg
      table.remove(args, i)
      table.insert(args, i, m)
    end
  end

  local cmd_args = vim.list_extend({ cmd }, args) ---@diagnostic disable-line: missing-parameter
  Job:new({
    command = c.go,
    args = cmd_args,
    on_exit = function(_, retval)
      if retval ~= 0 then
        u.notify("command 'go " .. unpack(cmd_args) .. "' exited with code " .. retval, "error")
        u.notify(cmd .. " " .. unpack(cmd_args), "debug")
        return
      end

      u.notify("go " .. cmd .. " was success runned", "info")
    end,
  }):start()
end
