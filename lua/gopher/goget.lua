local Job = require "plenary.job"
local c = require("gopher.config").config.commands
local u = require "gopher._utils"

---run "go get"
return function(...)
  local args = { ... }
  if #args == 0 then
    u.notify("please provide a package url to get", "error")
    return
  end

  for i, arg in ipairs(args) do
    local m = string.match(arg, "^https://(.*)$") or string.match(arg, "^http://(.*)$") or arg
    table.remove(args, i)
    table.insert(args, i, m)
  end

  local cmd_args = vim.list_extend({ "get" }, args)

  Job:new({
    command = c.go,
    args = cmd_args,
    on_exit = function(_, retval)
      if retval ~= 0 then
        u.notify("command 'go " .. unpack(cmd_args) .. "' exited with code " .. retval, "error")
        return
      end

      u.notify("go get was success runned", "info")
    end,
  }):start()
end
