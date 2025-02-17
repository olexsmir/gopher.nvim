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
T["impl"]["works w io.Writer"] = function()
  local tmp = t.tmpfile()
  local fixtures = t.fixtures.read "impl/writer"
  t.fixtures.write(tmp, fixtures.input)

  child.cmd("silent edit " .. tmp)
  child.fn.setpos(".", { child.fn.bufnr(tmp), 3, 6 })
  child.cmd "GoImpl w io.Writer"
  child.cmd "write"

  -- since "impl" won't implement interface if it's already implemented i went with this hack
  local rhs = fixtures.output:gsub("Test2", "Test")
  t.eq(t.readfile(tmp), rhs)
end

T["impl"]["works r Read io.Reader"] = function()
  local tmp = t.tmpfile()
  local fixtures = t.fixtures.read "impl/reader"
  t.fixtures.write(tmp, fixtures.input)

  child.cmd("silent edit " .. tmp)
  child.cmd "GoImpl r Read io.Reader"
  child.cmd "write"

  local rhs = fixtures.output:gsub("Read2", "Read")
  t.eq(t.readfile(tmp), rhs)
end

T["impl"]["works io.Closer"] = function()
  local tmp = t.tmpfile()
  local fixtures = t.fixtures.read "impl/closer"
  t.fixtures.write(tmp, fixtures.input)

  child.cmd("silent edit " .. tmp)
  child.fn.setpos(".", { child.fn.bufnr(tmp), 3, 6 })
  child.cmd "GoImpl io.Closer"
  child.cmd "write"

  local rhs = fixtures.output:gsub("Test2", "Test")
  t.eq(t.readfile(tmp), rhs)
end

return T
