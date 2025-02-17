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
T["iferr"] = MiniTest.new_set {}
T["iferr"]["works"] = function()
  local tmp = vim.env.HOME .. "/test.go"

  local fixtures = t.fixtures.read "iferr/iferr"
  t.fixtures.write(tmp, fixtures.input)

  child.cmd("silent edit " .. tmp)
  child.fn.setpos(".", { child.fn.bufnr "%", 8, 2, 0 })
  child.cmd "GoIfErr"
  child.cmd "write"

  t.eq(t.readfile(tmp), fixtures.output)
end

return T
