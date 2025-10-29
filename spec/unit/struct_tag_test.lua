local t = require "spec.testutils"
local _, T, st = t.setup "struct_tags"

st["should parse tags"] = function()
  local out = require("gopher._utils.struct_tags").parse_args { "json", "yaml", "etc" }

  t.eq(out.tags, "json,yaml,etc")
  t.eq(out.options, "")
end

st["should parse tags separated by commas"] = function()
  local out = require("gopher._utils.struct_tags").parse_args { "json,yaml,etc" }

  t.eq(out.tags, "json,yaml,etc")
  t.eq(out.options, "")
end

st["should parse tags separated by command and spaces"] = function()
  local out = require("gopher.struct_tags").parse_args {
    "json,yaml",
    "json=omitempty",
    "xml=something",
  }

  t.eq(out.tags, "json,yaml,xml")
  t.eq(out.options, "json=omitempty,xml=something")
end

st["should parse tag with an option"] = function()
  local out = require("gopher._utils.struct_tags").parse_args {
    "json=omitempty",
    "xml",
    "xml=theoption",
  }

  t.eq(out.tags, "json,xml")
  t.eq(out.options, "json=omitempty,xml=theoption")
end

st["should parse tags with an option"] = function()
  local out = require("gopher._utils.struct_tags").parse_args { "json=omitempty", "yaml" }

  t.eq(out.tags, "json,yaml")
  t.eq(out.options, "json=omitempty")
end

st["should parse tags with an option separated with comma"] = function()
  local out = require("gopher._utils.struct_tags").parse_args { "json=omitempty,yaml" }

  t.eq(out.tags, "json,yaml")
  t.eq(out.options, "json=omitempty")
end

st["should parse tags with options specified separately"] = function()
  local out = require("gopher._utils.struct_tags").parse_args { "json", "yaml", "json=omitempty" }

  t.eq(out.tags, "json,yaml")
  t.eq(out.options, "json=omitempty")
end

st["should parse tags with options specified separately and separated by comma"] = function()
  local out = require("gopher._utils.struct_tags").parse_args { "json,yaml,json=omitempty" }

  t.eq(out.tags, "json,yaml")
  t.eq(out.options, "json=omitempty")
end

return T
