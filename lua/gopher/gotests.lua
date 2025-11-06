---@toc_entry Generating unit tests boilerplate
---@tag gopher.nvim-gotests
---@text gotests is utilizing the `gotests` tool to generate unit tests boilerplate.
---@usage
--- - Generate unit test for specific function/method:
---  1. Place your cursor on the desired function/method.
---  2. Run `:GoTestAdd`
---
--- - Generate unit tests for *all* functions/methods in current file:
---  - run `:GoTestsAll`
---
--- - Generate unit tests *only* for *exported(public)* functions/methods:
---  - run `:GoTestsExp`
---
--- You can also specify the template to use for generating the tests.
--- See |gopher.nvim-config|.
--- More details about templates: https://github.com/cweill/gotests
---
--- If you prefer named tests, you can enable them in |gopher.nvim-config|.

local c = require "gopher.config"
local ts_utils = require "gopher._utils.ts"
local r = require "gopher._utils.runner"
local u = require "gopher._utils"
local log = require "gopher._utils.log"
local gotests = {}

---@param args table
---@dochide
local function add_test(args)
  if c.gotests.named then
    table.insert(args, "-named")
  end

  if c.gotests.template_dir then
    table.insert(args, "-template_dir")
    table.insert(args, c.gotests.template_dir)
  end

  if c.gotests.template ~= "default" then
    table.insert(args, "-template")
    table.insert(args, c.gotests.template)
  end

  table.insert(args, "-w")
  table.insert(args, vim.fn.expand "%")

  log.debug("generating tests with args: ", args)

  local rs = r.sync { c.commands.gotests, unpack(args) }
  if rs.code ~= 0 then
    error("gotests failed: " .. rs.stderr)
  end

  u.notify "unit test(s) generated"
end

-- generate unit test for one function
function gotests.func_test()
  local bufnr = vim.api.nvim_get_current_buf()
  local func = ts_utils.get_func_under_cursor(bufnr)

  add_test { "-only", func.name }
end

-- generate unit tests for all functions in current file
function gotests.all_tests()
  add_test { "-all" }
end

-- generate unit tests for all exported functions
function gotests.all_exported_tests()
  add_test { "-exported" }
end

return gotests
