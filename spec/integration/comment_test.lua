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

local function do_the_test(fixture, pos)
  local tmp = t.tmpfile()
  local fixtures = t.get_fixtures("comment/" .. fixture)
  t.writefile(tmp, fixtures.input)

  child.cmd("silent edit " .. tmp)
  child.fn.setpos(".", { child.fn.bufnr "%", unpack(pos) })
  child.cmd "GoCmt"
  child.cmd "write"

  t.eq(t.readfile(tmp), fixtures.output)

  -- without it all other(not even from this module) tests are falling
  t.deletefile(tmp)
end

T["comment"] = MiniTest.new_set {}
T["comment"]["should add comment to package"] = function()
  do_the_test("package", { 1, 1 })
end

T["comment"]["should add comment to struct"] = function()
  do_the_test("struct", { 4, 1 })
end

T["comment"]["should add comment to function"] = function()
  do_the_test("func", { 3, 1 })
end

T["comment"]["should add comment to method"] = function()
  do_the_test("method", { 5, 1 })
end

T["comment"]["should add comment to interface"] = function()
  do_the_test("interface", { 3, 6 })
end

T["comment"]["otherwise should add // above cursor"] = function()
  do_the_test("empty", { 1, 1 })
end

return T
