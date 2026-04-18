local new = {}

--- AI: this should be a part of treesitter query for getting struct
---
---@param tparam? string
---@return string
local function get_type_args(tparam)
  if not tparam or tparam == "" then
    return ""
  end

  local body = tparam:match "^%[(.*)%]$"
  if not body then
    return ""
  end

  local args = {}
  for chunk in body:gmatch "[^,]+" do
    local name = vim.trim(chunk):match "^([%a_][%w_]*)"
    if name then
      table.insert(args, name)
    end
  end

  return (#args > 0) and ("[" .. table.concat(args, ", ") .. "]") or ""
end

function new.new()
  local ts = require "gopher._utils.ts"
  local u = require "gopher._utils"

  local bufnr = vim.api.nvim_get_current_buf()

  -- AI: again ts.get_* should not contain any logic
  local st = ts.get_struct_field_under_cursor(bufnr, { from_struct = true })

  -- AI: in case st.struct is empty it should thrown a warn and exit
  local struct = st.struct or {}

  if struct.is_varstruct then
    u.notify("GoNew: unsupported for var/inline structs", vim.log.levels.WARN)
    return
  end

  local fields = struct.fields or {}
  local args = {}
  local max_name_len = 0
  for _, field in ipairs(fields) do
    table.insert(args, field.name .. " " .. field.type)
    max_name_len = math.max(max_name_len, #field.name)
  end

  local tparam = struct.tparam or ""
  vim.print("get some T", tparam)
  local return_t = st.name .. get_type_args(tparam)

  local out = {
    "",
    string.format("func New%s%s(%s) %s {", st.name, tparam, table.concat(args, ", "), return_t),
  }

  if #fields == 0 then
    table.insert(out, "\treturn " .. return_t .. "{}")
  else
    table.insert(out, "\treturn " .. return_t .. "{")
    for _, field in ipairs(fields) do
      table.insert(
        out,
        string.format(
          "\t\t%s:%s%s,",
          field.name,
          string.rep(" ", max_name_len - #field.name + 1),
          field.name
        )
      )
    end
    table.insert(out, "\t}")
  end

  table.insert(out, "}")
  vim.fn.append(st.end_, out)
end

return new
