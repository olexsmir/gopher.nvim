local Job = require "plenary.job"

return function(...)
  local args = { ... }
  for i, arg in ipairs(args) do
    local m = string.match(arg, "^https://(.*)$") or string.match(arg, "^http://(.*)$") or arg
    table.remove(args, i)
    table.insert(args, i, m)
  end

  local cmd_args = vim.list_extend({ "get" }, args)

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
