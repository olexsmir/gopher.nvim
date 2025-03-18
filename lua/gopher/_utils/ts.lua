local ts = {}
local queries = {
  struct = [[
    (type_spec name: (type_identifier) @_name
               type: (struct_type))
  ]],
  func = [[
    [(function_declaration name: (identifier)       @_name)
     (method_declaration   name: (field_identifier) @_name)]
  ]],
  package = [[
    ((package_clause
      (package_identifier)) @_name)
  ]],
  interface = [[
    (type_spec
      name: (type_identifier) @_name
      type: (interface_type))
  ]],
}

---@param parent_type string|[string]
---@param node TSNode
---@return TSNode?
local function get_parrent_node(parent_type, node)
  ---@type TSNode?
  local current = node
  while current do
    if type(parent_type) == "string" then
      if current:type() == parent_type then
        break
      end
    elseif type(parent_type) == "table" then
      if vim.tbl_contains(parent_type, current:type()) then
        break
      end
    end

    current = current:parent()
    if current == nil then
      return nil
    end
  end
  return current
end

---@param query vim.treesitter.Query
---@param node TSNode
---@param bufnr integer
---@return {name:string}
local function get_captures(query, node, bufnr)
  local res = {}
  for _, match, _ in query:iter_matches(node, bufnr) do
    for capture_id, captured_node in pairs(match) do
      local capture_name = query.captures[capture_id]
      if capture_name == "_name" then
        res["name"] = vim.treesitter.get_node_text(captured_node, bufnr)
      end
    end
  end

  return res
end

---@class gopher.TsResult
---@field name string
---@field start_line integer
---@field end_line integer

---@param bufnr integer
---@param parent_type string|[string]
---@param query string
---@return gopher.TsResult
local function do_stuff(bufnr, parent_type, query)
  local node = vim.treesitter.get_node()
  if not node then
    error "No nodes found under cursor"
  end

  local parent_node = get_parrent_node(parent_type, node)
  if not parent_node then
    error "No struct found under cursor"
  end

  local q = vim.treesitter.query.parse("go", query)
  local res = get_captures(q, parent_node, bufnr)

  local start_row, _, end_row, _ = parent_node:range()
  res["start_line"] = start_row + 1
  res["end_line"] = end_row + 1

  return res
end

---@param bufnr integer
---@return table
function ts.get_struct_under_cursor(bufnr)
  --- should be both type_spec and type_declaration
  --- because in cases like `type ( T struct{}, U strict{} )`
  --- i will be choosing always last struct in the list
  return do_stuff(bufnr, { "type_spec", "type_declaration" }, queries.struct)
end

---@param bufnr integer
function ts.get_func_under_cursor(bufnr)
  return do_stuff(bufnr, { "function_declaration", "method_declaration" }, queries.func)
end

---@param bufnr integer
function ts.get_package_under_cursor(bufnr)
  return do_stuff(bufnr, "package_clause", queries.package)
end

---@param bufnr integer
function ts.get_interface_inder_cursor(bufnr)
  return do_stuff(bufnr, "type_declaration", queries.interface)
end

return ts
