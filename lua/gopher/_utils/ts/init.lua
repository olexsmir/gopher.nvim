local nodes = require "gopher._utils.ts.nodes"
local u = require "gopher._utils"
local M = {
  querys = {
    struct_block = [[((type_declaration (type_spec name:(type_identifier) @struct.name type: (struct_type)))@struct.declaration)]],
    em_struct_block = [[(field_declaration name:(field_identifier)@struct.name type: (struct_type)) @struct.declaration]],
    method_name = [[((method_declaration receiver: (parameter_list)@method.receiver name: (field_identifier)@method.name body:(block))@method.declaration)]],
    func = [[((function_declaration name: (identifier)@function.name) @function.declaration)]],
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
---@param bufnr string
---@return table|nil
function M.get_struct_node_at_pos(row, col, bufnr)
  local query = M.querys.struct_block .. " " .. M.querys.em_struct_block
  local bufn = bufnr or vim.api.nvim_get_current_buf()
  local ns = nodes.nodes_at_cursor(query, get_name_defaults(), bufn, row, col)
  if ns == nil then
    u.notify("struct not found", "warn")
  else
    return ns[#ns]
  end
end

---@param row string
---@param col string
---@param bufnr string
---@return table|nil
function M.get_func_method_node_at_pos(row, col, bufnr)
  local query = M.querys.func .. " " .. M.querys.method_name
  local bufn = bufnr or vim.api.nvim_get_current_buf()
  local ns = nodes.nodes_at_cursor(query, get_name_defaults(), bufn, row, col)
  if ns == nil then
    u.notify("function not found", "warn")
  else
    return ns[#ns]
  end
end

return M
