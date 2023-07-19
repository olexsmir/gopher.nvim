local tags = require "gopher.struct_tags"
local tests = require "gopher.gotests"
local uc = require "gopher._utils.commands"
local gopher = {}

gopher.setup = require("gopher.config").setup
gopher.install_deps = require "gopher.installer"
gopher.impl = require "gopher.impl"
gopher.iferr = require "gopher.iferr"
gopher.comment = require "gopher.comment"

gopher.tags_add = tags.add
gopher.tags_rm = tags.remove

gopher.test_add = tests.func_test
gopher.test_exported = tests.all_exported_tests
gopher.tests_all = tests.all_tests

gopher.get = function(...)
  uc("get", ...)
end

gopher.mod = function(...)
  uc("mod", ...)
end

gopher.generate = function(...)
  uc("generate", ...)
end

gopher.work = function(...)
  uc("work", ...)
end

return gopher
