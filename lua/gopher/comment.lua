---@toc_entry Generate comments
---@tag gopher.nvim-comments
---@usage Execute `:GoCmt` to generate a comment for the current function/method/struct/etc on this line.
---@text This module provides a way to generate comments for Go code.

local ts = require "gopher._utils.ts"
local log = require "gopher._utils.log"
local comment = {}

---@param name string
---@return string
---@private
local function template(name)
  return "// " .. (name or "") .. " "
end

---@param bufnr integer
---@return string
---@private
local function generate(bufnr)
  local sok, sres = pcall(ts.get_struct_under_cursor, bufnr)
  vim.print(sok, sres)
  if sok then
    return template(sres.name)
  end

  local fok, fres = pcall(ts.get_func_under_cursor, bufnr)
  if fok then
    return template(fres.name)
  end

  local iok, ires = pcall(ts.get_interface_under_cursor, bufnr)
  if iok then
    return template(ires.name)
  end

  local pok, pres = pcall(ts.get_package_under_cursor, bufnr)
  if pok then
    return "// Package " .. pres.name .. " provides "
  end

  return "// "
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
