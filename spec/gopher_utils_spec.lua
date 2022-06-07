describe("gopher._utils", function()
  it("can be requried", function()
    require "gopher._utils"
  end)

  it(".empty() with non-empty talbe", function()
    local empty = require("gopher._utils").empty
    local res = empty { first = "1", second = 2 }

    assert.are.same(res, false)
  end)

  it(".empty() with empty talbe", function()
    local empty = require("gopher._utils").empty
    local res = empty {}

    assert.are.same(res, true)
  end)
end)
