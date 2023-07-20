describe("gopher.config", function()
  it(".setup() should provide default when .setup() is not called", function()
    local c = require "gopher.config"

    assert.are.same(c.commands.go, "go")
    assert.are.same(c.commands.gomodifytags, "gomodifytags")
    assert.are.same(c.commands.gotests, "gotests")
    assert.are.same(c.commands.impl, "impl")
    assert.are.same(c.commands.iferr, "iferr")
    assert.are.same(c.commands.dlv, "dlv")
  end)

  it(".setup() should change options on users config", function()
    local c = require "gopher.config"
    c.setup {
      commands = {
        go = "go1.420",
        gomodifytags = "iDontUseRustBtw",
      },
    }

    assert.are.same(c.commands.go, "go1.420")
    assert.are.same(c.commands.gomodifytags, "iDontUseRustBtw")
    assert.are.same(c.commands.gotests, "gotests")
    assert.are.same(c.commands.impl, "impl")
    assert.are.same(c.commands.iferr, "iferr")
    assert.are.same(c.commands.dlv, "dlv")
  end)
end)
