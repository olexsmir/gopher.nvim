local u = require "gopher._utils"
local ts_utils = require "gopher._utils.ts.init"

return function(_)
  -- TODO: allow to pass a funcName as an argument

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local ns = ts_utils.get_struct_node_at_pos(row + 1, col + 1)
  if not ns then
    u.notify("not node found at cursor position", "error")
    return
  end

  local parameter_identifiers = {}
  if ns.struct_properties.parameters_node then
    for i in ns.struct_properties.parameters_node:iter_children() do
      if i:type() == "type_parameter_declaration" then
        for j in i:iter_children() do
          print("j: ", j:type())
          if j:type() == "identifier" then
            table.insert(parameter_identifiers, vim.treesitter.get_node_text(j, 1))
          end
        end
      end
    end
  end

  local args = {}
  local fields = {}
  for i in ns.struct_properties.fields_node:iter_children() do
    if i:type() == "field_declaration" then
      table.insert(args, vim.treesitter.get_node_text(i, 1))

      for j in i:iter_children() do
        if j:type() == "field_identifier" then
          local field_name = vim.treesitter.get_node_text(j, 1)
          table.insert(fields, field_name .. ": " .. field_name)
        end
      end
    end
  end

  local struct_type = ns.name
  local parameters_section = ""
  if #parameter_identifiers > 0 then
    struct_type = struct_type .. "[" .. table.concat(parameter_identifiers, ", ") .. "]"
    parameters_section = vim.treesitter.get_node_text(ns.struct_properties.parameters_node, 1)
  end

  local constructor_code = string.format(
    "\nfunc New%s%s(%s) *%s {\n\treturn &%s{%s}\n}\n",
    ns.name:gsub("^%l", string.upper),
    parameters_section,
    table.concat(args, ", "),
    struct_type,
    struct_type,
    table.concat(fields, ", ")
  )

  vim.fn.append(ns.declaring_node:end_() + 1, vim.split(constructor_code, "\n"))
end
