local t = require "spec.testutils"

local child = MiniTest.new_child_neovim()
local T = MiniTest.new_set {
  hooks = {
    post_once = child.stop,
    pre_case = function()
      child.restart { "-u", t.mininit_path }
    end,
  },
}
T["gotests"] = MiniTest.new_set {}

--- NOTE: :GoTestAdd is the only place that has actual logic
--- All other parts are handled `gotests` tool itself.

T["gotests"]["should add test for function under cursor"] = function()
  local tmp = "/home/olex/2.go"
  local fixtures = t.get_fixtures "tests/function"
  t.writefile(tmp, fixtures.input)

  child.cmd("silent edit " .. tmp)
  child.fn.setpos(".", { child.fn.bufnr "%", 3, 6 })
  child.cmd "GoTestAdd"

  t.eq(fixtures.output, t.readfile(tmp:gsub(".go", "_test.go")))
end

T["gotests"]["should add test for method under cursor"] = function()
  local tmp = "/home/olex/1.go"
  local fixtures = t.get_fixtures "tests/method"
  t.writefile(tmp, fixtures.input)

  child.cmd("silent edit " .. tmp)
  child.fn.setpos(".", { child.fn.bufnr "%", 5, 19 })
  child.cmd "GoTestAdd"

  t.eq(fixtures.output, t.readfile(tmp:gsub(".go", "_test.go")))
end

return T
