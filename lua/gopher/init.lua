--- *gopher.nvim*
---
--- ==============================================================================
---
--- gopher.nvim is a minimalistic plugin for Go development in Neovim written in Lua.
--- It's not an LSP tool, the main goal of this plugin is add go tooling support in Neovim.

--- Table of Contents
---@tag gopher.nvim-table-of-contents
---@toc

local log = require "gopher._utils.log"
local tags = require "gopher.struct_tags"
local tests = require "gopher.gotests"
local gocmd = require("gopher._utils.runner.gocmd").run
local gopher = {}

---@toc_entry Setup
---@tag gopher.nvim-setup
---@text Setup function. This method simply merges default configs with opts table.
--- You can read more about configuration at |gopher.nvim-config|
--- Calling this function is optional, if you ok with default settings. Look |gopher.nvim.config-defaults|
---
---@usage `require("gopher").setup {}` (replace `{}` with your `config` table)
gopher.setup = function(user_config)
  log.debug "setting up config"
  log.debug(vim.inspect(user_config))

  require("gopher.config").setup(user_config)
end

---@toc_entry Install dependencies
---@tag gopher.nvim-install-deps
---@text Gopher.nvim implements most of its features using third-party tools.
--- To  install these tools, you can run `:GoInstallDeps` command
--- or call `require("gopher").install_deps()` if you want ues lua api.
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
