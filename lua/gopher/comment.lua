local function generate(row, col)
  local ts_utils = require "gopher._utils.ts"
  local comment, ns = nil, nil

  ns = ts_utils.get_package_node_at_pos(row, col, nil, false)
  if ns ~= nil then
    comment = "// Package " .. ns.name .. " provides " .. ns.name
    return comment, ns
  end

  ns = ts_utils.get_struct_node_at_pos(row, col, nil, false)
  if ns ~= nil then
    comment = "// " .. ns.name .. " " .. ns.type .. " "
    return comment, ns
  end

  ns = ts_utils.get_func_method_node_at_pos(row, col, nil, false)
  if ns ~= nil then
    comment = "// " .. ns.name .. " " .. ns.type .. " "
    return comment, ns
  end

  ns = ts_utils.get_interface_node_at_pos(row, col, nil, false)
  if ns ~= nil then
    comment = "// " .. ns.name .. " " .. ns.type .. " "
    return comment, ns
  end

  return "// ", {}
end

return function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local comment, ns = generate(row + 1, col + 1)

  vim.api.nvim_win_set_cursor(0, {
    ns.dim.s.r,
    ns.dim.s.c,
  })

  ---@diagnostic disable-next-line: param-type-mismatch
  vim.fn.append(row - 1, comment)

  vim.api.nvim_win_set_cursor(0, {
    ns.dim.s.r,
    #comment + 1,
  })

  vim.cmd [[startinsert!]]
end
