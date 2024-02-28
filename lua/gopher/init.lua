--- *gopher.nvim*
---
--- ==============================================================================
---
--- gopher.nvim is a minimalistic plugin for Go development in Neovim written in Lua.
--- It's not an LSP tool, the main goal of this plugin is add go tooling support in Neovim.

--- Table of Contents
---@tag gopher.nvim-table-of-contents
---@toc

local tags = require "gopher.struct_tags"
local tests = require "gopher.gotests"
local gocmd = require("gopher._utils.runner.gocmd").run
local gopher = {}

gopher.setup = require("gopher.config").setup
gopher.install_deps = require("gopher.installer").install_deps
gopher.impl = require("gopher.impl").impl
gopher.iferr = require("gopher.iferr").iferr
gopher.comment = require "gopher.comment"

gopher.tags = {
  add = tags.add,
  rm = tags.remove,
}

gopher.test = {
  add = tests.func_test,
  exported = tests.all_exported_tests,
  all = tests.all_tests,
}

gopher.get = function(...)
  gocmd("get", { ... })
end

gopher.mod = function(...)
  gocmd("mod", { ... })
end

gopher.generate = function(...)
  gocmd("generate", { ... })
end

gopher.work = function(...)
  gocmd("work", { ... })
end

return gopher
