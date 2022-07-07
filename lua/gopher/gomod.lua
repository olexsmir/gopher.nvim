local Job = require "plenary.job"
local c = require("gopher.config").config.commands
local u = require "gopher._utils"

---run "go mod"
return function(...)
  local args = { ... }
  if #args == 0 then
    u.notify("please provide any mod command", "error")
    return
  end

  local cmd_args = vim.list_extend({ "mod" }, args)

  Job:new({
    command = c.go,
    args = cmd_args,
    on_exit = function(_, retval)
      if retval ~= 0 then
        u.notify("command 'go " .. unpack(cmd_args) .. "' exited with code " .. retval, "error")
        return
      end

      u.notify("go mod was success runned", "info")
    end,
  }):start()
end
