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

local log = require "gopher._utils.log"
local tags = require "gopher.struct_tags"
local tests = require "gopher.gotests"
local gocmd = require("gopher._utils.gocmd").run
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
---@param user_config gopher.Config See |gopher.nvim-config|
gopher.setup = function(user_config)
  log.debug "setting up config"
  require("gopher.config").setup(user_config)
  log.debug(vim.inspect(user_config))
end

---@toc_entry Install dependencies
---@tag gopher.nvim-dependencies
---@text Gopher.nvim implements most of its features using third-party tools.
--- To install these tools, you can run `:GoInstallDeps` command
--- or call `require("gopher").install_deps()` if you want to use lua api.
--- By default dependencies will be installed asynchronously,
--- to install them synchronously pass `{sync = true}` as an argument.
gopher.install_deps = require("gopher.installer").install_deps

gopher.impl = require("gopher.impl").impl
gopher.iferr = require("gopher.iferr").iferr
gopher.comment = require("gopher.comment").comment

gopher.tags = {
  add = tags.add,
  rm = tags.remove,
  clear = tags.clear,
}

gopher.test = {
  add = tests.func_test,
  exported = tests.all_exported_tests,
  all = tests.all_tests,
}

gopher.get = function(...)
  gocmd("get", ...)
end

gopher.mod = function(...)
  gocmd("mod", ...)
end

gopher.generate = function(...)
  gocmd("generate", ...)
end

gopher.work = function(...)
  gocmd("work", ...)
end

return gopher
