---@toc_entry Generating unit tests boilerplate
---@tag gopher.nvim-gotests
---@text gotests is utilizing the `gotests` tool to generate unit tests boilerplate.
---@usage
--- - Generate unit test for specific function/method:
---   1. Place your cursor on the desired function/method.
---   2. Run `:GoTestAdd`
---
--- - Generate unit tests for *all* functions/methods in current file:
---   - run `:GoTestsAll`
---
--- - Generate unit tests *only* for *exported(public)* functions/methods:
---   - run `:GoTestsExp`
---
--- You can also specify the template to use for generating the tests. See |gopher.nvim-config|
--- More details about templates can be found at: https://github.com/cweill/gotests
---

---@tag gopher.nvim-gotests-named
---@text
--- You can enable named tests in the config if you prefer using named tests.
--- But you must install `gotests@develop` because the stable version doesn't support this feature.
---
--- >lua
---   -- simply run go get in your shell:
---   go install github.com/cweill/gotests/...@develop
---
---   -- if you want to install it within neovim, you can use one of this:
---   -- if you choose to install gotests this way i reocmmend adding it to your `build` section in your |lazy.nvim|
---
---   vim.fn.jobstart("go install github.com/cweill/gotests/...@develop")
---
---   -- or if you want to use mason:
---   require("mason-tool-installer").setup {
---     ensure_installed = {
---       { "gotests", version = "develop" },
---     }
---   }
--- <

local c = require "gopher.config"
local ts_utils = require "gopher._utils.ts"
local r = require "gopher._utils.runner"
local u = require "gopher._utils"
local log = require "gopher._utils.log"
local gotests = {}

---@param args table
---@private
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
