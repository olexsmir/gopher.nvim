--- *gopher.nvim* Enhance your golang experience
---
--- MIT License Copyright (c) 2025 Oleksandr Smirnov
---
--- ==============================================================================
---
--- gopher.nvim is a minimalistic plugin for Go development in Neovim written in Lua.
--- It's not an LSP tool, the main goal of this plugin is add go tooling support in Neovim.
---
--- Table of Contents
---@toc

local gopher = {}

---@toc_entry Setup
---@tag gopher.nvim-setup()
---@text Setup function. This method simply merges default config with opts table.
--- You can read more about configuration at |gopher.nvim-config|
--- Calling this function is optional, if you ok with default settings.
--- See |gopher.nvim.config|
---
---@usage >lua
---  require("gopher").setup {} -- use default config or replace {} with your own
--- <
---@param user_config? gopher.Config See |gopher.nvim-config|
gopher.setup = function(user_config)
  require("gopher.config").setup(user_config)
end

---@toc_entry Install dependencies
---@tag gopher.nvim-dependencies
---@text
--- Gopher.nvim implements most of its features using third-party tools.
---
---@usage
--- To install plugin's dependencies, you can run:
--- `:GoInstallDeps` or `:GoInstallDepsSync`
--- or use `require("gopher").install_deps()` if you prefer lua api.
---
---@param opts? {sync:boolean}
gopher.install_deps = function(opts)
  return require("gopher.installer").install_deps(opts)
end

---@dochide
gopher.impl = function(...)
  return require("gopher.impl").impl(...)
end

---@dochide
---@param message? string Optional custom error message to use instead of config default
gopher.iferr = function(message)
  return require("gopher.iferr").iferr(message)
end

---@dochide
gopher.comment = function()
  return require("gopher.comment").comment()
end

---@dochide
gopher.tags = {
  ---@param opts gopher.StructTagInput
  add = function(opts)
    return require("gopher.struct_tags").add(opts)
  end,
  ---@param opts gopher.StructTagInput
  rm = function(opts)
    return require("gopher.struct_tags").remove(opts)
  end,
  clear = function()
    return require("gopher.struct_tags").clear()
  end,
}

---@dochide
gopher.test = {
  add = function()
    return require("gopher.gotests").func_test()
  end,
  exported = function()
    return require("gopher.gotests").all_exported_tests()
  end,
  all = function()
    return require("gopher.gotests").all_tests()
  end,
}

---@dochide
---@param args string[]
gopher.get = function(args)
  return require("gopher.go").get(args)
end

---@dochide
---@param args string[]
gopher.mod = function(args)
  return require("gopher.go").mod(args)
end

---@dochide
---@param args string[]
gopher.work = function(args)
  return require("gopher.go").work(args)
end

---@dochide
---@param args string[]
gopher.generate = function(args)
  return require("gopher.go").generate(args)
end

return gopher
