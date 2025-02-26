local c = require "gopher.config"
local runner = {}

---@class gopher.RunnerOpts
---@field cwd? string
---@field timeout? number
---@field stdin? boolean|string|string[]
---@field text? boolean

---@param cmd (string|number)[]
---@param opts? gopher.RunnerOpts
---@return vim.SystemCompleted
function runner.sync(cmd, opts)
  opts = opts or {}

  return vim
    .system(cmd, {
      cwd = opts.cwd or nil,
      timeout = opts.timeout or c.timeout,
      stdin = opts.stdin or nil,
      text = opts.text or true,
    })
    :wait()
end

---@param cmd (string|number)[]
---@param on_exit fun(out:vim.SystemCompleted)
---@param opts? gopher.RunnerOpts
---@return vim.SystemObj
function runner.async(cmd, on_exit, opts)
  opts = opts or {}
  return vim.system(cmd, {
    cwd = opts.cwd or nil,
    timeout = opts.timeout or c.timeout,
    stdin = opts.stdin or nil,
    text = opts.text or true,
  }, on_exit)
end

return runner
