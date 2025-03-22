local base_dir = vim.env.GOPHER_DIR or vim.fn.expand "%:p:h"

---@class gopher.TestUtils
local testutils = {}

testutils.mininit_path = vim.fs.joinpath(base_dir, "scripts", "minimal_init.lua")
testutils.fixtures_dir = vim.fs.joinpath(base_dir, "spec/fixtures")

---@return MiniTest.child, table
function testutils.setup()
  local child = MiniTest.new_child_neovim()
  local T = MiniTest.new_set {
    hooks = {
      post_once = child.stop,
      pre_case = function()
        child.restart { "-u", testutils.mininit_path }
      end,
    },
  }

  return child, T
end

---@generic T
---@param a T
---@param b T
---@return boolean
function testutils.eq(a, b)
  return MiniTest.expect.equality(a, b)
end

---@return string
function testutils.tmpfile()
  return vim.fn.tempname() .. ".go"
end

---@param path string
---@return string
function testutils.readfile(path)
  return vim.fn.join(vim.fn.readfile(path), "\n")
end

---@param fpath string
---@param contents string
function testutils.writefile(fpath, contents)
  vim.fn.writefile(vim.split(contents, "\n"), fpath)
end

---@param fpath string
function testutils.deletefile(fpath)
  vim.fn.delete(fpath)
end

---@class gopher.TestUtilsFixtures
---@field input string
---@field output string

---@param fixture string
---@return gopher.TestUtilsFixtures
function testutils.get_fixtures(fixture)
  return {
    input = testutils.readfile(vim.fs.joinpath(testutils.fixtures_dir, fixture) .. "_input.go"),
    output = testutils.readfile(vim.fs.joinpath(testutils.fixtures_dir, fixture) .. "_output.go"),
  }
end

---@class gopher.TestUtilsSetup
---@field tmp string
---@field fixtures gopher.TestUtilsFixtures

---@param fixture string
---@param child MiniTest.child
---@param pos? number[]
---@return gopher.TestUtilsSetup
function testutils.setup_test(fixture, child, pos)
  local tmp = testutils.tmpfile()
  local fixtures = testutils.get_fixtures(fixture)

  testutils.writefile(tmp, fixtures.input)
  child.cmd("silent edit " .. tmp)

  if pos then
    child.fn.setpos(".", { child.fn.bufnr(tmp), unpack(pos) })
  end

  return {
    tmp = tmp,
    fixtures = fixtures,
  }
end

---@param inp gopher.TestUtilsSetup
function testutils.cleanup(inp)
  testutils.deletefile(inp.tmp)
end

return testutils
