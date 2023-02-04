describe("unit.gopher.config", function()
  it("can be required", function()
    require "gopher.config"
  end)

  describe(".setup()", function()
    local c = require "gopher.config"

    it("returns defaults when gets empty table", function()
      c.setup {}
      assert.are.same(c.config.commands.go, "go")
      assert.are.same(c.config.commands.gomodifytags, "gomodifytags")
      assert.are.same(c.config.commands.gotests, "gotests")
      assert.are.same(c.config.commands.impl, "impl")
    end)

    it("can set user opts", function()
      c.setup { commands = { go = "custom_go" } }
      assert.are.same(c.config.commands.go, "custom_go")
    end)
  end)
end)
