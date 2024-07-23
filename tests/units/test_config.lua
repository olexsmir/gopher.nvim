local eq = MiniTest.expect.equality

describe("gopher.config", function()
  it(".setup() should provide default when .setup() is not called", function()
    local c = require "gopher.config"

    eq(c.commands.go, "go")
    eq(c.commands.gomodifytags, "gomodifytags")
    eq(c.commands.gotests, "gotests")
    eq(c.commands.impl, "impl")
    eq(c.commands.iferr, "iferr")
    eq(c.commands.dlv, "dlv")
  end)

  it(".setup() should change options on users config", function()
    local c = require "gopher.config"
    c.setup {
      commands = {
        go = "go1.420",
        gomodifytags = "iDontUseRustBtw",
      },
    }

    eq(c.commands.go, "go1.420")
    eq(c.commands.gomodifytags, "iDontUseRustBtw")
    eq(c.commands.gotests, "gotests")
    eq(c.commands.impl, "impl")
    eq(c.commands.iferr, "iferr")
    eq(c.commands.dlv, "dlv")
  end)
end)
