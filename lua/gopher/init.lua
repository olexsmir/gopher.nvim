local tags = require "gopher.struct_tags"
local gopher = {}

gopher.install_deps = require "gopher.installer"
gopher.tags_add = tags.add
gopher.tags_rm = tags.remove
gopher.mod = require "gopher.gomod"
gopher.get = require "gopher.goget"
gopher.impl = require "gopher.impl"
gopher.generate = require "gopher.gogenerate"

return gopher
