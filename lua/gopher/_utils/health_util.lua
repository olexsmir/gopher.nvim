local h = vim.health or require "health"
local health = {}

health.start = h.start or h.report_start
health.ok = h.ok or h.report_ok
health.warn = h.warn or h.report_warn
health.error = h.error or h.report_error
health.info = h.info or h.report_info

---@param module string
---@return boolean
function health.is_lualib_found(module)
  local is_found, _ = pcall(require, module)
  return is_found
end

---@param bin string
---@return boolean
function health.is_binary_found(bin)
  if vim.fn.executable(bin) == 1 then
    return true
  end
  return false
end

---@param ft string
---@return boolean
function health.is_treesitter_parser_available(ft)
  local ok, parser = pcall(vim.treesitter.get_parser, 0, ft)
  return ok and parser ~= nil
end

return health
