---@toc_entry Setup `nvim-dap` for Go
---@tag gopher.nvim-dap
---@text This module sets up `nvim-dap` for Go.
---@usage just call `require("gopher.dap").setup()`, and you're good to go.

local c = require "gopher.config"
local dap = {}

dap.adapter = function(callback, config)
  local host = config.host or "127.0.0.1"
  local port = config.port or "38697"
  local addr = string.format("%s:%s", host, port)

  local handle, pid_or_err
  local stdout = assert(vim.loop.new_pipe(false))
  local opts = {
    stdio = { nil, stdout },
    args = { "dap", "-l", addr },
    detached = true,
  }

  handle, pid_or_err = vim.loop.spawn(c.commands.dlv, opts, function(status)
    if not stdout or not handle then
      return
    end

    stdout:close()
    handle:close()
    if status ~= 0 then
      print("dlv exited with code", status)
    end
  end)

  assert(handle, "Error running dlv: " .. tostring(pid_or_err))
  if stdout then
    stdout:read_start(function(err, chunk)
      assert(not err, err)
      if chunk then
        vim.schedule(function()
          require("dap.repl").append(chunk)
        end)
      end
    end)
  end

  -- wait for delve to start
  vim.defer_fn(function()
    callback { type = "server", host = "127.0.0.1", port = port }
  end, 100)
end

local function args_input()
  vim.ui.input({ prompt = "Args: " }, function(input)
    return vim.split(input or "", " ")
  end)
end

local function get_arguments()
  local co = coroutine.running()
  if co then
    return coroutine.create(function()
      local args = args_input()
      coroutine.resume(co, args)
    end)
  else
    return args_input()
  end
end

dap.configuration = {
  {
    type = "go",
    name = "Debug",
    request = "launch",
    program = "${file}",
  },
  {
    type = "go",
    name = "Debug (Arguments)",
    request = "launch",
    program = "${file}",
    args = get_arguments,
  },
  {
    type = "go",
    name = "Debug Package",
    request = "launch",
    program = "${fileDirname}",
  },
  {
    type = "go",
    name = "Attach",
    mode = "local",
    request = "attach",
    processId = require("dap.utils").pick_process,
  },
  {
    type = "go",
    name = "Debug test",
    request = "launch",
    mode = "test",
    program = "${file}",
  },
  {
    type = "go",
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}",
  },
}

-- sets ups nvim-dap for Go in one function call.
function dap.setup()
  vim.deprecate(
    "gopher.dap",
    "you might consider setting up `nvim-dap` manually, or using another plugin(https://github.com/leoluz/nvim-dap-go)",
    "v0.1.6",
    "gopher"
  )

  local ok, d = pcall(require, "dap")
  assert(ok, "gopher.nvim dependency error: dap not installed")

  d.adapters.go = dap.adapter
  d.configurations.go = dap.configuration
end

return dap
