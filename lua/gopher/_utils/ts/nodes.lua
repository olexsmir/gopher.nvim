local ts_query = require "nvim-treesitter.query"
local parsers = require "nvim-treesitter.parsers"
local locals = require "nvim-treesitter.locals"
local u = require "gopher._utils"
local M = {}

local function intersects(row, col, sRow, sCol, eRow, eCol)
  if sRow > row or eRow < row then
    return false
  end

  if sRow == row and sCol > col then
    return false
  end

  if eRow == row and eCol < col then
    return false
  end

  return true
end

---@param nodes table
---@param row string
---@param col string
---@return table
function M.intersect_nodes(nodes, row, col)
  local found = {}
  for idx = 1, #nodes do
    local node = nodes[idx]
    local sRow = node.dim.s.r
    local sCol = node.dim.s.c
    local eRow = node.dim.e.r
    local eCol = node.dim.e.c

    if intersects(row, col, sRow, sCol, eRow, eCol) then
      table.insert(found, node)
    end
  end

  return found
end

---@param nodes table
---@return table
function M.sort_nodes(nodes)
  table.sort(nodes, function(a, b)
    return M.count_parents(a) < M.count_parents(b)
  end)

  return nodes
end

---@param query string
---@param lang string
---@param bufnr integer
---@param pos_row string
---@return string
function M.get_all_nodes(query, lang, _, bufnr, pos_row, _)
  bufnr = bufnr or 0
  pos_row = pos_row or 30000

  local ok, parsed_query = pcall(function()
    return vim.treesitter.query.parse(lang, query)
  end)
  if not ok then
    return nil
  end

  local parser = parsers.get_parser(bufnr, lang)
  local root = parser:parse()[1]:root()
  local start_row, _, end_row, _ = root:range()
  local results = {}

  for match in ts_query.iter_prepared_matches(parsed_query, root, bufnr, start_row, end_row) do
    local sRow, sCol, eRow, eCol, declaration_node
    local type, name, op = "", "", ""
    locals.recurse_local_nodes(match, function(_, node, path)
      local idx = string.find(path, ".[^.]*$")
      op = string.sub(path, idx + 1, #path)
      type = string.sub(path, 1, idx - 1)

      if op == "name" then
        name = vim.treesitter.get_node_text(node, bufnr)
      elseif op == "declaration" or op == "clause" then
        declaration_node = node
        sRow, sCol, eRow, eCol = node:range()
        sRow = sRow + 1
        eRow = eRow + 1
        sCol = sCol + 1
        eCol = eCol + 1
      end
    end)

    if declaration_node ~= nil then
      table.insert(results, {
        declaring_node = declaration_node,
        dim = { s = { r = sRow, c = sCol }, e = { r = eRow, c = eCol } },
        name = name,
        operator = op,
        type = type,
      })
    end
  end

  return results
end

---@param query string
---@param default string
---@param bufnr string
---@param row string
---@param col string
---@return table
function M.nodes_at_cursor(query, default, bufnr, row, col)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_buf_get_option(bufnr, "ft")
  if row == nil or col == nil then
    row, col = unpack(vim.api.nvim_win_get_cursor(0))
  end

  local nodes = M.get_all_nodes(query, ft, default, bufnr, row, col)
  if nodes == nil then
    u.deferred_notify(
      "Unable to find any nodes. Place your cursor on a go symbol and try again",
      vim.log.levels.DEBUG
    )
    return nil
  end

  nodes = M.sort_nodes(M.intersect_nodes(nodes, row, col))
  if nodes == nil or #nodes == 0 then
    u.deferred_notify(
      "Unable to find any nodes at pos. " .. tostring(row) .. ":" .. tostring(col),
      vim.log.levels.DEBUG
    )
    return nil
  end

  return nodes
end

return M
