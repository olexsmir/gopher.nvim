local runner = {}

local uv = vim.loop

---@class ProcessOpts
---@field args? string[]
---@field cwd? string
---@field on_exit? fun(ok:boolean, output:string)

---@param opts? ProcessOpts
---@param cmd string
function runner.spawn(cmd, opts)
  opts = opts or {}

  local stdout = assert(uv.new_pipe())
  local stderr = assert(uv.new_pipe())

  local output = ""
  ---@type uv_process_t?
  local handle = nil

  handle = uv.spawn(cmd, {
    stdio = { nil, stdout, stderr },
    args = opts.args,
    cwd = opts.cwd,
  }, function(status)
    if handle then
      handle:close()
    end
    stderr:close()
    stdout:close()

    if opts.on_exit then
      output = output:gsub("[^\r\n]+\r", "")
      vim.schedule(function()
        opts.on_exit(status == 0, output)
      end)
    end
  end)

  local function on_output(err, data)
    assert(not err, err)
    if data then
      output = output .. data:gsub("\r\n", "\n")
    end
  end

  uv.read_start(stdout, on_output)
  uv.read_start(stderr, on_output)

  return handle
end

return runner
