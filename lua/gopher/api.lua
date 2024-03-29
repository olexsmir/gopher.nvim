local API = {}
local tags = require "gopher.struct_tags"
local tests = require "gopher.gotests"
local cmd = require "gopher._utils.commands"

API.install_deps = require "gopher.installer"
API.tags_add = tags.add
API.tags_rm = tags.remove
API.impl = require "gopher.impl"
API.iferr = require "gopher.iferr"
API.comment = require "gopher.comment"
API.test_add = tests.func_test
API.test_exported = tests.all_exported_tests
API.tests_all = tests.all_tests
API.gen_constructor = require "gopher.gen_constructor"

API.get = function(...)
  cmd("get", ...)
end
API.mod = function(...)
  cmd("mod", ...)
end
API.generate = function(...)
  cmd("generate", ...)
end
API.work = function(...)
  cmd("work", ...)
end

return API
