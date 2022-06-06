local tags = require "gopher.struct_tags"
local gopher = {}

gopher.install_deps = require("gopher.installer").install_all
gopher.tags_add = tags.add
gopher.tags_rm = tags.remove
gopher.mod = require "gopher.gomod"
gopher.get = require "gopher.goget"

return gopher
