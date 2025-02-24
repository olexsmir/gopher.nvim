local base_dir = vim.env.GOPHER_DIR or vim.fn.expand "%:p:h"
local fixtures_dir = vim.fs.joinpath(base_dir, "/spec/fixtures/")

---@class gopher.TestUtils
local testutils = {}

testutils.mininit_path = vim.fs.joinpath(base_dir, "/scripts/minimal_init.lua")

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

---@param path string
---@return string
function testutils.readfile_from_fixture_dir(path)
  return testutils.readfile(fixtures_dir .. path)
end

---@param fixture string
---@return {input: string, output: string}
function testutils.get_fixtures(fixture)
  return {
    input = testutils.readfile_from_fixture_dir(fixture .. "_input.go"),
    output = testutils.readfile_from_fixture_dir(fixture .. "_output.go"),
  }
end

return testutils
