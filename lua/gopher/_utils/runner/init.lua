local runner = {}

---@class gopher.RunnerOpts
---@field cwd? string
---@field timeout? number
---@field stdin? string|string[]

---@param cmd (string|number)[]
---@param opts? gopher.RunnerOpts
---@return vim.SystemCompleted
function runner.sync(cmd, opts)
  opts = opts or {}

  return vim
    .system(cmd, {
      cwd = opts.cwd or nil,
      timeout = opts.timeout or 2000, -- TODO: move out to config
      stdin = opts.stdin or nil,
      text = true,
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
    timeout = opts.timeout or 2000,
    text = true,
  }, on_exit)
end

return runner
