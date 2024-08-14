local fixtures_dir = (vim.fn.expand "%:p:h") .. "/tests/fixtures/"

---@class gopher.TestUtil
local testutil = {}

---@return string
function testutil.tmp_file()
  return vim.fn.tempname() .. ".go"
end

---@param path string
---@return string
function testutil.readfile(path)
  return vim.fn.join(vim.fn.readfile(path), "\n")
end

---@param name string
---@return {input: string, output: string}
function testutil.read_fixture(name)
  return {
    input = testutil.readfile(fixtures_dir .. name .. "_input.go"),
    output = testutil.readfile(fixtures_dir .. name .. "_output.go"),
  }
end

function testutil.write_fixture(fpath, fixture)
  vim.fn.writefile(vim.split(fixture, "\n"), fpath)
end

function testutil.cleanup(testfile)
  vim.fn.delete(testfile)
  vim.cmd.bd(testfile)
end

return testutil
