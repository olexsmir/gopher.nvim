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
  local rs = t.setup("iferr/iferr", child, { 8, 2 })
  child.cmd "GoIfErr"
  child.cmd "write"

  t.eq(t.readfile(rs.tmp), rs.fixtures.output)
end

T["iferr"]["works with custom message"] = function()
  child.lua [[
    require("gopher").setup {
      iferr = { message = 'fmt.Errorf("failed to %w", err)' }
  } ]]

  local rs = t.setup("iferr/message", child, { 6, 2 })
  child.cmd "GoIfErr"
  child.cmd "write"

  t.eq(t.readfile(rs.tmp), rs.fixtures.output)
end

return T
