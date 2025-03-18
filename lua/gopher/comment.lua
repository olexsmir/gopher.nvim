---@toc_entry Generate comments
---@tag gopher.nvim-comments
---@usage Execute `:GoCmt` to generate a comment for the current function/method/struct/etc on this line.
---@text This module provides a way to generate comments for Go code.

local ts = require "gopher._utils.ts"
local log = require "gopher._utils.log"
local comment = {}

---@param bufnr integer
---@return string
---@private
local function generate(bufnr)
  local cmt = "// "

  local ok, res = pcall(ts.get_struct_under_cursor, bufnr)
  if ok then
    return cmt .. res.name .. " "
  end

  ok, res = pcall(ts.get_func_under_cursor, bufnr)
  if ok then
    return cmt .. res.name .. " "
  end

  ok, res = pcall(ts.get_interface_under_cursor, bufnr)
  if ok then
    return cmt .. res.name .. " "
  end

  ok, res = pcall(ts.get_package_under_cursor, bufnr)
  if ok then
    return cmt .. "Package " .. res.name .. " provides "
  end

  return cmt
end

function comment.comment()
  local bufnr = vim.api.nvim_get_current_buf()
  local cmt = generate(bufnr)
  log.debug("generated comment: " .. cmt)

  local pos = vim.fn.getcurpos()[2]
  vim.fn.append(pos - 1, cmt)
  vim.fn.setpos(".", { 0, pos, #cmt })
  vim.cmd "startinsert!"
end

return comment
