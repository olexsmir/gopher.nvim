---@diagnostic disable: param-type-mismatch
local nodes = require "gopher._utils.ts.nodes"
local u = require "gopher._utils"
local ts = {
  queries = {
    struct_block = [[
((type_declaration
   (type_spec name: (type_identifier) @struct.name
              type: (struct_type))) @struct.declaration)
    ]],
    em_struct_block = [[
(field_declaration name: (field_identifier) @struct.name
                   type: (struct_type)) @struct.declaration
    ]],
    package = [[
(package_clause (package_identifier) @package.name) @package.clause
    ]],
    interface = [[
((type_declaration (type_spec name: (type_identifier) @interface.name
                              type: (interface_type))) @interface.declaration)
    ]],
    method_name = [[
((method_declaration receiver: (parameter_list) @method.receiver
                     name: (field_identifier) @method.name
                     body: (block)) @method.declaration)
    ]],
    func = [[
((function_declaration name: (identifier) @function.name) @function.declaration)
    ]],
  },
}

---@return table
local function get_name_defaults()
  return {
    ["func"] = "function",
    ["if"] = "if",
    ["else"] = "else",
    ["for"] = "for",
  }
end

---@param row string
---@param col string
---@param bufnr string|nil
---@param do_notify boolean|nil
---@return table|nil
function ts.get_struct_node_at_pos(row, col, bufnr, do_notify)
  local notify = do_notify or true
  local query = ts.queries.struct_block .. " " .. ts.queries.em_struct_block
  local bufn = bufnr or vim.api.nvim_get_current_buf()
  local ns = nodes.nodes_at_cursor(query, get_name_defaults(), bufn, row, col)
  if ns == nil then
    if notify then
      u.deferred_notify("struct not found", vim.log.levels.WARN)
    end
  else
    return ns[#ns]
  end
end

---@param row string
---@param col string
---@param bufnr string|nil
---@param do_notify boolean|nil
---@return table|nil
function ts.get_func_method_node_at_pos(row, col, bufnr, do_notify)
  local notify = do_notify or true
  local query = ts.queries.func .. " " .. ts.queries.method_name
  local bufn = bufnr or vim.api.nvim_get_current_buf()
  local ns = nodes.nodes_at_cursor(query, get_name_defaults(), bufn, row, col)
  if ns == nil then
    if notify then
      u.deferred_notify("function not found", vim.log.levels.WARN)
    end
  else
    return ns[#ns]
  end
end

---@param row string
---@param col string
---@param bufnr string|nil
---@param do_notify boolean|nil
---@return table|nil
function ts.get_package_node_at_pos(row, col, bufnr, do_notify)
  local notify = do_notify or true
  -- stylua: ignore
  if row > 10 then return end
  local query = ts.queries.package
  local bufn = bufnr or vim.api.nvim_get_current_buf()
  local ns = nodes.nodes_at_cursor(query, get_name_defaults(), bufn, row, col)
  if ns == nil then
    if notify then
      u.deferred_notify("package not found", vim.log.levels.WARN)
      return nil
    end
  else
    return ns[#ns]
  end
end

---@param row string
---@param col string
---@param bufnr string|nil
---@param do_notify boolean|nil
---@return table|nil
function ts.get_interface_node_at_pos(row, col, bufnr, do_notify)
  local notify = do_notify or true
  local query = ts.queries.interface
  local bufn = bufnr or vim.api.nvim_get_current_buf()
  local ns = nodes.nodes_at_cursor(query, get_name_defaults(), bufn, row, col)
  if ns == nil then
    if notify then
      u.deferred_notify("interface not found", vim.log.levels.WARN)
    end
  else
    return ns[#ns]
  end
end

return ts
