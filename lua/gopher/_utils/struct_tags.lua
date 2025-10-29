---@param option string
local function option_to_tag(option)
  return option:match "^(.-)="
end

---@param args string[]
local function unwrap_if_needed(args)
  if #args == 1 then
    return vim.split(args[1], ",")
  end
  return args
end

local struct_tags = {}

---@class gopher.StructTagsArgs
---@field tags string
---@field options string

---@param args string[]
---@return gopher.StructTagsArgs
function struct_tags.parse_args(args)
  args = unwrap_if_needed(args)

  local tags, options = {}, {}
  for _, v in pairs(args) do
    if string.find(v, "=") then
      table.insert(options, v)
      table.insert(tags, option_to_tag(v))
    else
      table.insert(tags, v)
    end
  end

  -- todo: it's incompatible with vim lower 0.12
  tags = vim.list.unique(tags)
  options = vim.list.unique(options)
  return {
    tags = table.concat(tags, ","),
    options = table.concat(options, ","),
  }
end

return struct_tags
