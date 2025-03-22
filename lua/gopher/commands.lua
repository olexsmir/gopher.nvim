local commands = {}

function commands.register()
  vim.api.nvim_create_user_command("GopherLog", function()
    vim.cmd("tabnew " .. require("gopher._utils.log").get_outfile())
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("GoIfErr", function()
    require("gopher").iferr()
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("GoCmt", function()
    require("gopher").comment()
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("GoImpl", function(args)
    require("gopher").impl(unpack(args.fargs))
  end, { nargs = "*" })

  -- :GoInstall
  vim.api.nvim_create_user_command("GoInstallDeps", function()
    require("gopher").install_deps()
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("GoInstallDepsSync", function()
    require("gopher").install_deps { sync = true }
  end, { nargs = 0 })

  --- :GoTag
  vim.api.nvim_create_user_command("GoTagAdd", function(opts)
    require("gopher").tags.add(unpack(opts.fargs))
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("GoTagRm", function(opts)
    require("gopher").tags.rm(unpack(opts.fargs))
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("GoTagClear", function()
    require("gopher").tags.clear()
  end, { nargs = 0 })

  --- :GoTest
  vim.api.nvim_create_user_command("GoTestAdd", function()
    require("gopher").test.add()
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("GoTestsAll", function()
    require("gopher").test.all()
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("GoTestsExp", function()
    require("gopher").test.exported()
  end, { nargs = 0 })

  -- :Go
  vim.api.nvim_create_user_command("GoMod", function(opts)
    require("gopher").mod(opts.fargs)
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("GoGet", function(opts)
    vim.print(opts)
    require("gopher").get(opts.fargs)
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("GoWork", function(opts)
    require("gopher").get(opts.fargs)
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("GoGenerate", function(opts)
    require("gopher").generate(opts.fargs or "")
  end, { nargs = "?" })
end

return commands
