local utils = {}

---@param t table
---@return boolean
function utils.is_tbl_empty(t)
  if t == nil then
    return true
  end
  return next(t) == nil
end

---@param msg string
---@param lvl any
function utils.deferred_notify(msg, lvl)
  vim.defer_fn(function()
    vim.notify(msg, lvl)
  end, 0)
end

-- safe require
---@param  module string module name
function utils.sreq(module)
  local ok, m = pcall(require, module)
  assert(ok, string.format("gopher.nvim dependency error: %s not installed", module))
  return m
end

return utils
