local tags = require "gopher.struct_tags"
local gotests = require "gopher.gotests"
local gopher = {}

gopher.install_deps = require "gopher.installer"
gopher.tags_add = tags.add
gopher.tags_rm = tags.remove
gopher.mod = require "gopher.gomod"
gopher.get = require "gopher.goget"
gopher.impl = require "gopher.impl"
gopher.generate = require "gopher.gogenerate"
gopher.iferr = require "gopher.iferr"
gopher.comment = require "gopher.comment"
gopher.test_add = gotests.func_test
gopher.test_exported = gotests.all_exported_tests
gopher.tests_all = gotests.all_tests
gopher.setup = require("gopher.config").setup

return gopher
