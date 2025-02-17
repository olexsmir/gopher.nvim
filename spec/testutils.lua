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

-- TODO: continue with writing fixtures helpers
-- https://github.com/olexsmir/gopher.nvim/pull/71/files

return testutils
