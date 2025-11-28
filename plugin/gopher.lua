---@toc_entry Commands
---@tag gopher.nvim-commands
---@text
--- If don't want to automatically register plugins' commands,
--- you can set `vim.g.gopher_register_commands` to `false`, before loading the plugin.

if vim.g.gopher_register_commands == false then
  return
end

---@param name string
---@param fn fun(args: table)
---@param nargs? number|"*"|"?"
---@param range? boolean
---@private
local function cmd(name, fn, nargs, range)
  vim.api.nvim_create_user_command(name, fn, {
    nargs = nargs or 0,
    range = range or false,
  })
end

cmd("GopherLog", function()
  vim.cmd("tabnew " .. require("gopher._utils.log").get_outfile())
end)

cmd("GoIfErr", function()
  require("gopher").iferr()
end)

cmd("GoCmt", function()
  require("gopher").comment()
end)

cmd("GoImpl", function(args)
  require("gopher").impl(unpack(args.fargs))
end, "*")

-- :GoInstall
cmd("GoInstallDeps", function()
  require("gopher").install_deps()
end)

cmd("GoInstallDepsSync", function()
  require("gopher").install_deps { sync = true }
end)

-- :GoTag
cmd("GoTagAdd", function(opts)
  require("gopher").tags.add {
    input = opts.fargs,
    range = (opts.count ~= -1) and {
      start = opts.line1,
      end_ = opts.line2,
    } or nil,
  }
end, "*", true)

cmd("GoTagRm", function(opts)
  require("gopher").tags.rm {
    input = opts.fargs,
    range = (opts.count ~= -1) and {
      start = opts.line1,
      end_ = opts.line2,
    } or nil,
  }
end, "*", true)

cmd("GoTagClear", function()
  require("gopher").tags.clear()
end)

-- :GoJson
cmd("GoJson", function(opts)
  require("gopher.json2go").json2go(opts.fargs[1])
end, "?")

-- :GoTest
cmd("GoTestAdd", function()
  require("gopher").test.add()
end)

cmd("GoTestsAll", function()
  require("gopher").test.all()
end)

cmd("GoTestsExp", function()
  require("gopher").test.exported()
end)

-- :Go
cmd("GoMod", function(opts)
  require("gopher").mod(opts.fargs)
end, "*")

cmd("GoGet", function(opts)
  require("gopher").get(opts.fargs)
end, "*")

cmd("GoWork", function(opts)
  require("gopher").get(opts.fargs)
end, "*")

cmd("GoGenerate", function(opts)
  require("gopher").generate(opts.fargs or { "" })
end, "?")
