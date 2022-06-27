local Job = require "plenary.job"
local c = require("gopher.config").config.commands
local u = require "gopher._utils"

---run "go generate"
return function(...)
  local args = { ... }
  if #args == 1 and args[1] == "%" then
    args[1] = vim.fn.expand "%" ---@diagnostic disable-line: missing-parameter
  end

  local cmd_args = vim.list_extend({ "generate" }, args)

  Job
    :new({
      command = c.go,
      args = cmd_args,
      on_exit = function(_, retval)
        if retval ~= 0 then
          u.notify("command 'go " .. unpack(cmd_args) .. "' exited with code " .. retval, "error")
          return
        end

        u.notify("go generate was success runned", "info")
      end,
    })
    :start()
end
