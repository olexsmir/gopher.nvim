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
T["impl"] = MiniTest.new_set {}
T["impl"]["works w io.Writer"] = function()
  local tmp = t.tmpfile()
  local fixtures = t.get_fixtures "impl/writer"
  t.writefile(tmp, fixtures.input)

  child.cmd("silent edit " .. tmp)
  child.fn.setpos(".", { child.fn.bufnr(tmp), 3, 0 })
  child.cmd "GoImpl w io.Writer"
  child.cmd "write"

  -- NOTE: since "impl" won't implement interface if it's already implemented i went with this hack
  local rhs = fixtures.output:gsub("Test2", "Test")
  t.eq(t.readfile(tmp), rhs)
end

T["impl"]["works r Read io.Reader"] = function()
  local tmp = t.tmpfile()
  local fixtures = t.get_fixtures "impl/reader"
  t.writefile(tmp, fixtures.input)

  child.cmd("silent edit " .. tmp)
  child.cmd "GoImpl r Read io.Reader"
  child.cmd "write"

  local rhs = fixtures.output:gsub("Read2", "Read")
  t.eq(t.readfile(tmp), rhs)
end

T["impl"]["works io.Closer"] = function()
  local tmp = t.tmpfile()
  local fixtures = t.get_fixtures "impl/closer"
  t.writefile(tmp, fixtures.input)

  child.cmd("silent edit " .. tmp)
  child.fn.setpos(".", { child.fn.bufnr(tmp), 3, 6 })
  child.cmd "GoImpl io.Closer"
  child.cmd "write"

  local rhs = fixtures.output:gsub("Test2", "Test")
  t.eq(t.readfile(tmp), rhs)
end

return T
