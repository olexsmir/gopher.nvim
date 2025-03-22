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
T["gotests"] = MiniTest.new_set {}

--- NOTE: :GoTestAdd is the only place that has actual logic
--- All other parts are handled `gotests` itself.

---@param fpath string
---@return string
local function read_testfile(fpath)
  return t.readfile(fpath:gsub(".go", "_test.go"))
end

T["gotests"]["should add test for function under cursor"] = function()
  local rs = t.setup("tests/function", child, { 3, 5 })
  child.cmd "GoTestAdd"

  t.eq(rs.fixtures.output, read_testfile(rs.tmp))
  t.cleanup(rs)
end

T["gotests"]["should add test for method under cursor"] = function()
  local rs = t.setup("tests/method", child, { 5, 19 })
  child.cmd "GoTestAdd"

  t.eq(rs.fixtures.output, read_testfile(rs.tmp))
  t.cleanup(rs)
end

return T
