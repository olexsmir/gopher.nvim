local t = require "spec.testutils"

local child = MiniTest.new_child_neovim()
local T = MiniTest.new_set {
  hooks = {
    post_once = child.stop,
    pre_case = function()
      child.restart { "-u", "scripts/minimal_init.lua" }
    end,
  },
}
T["impl"] = MiniTest.new_set {}
T["impl"]["works"] = function()
  local tmp = t.tmpfile()
  local fixtures = t.fixtures.read "impl/impl"
  t.fixtures.write(tmp, fixtures.input)

  child.cmd("silent edit " .. tmp)
  child.fn.setpos(".", { child.fn.bufnr "%", 3, 6, 0 })
  child.cmd "GoImpl w io.Writer"
  child.cmd "write"

  -- since "impl" won't implement interface if it's already implemented i went with this hack
  local rhs = fixtures.output:gsub("Tester2", "Tester")
  t.eq(t.readfile(tmp), rhs)
end

return T
