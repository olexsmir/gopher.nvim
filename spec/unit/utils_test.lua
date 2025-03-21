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

T["utils"] = MiniTest.new_set()
T["utils"]["should .remove_empty_lines()"] = function()
  local u = require "gopher._utils"
  local inp = { "hi", "", "a", "", "", "asdf" }

  t.eq(u.remove_empty_lines(inp), { "hi", "a", "asdf" })
end

T["utils"]["should .readfile_joined()"] = function()
  local data = "line1\nline2\nline3"
  local tmp = t.tmpfile()
  local u = require "gopher._utils"

  t.writefile(tmp, data)
  t.eq(u.readfile_joined(tmp), data)
end

return T
