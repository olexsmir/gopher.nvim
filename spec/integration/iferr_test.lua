local t = require "spec.testutils"
local child, T = t.setup "iferr"

T["iferr"]["should add if != nil {"] = function()
  local rs = t.setup_test("iferr/iferr", child, { 8, 2 })
  child.cmd "GoIfErr"
  child.cmd "write"

  t.eq(t.readfile(rs.tmp), rs.fixtures.output)
  t.cleanup(rs)
end

T["iferr"]["should add if err with custom message"] = function()
  child.lua [[
    require("gopher").setup {
      iferr = { message = 'fmt.Errorf("failed to %w", err)' }
  } ]]

  local rs = t.setup_test("iferr/message", child, { 6, 2 })
  child.cmd "GoIfErr"
  child.cmd "write"

  t.eq(t.readfile(rs.tmp), rs.fixtures.output)
  t.cleanup(rs)
end

return T
