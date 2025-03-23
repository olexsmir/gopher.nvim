local t = require "spec.testutils"
local child, T = t.setup "struct_tags"

T["struct_tags"]["should add tag"] = function()
  local rs = t.setup_test("tags/add", child, { 3, 6 })
  child.cmd "GoTagAdd json"
  child.cmd "write"

  t.eq(t.readfile(rs.tmp), rs.fixtures.output)
  t.cleanup(rs)
end

T["struct_tags"]["should remove tag"] = function()
  local rs = t.setup_test("tags/remove", child, { 4, 6 })
  child.cmd "GoTagRm json"
  child.cmd "write"

  t.eq(t.readfile(rs.tmp), rs.fixtures.output)
  t.cleanup(rs)
end

T["struct_tags"]["should be able to handle many structs"] = function()
  local rs = t.setup_test("tags/many", child, { 10, 3 })
  child.cmd "GoTagAdd testing"
  child.cmd "write"

  t.eq(t.readfile(rs.tmp), rs.fixtures.output)
  t.cleanup(rs)
end

T["struct_tags"]["should clear struct"] = function()
  local rs = t.setup_test("tags/clear", child, { 3, 1 })
  child.cmd "GoTagClear"
  child.cmd "write"

  t.eq(t.readfile(rs.tmp), rs.fixtures.output)
  t.cleanup(rs)
end

T["struct_tags"]["should add more than one tag"] = function()
  local tmp = t.tmpfile()
  local fixtures = t.get_fixtures "tags/add_many"
  t.writefile(tmp, fixtures.input)

  --- with comma, like gomodifytags
  child.cmd("silent edit " .. tmp)
  child.lua "vim.treesitter.start()"

  child.fn.setpos(".", { child.fn.bufnr(tmp), 3, 1 })
  child.cmd "GoTagAdd test4,test5"
  child.cmd "write"

  -- without comma
  child.cmd("silent edit " .. tmp)
  child.lua "vim.treesitter.start()"

  child.fn.setpos(".", { child.fn.bufnr(tmp), 3, 1 })
  child.cmd "GoTagAdd test1 test2"
  child.cmd "write"

  t.eq(t.readfile(tmp), fixtures.output)

  ---@diagnostic disable-next-line:missing-fields
  t.cleanup { tmp = tmp }
end

T["struct_tags"]["should add tags on var"] = function()
  local rs = t.setup_test("tags/var", child, { 5, 6 })
  child.cmd "GoTagAdd yaml"
  child.cmd "write"

  t.eq(t.readfile(rs.tmp), rs.fixtures.output)
  t.cleanup(rs)
end

T["struct_tags"]["should add tags on short declr var"] = function()
  local rs = t.setup_test("tags/svar", child, { 4, 3 })
  child.cmd "GoTagAdd xml"
  child.cmd "write"

  t.eq(t.readfile(rs.tmp), rs.fixtures.output)
  t.cleanup(rs)
end

return T
