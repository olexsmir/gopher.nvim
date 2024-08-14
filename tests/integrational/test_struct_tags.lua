local u = require "gopher._utils.testutil"
local eq = MiniTest.expect.equality

local T = MiniTest.new_set()
T["struct_tags"] = MiniTest.new_set()
T["struct_tags"]['.add("json")'] = function()
  local tmp = u.tmp_file()
  local fixtures = u.read_fixture "tags/add"
  u.write_fixture(tmp, fixtures.input)

  vim.cmd("silent edit" .. tmp)
  vim.bo.filetype = "go"
  vim.fn.setpos(".", { vim.fn.bufnr "%", 3, 6, 0 })

  require("gopher.struct_tags").add "json"
  vim.wait(500)

  eq(u.readfile(tmp), fixtures.output)

  u.cleanup(tmp)
end

T["struct_tags"][".remove()"] = function()
  local tmp = u.tmp_file()
  local fixtures = u.read_fixture "tags/remove"
  u.write_fixture(tmp, fixtures.input)

  vim.cmd("silent edit" .. tmp)
  vim.bo.filetype = "go"
  vim.fn.setpos(".", { vim.fn.bufnr "%", 3, 6, 0 })

  require("gopher.struct_tags").remove "json"
  vim.wait(500)

  eq(u.readfile(tmp), fixtures.output)

  u.cleanup(tmp)
end

return T
