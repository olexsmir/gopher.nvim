---@toc_entry Generate constructors for structs
---@tag gopher.nvim-new
---@text
--- Generate constructors for structs
---
---@usage
--- 1. Place your cursor on struct name.
--- 2. Run `:GoNew` or `require("gopher.new").new()` if you prefer lua api.
---

local new = {}

local function to_camel_case(str)
  if #str == 0 then
    return str
  end
  return string.lower(string.sub(str, 1, 1)) .. string.sub(str, 2)
end

-- Generate constructors for structs
function new.new()
  local ts = require "gopher._utils.ts"
  local u = require "gopher._utils"

  local bufnr = vim.api.nvim_get_current_buf()
  local st = ts.get_struct_under_cursor(bufnr)

  if st.is_varstruct then
    u.notify("GoNew: unsupported for var/inline structs", vim.log.levels.WARN)
    return
  end

  local fields = st.fields or {}
  local args = {}
  local max_name_len = 0
  for _, field in ipairs(fields) do
    local field_name, field_type = field[1], field[2]
    local param_name = to_camel_case(field_name)
    table.insert(args, param_name .. " " .. field_type)
    max_name_len = math.max(max_name_len, #param_name)
  end

  local tparams = st.tparams or { decl = "", args = {} }
  local type_args = (#(tparams.args or {}) > 0) and ("[" .. table.concat(tparams.args, ", ") .. "]")
    or ""
  local return_t = st.name .. type_args

  local out = {
    "",
    string.format(
      "func New%s%s(%s) %s {",
      st.name,
      tparams.decl or "",
      table.concat(args, ", "),
      return_t
    ),
  }

  if #fields == 0 then
    table.insert(out, "\treturn " .. return_t .. "{}")
  else
    table.insert(out, "\treturn " .. return_t .. "{")
    for _, field in ipairs(fields) do
      local field_name = field[1]
      local param_name = to_camel_case(field_name)
      table.insert(
        out,
        string.format(
          "\t\t%s:%s%s,",
          field_name,
          string.rep(" ", max_name_len - #param_name + 1),
          param_name
        )
      )
    end
    table.insert(out, "\t}")
  end

  table.insert(out, "}")
  vim.fn.append(st.end_, out)
end

return new
