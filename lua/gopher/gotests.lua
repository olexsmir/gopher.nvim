---@toc_entry Generating unit tests boilerplate
---@tag gopher.nvim-gotests
---@text gotests is utilizing the `gotests` tool to generate unit tests boilerplate.
---@usage
--- - generate unit test for spesisfic function/method
---   - to specift the function/method put your cursor on it
---   - run `:GoTestAdd`
---
--- - generate unit tests for all functions/methods in current file
---   - run `:GoTestsAll`
---
--- - generate unit tests only for exported(public) functions/methods
---   - run `:GoTestsExp`
---
--- you can also specify the template to use for generating the tests. see |gopher.nvim-config|
--- more details about templates can be found at: https://github.com/cweill/gotests
---

---@tag gopher.nvim-gotests-named
---@text
--- if you prefare using named tests, you can enable it in the config.
--- but you would need to install `gotests@develop` because stable version doesn't support this feature.
--- you can do it with:
--- >lua
---   -- simply run go get in your shell:
---   go install github.com/cweill/gotests/...@develop
---
---   -- if you want to install it within neovim, you can use one of this:
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
---
--- if you choose to install `gotests` within neovim, i recommend adding it to your `build` section in your |lazy.nvim|

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

  return r.sync(c.commands.gotests, {
    args = args,
    on_exit = function(data, status)
      if not status == 0 then
        error("gotests failed: " .. data)
      end

      u.notify "unit test(s) generated"
    end,
  })
end

-- generate unit test for one function
function gotests.func_test()
  local ns = ts_utils.get_func_method_node_at_pos(unpack(vim.api.nvim_win_get_cursor(0)))
  if ns == nil or ns.name == nil then
    u.notify("cursor on func/method and execute the command again", vim.log.levels.WARN)
    return
  end

  add_test { "-only", ns.name }
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
