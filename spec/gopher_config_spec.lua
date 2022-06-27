describe("gopher.config", function()
  it("can be required", function()
    require "gopher.config"
  end)

  it(".setup() when gets empty table not edit config", function()
    local c = require "gopher.config"
    c.setup {}

    assert.are.same(c.config.commands.go, "go")
    assert.are.same(c.config.commands.gomodifytags, "gomodifytags")
    assert.are.same(c.config.commands.gotests, "gotests")
    assert.are.same(c.config.commands.impl, "impl")
  end)

  it(".setup() when get one custom value sets that", function()
    local c = require "gopher.config"
    c.setup { commands = {
      go = "custom_go",
    } }

    assert.are.same(c.config.commands.go, "custom_go")
  end)

  it(".setup() when get all custom values sets it", function()
    local c = require "gopher.config"
    c.setup {
      commands = {
        go = "go1.18",
        gomodifytags = "user-gomodifytags",
        gotests = "gotests",
        impl = "goimpl",
      },
    }

    assert.are.same(c.config.commands.go, "go1.18")
    assert.are.same(c.config.commands.gomodifytags, "user-gomodifytags")
    assert.are.same(c.config.commands.gotests, "gotests")
    assert.are.same(c.config.commands.impl, "goimpl")
  end)
end)
