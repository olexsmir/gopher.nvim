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
T["struct_tags"] = MiniTest.new_set {}
T["struct_tags"]["works add"] = function()
  local tmp = t.tmpfile()
  local fixtures = t.fixtures.read "tags/add"
  t.fixtures.write(tmp, fixtures.input)

  child.cmd("silent edit " .. tmp)
  child.fn.setpos(".", { child.fn.bufnr "%", 3, 6, 0 })
  child.cmd "GoTagAdd json"

  t.eq(t.readfile(tmp), fixtures.output)
end

T["struct_tags"]["works remove"] = function()
  local tmp = t.tmpfile()
  local fixtures = t.fixtures.read "tags/remove"
  t.fixtures.write(tmp, fixtures.input)

  child.cmd("silent edit " .. tmp)
  child.fn.setpos(".", { child.fn.bufnr "%", 4, 6, 0 })
  child.cmd "GoTagRm json"

  t.eq(t.readfile(tmp), fixtures.output)
end

return T
