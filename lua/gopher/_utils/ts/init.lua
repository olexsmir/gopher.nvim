local ts = {
  queries = {
    struct = [[
(type_spec name: (type_identifier) @_name
           type: (struct_type))
    ]],

    -- struct_block = [[((type_declaration (type_spec name:(type_identifier) @struct.name type: (struct_type)))@struct.declaration)]],
    -- package = [[(package_clause (package_identifier)@package.name)@package.clause]],
    -- interface = [[((type_declaration (type_spec name:(type_identifier) @interface.name type:(interface_type)))@interface.declaration)]],
    -- method_name = [[((method_declaration receiver: (parameter_list)@method.receiver name: (field_identifier)@method.name body:(block))@method.declaration)]],
    -- func = [[((function_declaration name: (identifier)@function.name) @function.declaration)]],
  },
}

---@param parent_type string
---@param node TSNode
---@return TSNode?
local function get_parrent_node(parent_type, node)
  ---@type TSNode?
  local current = node
  while current do
    if current:type() == parent_type then
      break
    end

    current = current:parent()
    if current == nil then
      return nil
    end
  end
  return current
end

---@param bufnr string
---@return table|nil
function ts.get_struct_node_at_pos(bufnr)
  vim.validate {
    bufnr = { bufnr, "number" },
  }

  local node = vim.treesitter.get_node()
  if not node then
    error "No nodes found under cursor"
  end

  local res = {}
  local r = get_parrent_node("type_spec", node)
  if not r then
    error "No struct found under cursor"
  end

  local start_row, _, end_row, _ = r:range()
  res["start_line"] = start_row + 1
  res["end_line"] = end_row + 1

  local query = vim.treesitter.query.parse("go", ts.queries.struct)
  for _, match, _ in query:iter_matches(r, bufnr) do
    for capture_id, captured_node in pairs(match) do
      local capture_name = query.captures[capture_id]
      if capture_name == "_name" then
        res["name"] = vim.treesitter.get_node_text(captured_node, bufnr)
      end
    end
  end

  return res
end

return ts
