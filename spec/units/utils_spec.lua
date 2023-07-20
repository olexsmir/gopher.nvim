describe("gopher._utils", function()
  local u = require "gopher._utils"

  describe(".is_tbl_empty()", function()
    it("it is empty", function()
      assert.are.same(true, u.is_tbl_empty {})
    end)

    it("it is not empty", function()
      assert.are.same(false, u.is_tbl_empty { first = "1", second = 2 })
    end)
  end)

  describe(".sreq()", function()
    it("can require existing module", function()
      assert.are.same(require "gopher", u.sreq "gopher")
    end)

    it("cannot require non-existing module", function()
      assert.has.errors(function()
        u.sreq "iDontExistBtw"
      end)
    end)
  end)
end)
