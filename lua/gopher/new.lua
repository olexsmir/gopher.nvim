local new = {}

function new.new()
  local ts = require "gopher._utils.ts"
  local u = require "gopher._utils"

  local bufnr = vim.api.nvim_get_current_buf()
  local st = ts.get_struct_fields_under_cursor(bufnr)
  if not st.struct then
    u.notify("GoNew: struct metadata is empty", vim.log.levels.WARN)
    return
  end

  if st.struct.is_varstruct then
    u.notify("GoNew: unsupported for var/inline structs", vim.log.levels.WARN)
    return
  end

  local fields = st.struct.fields or {}
  local args = {}
  local max_name_len = 0
  for _, field in ipairs(fields) do
    table.insert(args, field.name .. " " .. field.type)
    max_name_len = math.max(max_name_len, #field.name)
  end

  local tparam = st.struct.tparam or ""
  local type_args = (#(st.struct.type_args or {}) > 0)
      and ("[" .. table.concat(st.struct.type_args, ", ") .. "]")
    or ""
  local return_t = st.name .. type_args

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
