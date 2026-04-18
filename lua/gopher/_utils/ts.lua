local ts = {}
local queries = {
  struct = [[
    [(type_spec
       name: (type_identifier) @_name
       type_parameters: (type_parameter_list
                          (type_parameter_declaration (identifier) @_targ)*)? @_tparam
       type: (struct_type))
      (var_declaration (var_spec
                        name: (identifier) @_name @_var
                        type: (struct_type)))
      (var_declaration (var_spec
                        (identifier) @_name @_var
                        (expression_list (composite_literal
                                          type: (struct_type)))))
      (short_var_declaration
        left:  (expression_list (identifier) @_name @_var)
        right: (expression_list (composite_literal
                                 type: (struct_type))))
      (field_declaration
        name: (field_identifier) @_field_name
        type: (_) @_field_type)]
  ]],
  struct_field = [[
    (field_declaration name: (field_identifier) @_name)
  ]],
  func = [[
    [(function_declaration name: (identifier)       @_name)
     (method_declaration   name: (field_identifier) @_name)
     (method_elem          name: (field_identifier) @_name)]
  ]],
  package = [[
    (package_identifier) @_name
  ]],
  interface = [[
    (type_spec
      name: (type_identifier) @_name
      type: (interface_type))
  ]],
  var = [[
    [(var_declaration (var_spec name: (identifier) @_name))
     (short_var_declaration
       left: (expression_list (identifier) @_name @_var))]
  ]],
}

---@param parent_type string[]
---@param node TSNode
---@return TSNode?
local function get_parent_node(parent_type, node)
  ---@type TSNode?
  local current = node
  while current do
    if vim.tbl_contains(parent_type, current:type()) then
      break
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
---@return gopher.TsResult
local function get_captures(query, node, bufnr)
  local res = {}
  local field_names, field_types = {}, {}
  for id, _node in query:iter_captures(node, bufnr) do
    if query.captures[id] == "_name" then
      res["name"] = vim.treesitter.get_node_text(_node, bufnr)
    end

    if query.captures[id] == "_var" then
      res["is_varstruct"] = true
    end

    if query.captures[id] == "_tparam" then
      res["tparams"] = res["tparams"] or { decl = nil, args = {} }
      res["tparams"]["decl"] = vim.treesitter.get_node_text(_node, bufnr)
    end

    if query.captures[id] == "_targ" then
      res["tparams"] = res["tparams"] or { decl = nil, args = {} }
      table.insert(res["tparams"]["args"], vim.treesitter.get_node_text(_node, bufnr))
    end

    if query.captures[id] == "_field_name" then
      table.insert(field_names, vim.treesitter.get_node_text(_node, bufnr))
    end

    if query.captures[id] == "_field_type" then
      table.insert(field_types, vim.treesitter.get_node_text(_node, bufnr))
    end
  end

  res["fields"] = {}
  for i, name in ipairs(field_names) do
    res["fields"][i] = { name, field_types[i] }
  end

  return res
end

---@class gopher.TsResult
---@field name string Name of the struct, function, etc
---@field start integer Line number where the declaration starts
---@field end_ integer Line number where the declaration ends
---@field indent integer Number of spaces/tabs in the current cursor line
---@field is_varstruct? boolean `true` for inline/var structs (`var x struct{}` / `x := struct{}{}`)
---@field tparams? {decl:string?, args:string[]} Struct generic metadata (`decl` and identifier `args`)
---@field fields table[] Parsed named struct fields as `{ {name, type}, ... }`

---@param bufnr integer
---@param parent_type string[]
---@param query string
---@return gopher.TsResult
local function do_stuff(bufnr, parent_type, query)
  if not vim.treesitter.get_parser(bufnr, "go") then
    error "No treesitter parser found for go"
  end

  local node = vim.treesitter.get_node { bufnr = bufnr }
  if not node then
    error "No nodes found under the cursor"
  end

  local parent_node = get_parent_node(parent_type, node)
  if not parent_node then
    error "No parent node found under the cursor"
  end

  local q = vim.treesitter.query.parse("go", query)
  local res = get_captures(q, parent_node, bufnr)
  assert(res.name ~= nil, "No capture name found")

  local start_row, start_col, end_row, _ = parent_node:range()
  res["indent"] = start_col
  res["start"] = start_row + 1
  res["end_"] = end_row + 1

  return res
end

---@param bufnr integer
function ts.get_struct_under_cursor(bufnr)
  --- should be both type_spec and type_declaration
  --- because in cases like `type ( T struct{}, U struct{} )`
  ---
  --- var_declaration is for cases like `var x struct{}`
  --- short_var_declaration is for cases like `x := struct{}{}`
  ---
  --- it always chooses last struct type in the list
  return do_stuff(bufnr, {
    "type_spec",
    "type_declaration",
    "var_declaration",
    "short_var_declaration",
  }, queries.struct)
end

---@param bufnr integer
function ts.get_struct_field_under_cursor(bufnr)
  return do_stuff(bufnr, { "field_declaration" }, queries.struct_field)
end

---@param bufnr integer
function ts.get_func_under_cursor(bufnr)
  --- since this handles both and funcs and methods we should check for both parent nodes
  return do_stuff(bufnr, {
    "method_elem",
    "function_declaration",
    "method_declaration",
  }, queries.func)
end

---@param bufnr integer
function ts.get_package_under_cursor(bufnr)
  return do_stuff(bufnr, { "package_clause" }, queries.package)
end

---@param bufnr integer
function ts.get_interface_under_cursor(bufnr)
  return do_stuff(bufnr, { "type_declaration" }, queries.interface)
end

---@param bufnr integer
function ts.get_variable_under_cursor(bufnr)
  return do_stuff(bufnr, { "var_declaration", "short_var_declaration" }, queries.var)
end

return ts
