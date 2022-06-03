local Job = require "plenary.job"

return function(...)
  local args = { ... }
  local cmd_args = vim.list_extend({ "mod" }, args)

  Job
    :new({
      command = "go",
      args = cmd_args,
      on_exit = function(_, retval)
        if retval ~= 0 then
          print("command exited with code " .. retval)
          return
        else
          print "command runs successfully"
        end
      end,
    })
    :start()
end
