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
T["iferr"] = MiniTest.new_set {}
T["iferr"]["works"] = function()
  local tmp = t.tmpfile()
  local fixtures = t.get_fixtures "iferr/iferr"
  t.writefile(tmp, fixtures.input)

  child.cmd("silent edit " .. tmp)
  child.fn.setpos(".", { child.fn.bufnr "%", 8, 2, 0 })
  child.cmd "GoIfErr"
  child.cmd "write"

  t.eq(t.readfile(tmp), fixtures.output)
end

T["iferr"]["works with custom message"] = function()
  local tmp = t.tmpfile()
  local fixtures = t.get_fixtures "iferr/message"
  t.writefile(tmp, fixtures.input)

  child.lua [[ require("gopher").setup { iferr = { message = 'fmt.Errorf("failed to %w", err)' } } ]]
  child.cmd("silent edit " .. tmp)
  child.fn.setpos(".", { child.fn.bufnr "%", 6, 2, 0 })
  child.cmd "GoIfErr"
  child.cmd "write"

  t.eq(t.readfile(tmp), fixtures.output)
end

return T
