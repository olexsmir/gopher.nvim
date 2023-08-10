local Job = require "plenary.job"
local runner = {}

---@class gopher.RunnerOpts
---@field args? string[]
---@field cwd? string?
---@field on_exit? fun(data:string, status:number)

---@param cmd string
---@param opts gopher.RunnerOpts
---@return string[]|nil
function runner.sync(cmd, opts)
  local output
  Job:new({
    command = cmd,
    args = opts.args,
    cwd = opts.cwd,
    on_stderr = function(_, data)
      vim.print(data)
    end,
    on_exit = function(data, status)
      output = data:result()
      vim.schedule(function()
        if opts.on_exit then
          opts.on_exit(output, status)
        end
      end)
    end,
  }):sync()
  return output
end

return runner
