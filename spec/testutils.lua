-- NOTE: there's a probably a better way to do this
local fixtures_dir = (vim.fn.expand "%:p:h") .. "/spec/fixtures/"

---@class gopher.TestUtils
local testutils = {}

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

testutils.fixtures = {}

---@param fixture string
---@return {input: string, output: string}
function testutils.fixtures.read(fixture)
  return {
    input = testutils.readfile(fixtures_dir .. fixture .. "_input.go"),
    output = testutils.readfile(fixtures_dir .. fixture .. "_output.go"),
  }
end

---@param fpath string
---@param fixture string
function testutils.fixtures.write(fpath, fixture)
  vim.fn.writefile(vim.split(fixture, "\n"), fpath)
end

return testutils
