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
T["struct_tags"] = MiniTest.new_set {}
T["struct_tags"]["should add tag"] = function()
  local tmp = t.tmpfile()
  local fixtures = t.get_fixtures "tags/add"
  t.writefile(tmp, fixtures.input)

  child.cmd("silent edit " .. tmp)
  child.fn.setpos(".", { child.fn.bufnr(tmp), 3, 6, 0 })
  child.cmd "GoTagAdd json"
  child.cmd "write"

  t.eq(t.readfile(tmp), fixtures.output)
end

T["struct_tags"]["should remove tag"] = function()
  local tmp = t.tmpfile()
  local fixtures = t.get_fixtures "tags/remove"
  t.writefile(tmp, fixtures.input)

  child.cmd("silent edit " .. tmp)
  child.fn.setpos(".", { child.fn.bufnr(tmp), 4, 6, 0 })
  child.cmd "GoTagRm json"
  child.cmd "write"

  t.eq(t.readfile(tmp), fixtures.output)
end

T["struct_tags"]["should be able to handle many structs"] = function()
  local tmp = t.tmpfile()
  local fixtures = t.get_fixtures "tags/many"
  t.writefile(tmp, fixtures.input)

  child.cmd("silent edit " .. tmp)
  child.fn.setpos(".", { child.fn.bufnr(tmp), 10, 3, 0 })
  child.cmd "GoTagAdd testing"
  child.cmd "write"

  t.eq(t.readfile(tmp), fixtures.output)
end

T["struct_tags"]["should clear struct"] = function()
  local tmp = t.tmpfile()
  local fixtures = t.get_fixtures "tags/clear"
  t.writefile(tmp, fixtures.input)

  child.cmd("silent edit " .. tmp)
  child.fn.setpos(".", { child.fn.bufnr(tmp), 3, 1, 0 })
  child.cmd "GoTagClear"
  child.cmd "write"

  t.eq(t.readfile(tmp), fixtures.output)
end

T["struct_tags"]["should add more than one tag"] = function()
  local tmp = t.tmpfile()
  local fixtures = t.get_fixtures "tags/add_many"
  t.writefile(tmp, fixtures.input)

  --- with comma, like gomodifytags
  child.cmd("silent edit " .. tmp)
  child.fn.setpos(".", { child.fn.bufnr(tmp), 3, 1 })
  child.cmd "GoTagAdd test4,test5"
  child.cmd "write"

  -- without comma
  child.cmd("silent edit " .. tmp)
  child.fn.setpos(".", { child.fn.bufnr(tmp), 3, 1 })
  child.cmd "GoTagAdd test1 test2"
  child.cmd "write"

  t.eq(t.readfile(tmp), fixtures.output)
end

return T
