---@toc_entry Generate comments
---@tag gopher.nvim-comments
---@text
--- This module provides a way to generate comments for Go code.
---
---@usage Set cursor on line with function/method/struct/etc and run `:GoCmt` to generate a comment.

local ts = require "gopher._utils.ts"
local log = require "gopher._utils.log"
local comment = {}

---@param name string
---@return string
---@dochide
local function template(name)
  return "// " .. name .. " "
end

---@param bufnr integer
---@return string
---@dochide
local function generate(bufnr)
  local s_ok, s_res = pcall(ts.get_struct_under_cursor, bufnr)
  if s_ok then
    return template(s_res.name)
  end

  local f_ok, f_res = pcall(ts.get_func_under_cursor, bufnr)
  if f_ok then
    return template(f_res.name)
  end

  local i_ok, i_res = pcall(ts.get_interface_under_cursor, bufnr)
  if i_ok then
    return template(i_res.name)
  end

  local p_ok, p_res = pcall(ts.get_package_under_cursor, bufnr)
  if p_ok then
    return "// Package " .. p_res.name .. " provides "
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
