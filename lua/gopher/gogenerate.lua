local Job = require "plenary.job"

return function(...)
  local args = { ... }
  if #args == 1 and args[1] == "%" then
    args[1] = vim.fn.expand "%" ---@diagnostic disable-line: missing-parameter
  end

  local cmd_args = vim.list_extend({ "generate" }, args)

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
