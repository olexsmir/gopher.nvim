describe("gopher._utils", function()
  describe(".empty()", function()
    local empty = require("gopher._utils").empty

    it("with non-empty talbe", function()
      local res = empty { first = "1", second = 2 }
      assert.are.same(res, false)
    end)

    it("with empty talbe", function()
      local res = empty {}
      assert.are.same(res, true)
    end)
  end)
end)
