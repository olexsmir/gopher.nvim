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

  describe(".sreq()", function()
    local sreq = require("gopher._utils").sreq

    it("return module if it exists", function()
      assert.are.same(sreq "gopher", require "gopher")
    end)

    it("throw error if it doesn't exist", function()
      assert.has.errors(function()
        sreq "no_existing_module"
      end)
    end)
  end)
end)
