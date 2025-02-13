describe("gopher._utils", function()
  local u = require "gopher._utils"

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
