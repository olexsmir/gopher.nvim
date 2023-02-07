local stags = require "gopher.struct_tags"
local tests = require "gopher.gotests"
local cmd = require "gopher._utils.commands"
local gopher = {}

gopher.setup = require("gopher.config").setup
gopher.install_deps = require "gopher.installer"
gopher.tags_add = stags.add
gopher.tags_rm = stags.remove
gopher.impl = require "gopher.impl"
gopher.iferr = require "gopher.iferr"
gopher.comment = require "gopher.comment"
gopher.test_add = tests.func_test
gopher.test_exported = tests.all_exported_tests
gopher.tests_all = tests.all_tests
gopher.get = function(...)
  cmd("get", ...)
end
gopher.mod = function(...)
  cmd("mod", ...)
end
gopher.generate = function(...)
  cmd("generate", ...)
end
gopher.work = function(...)
  cmd("work", ...)
end

return gopher
