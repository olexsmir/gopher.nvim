local t = require "spec.testutils"
local child, T = t.setup "alternate"

local function sibling(path)
  if path:find "_test%.go$" then
    return path:gsub("_test%.go$", ".go")
  else
    return path:gsub("%.go$", "_test.go")
  end
end

---Run <cmd> inside a tmp copy of fixture `name`.
---@param name string   "source" or "test"
---@param cmd  string   "GoAlt", "GoAltV", "GoAltS"
---@return table        rs from t.setup_test (for later cleanup)
---@return string       absolute sibling path
local function do_the_test(name, cmd)
  local rs = t.setup_test("alternate/" .. name, child, { 1, 1 })
  local alt = sibling(rs.tmp)

  os.remove(alt)
  child.cmd(cmd)
  child.cmd "write"

  return rs, alt
end

T["GoAlt"] = MiniTest.new_set {}
T["GoAltV"] = MiniTest.new_set {}
T["GoAltS"] = MiniTest.new_set {}

T["GoAlt"]["creates/opens sibling from source"] = function()
  local rs, alt = do_the_test("source", "GoAlt")

  t.eq(child.fn.expand "%:p", alt)
  t.eq(child.fn.filereadable(alt), 1)

  t.cleanup(rs)
  t.deletefile(alt)
end

T["GoAlt"]["toggles back when invoked on test file"] = function()
  local rs, src = do_the_test("test", "GoAlt")

  t.eq(child.fn.expand "%:p", src)
  t.eq(child.fn.filereadable(src), 1)

  t.cleanup(rs)
  t.deletefile(src)
end

T["GoAltV"]["opens sibling in vertical split"] = function()
  local rs, alt = do_the_test("source", "GoAltV")

  t.eq(#child.api.nvim_list_wins(), 2)
  t.eq(child.fn.expand "%:p", alt)

  t.cleanup(rs)
  t.deletefile(alt)
end

T["GoAltS"]["opens sibling in horizontal split"] = function()
  local rs, alt = do_the_test("source", "GoAltS")

  t.eq(#child.api.nvim_list_wins(), 2)
  t.eq(child.fn.expand "%:p", alt)

  t.cleanup(rs)
  t.deletefile(alt)
end

return T
