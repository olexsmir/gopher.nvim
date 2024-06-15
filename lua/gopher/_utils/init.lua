local c = require "gopher.config"
local log = require "gopher._utils.log"
local utils = {}

---@param msg string
---@param lvl number
function utils.deferred_notify(msg, lvl)
  vim.defer_fn(function()
    vim.notify(msg, lvl, {
      title = c.___plugin_name,
    })
    log.debug(msg)
  end, 0)
end

---@param msg string
---@param lvl? number
function utils.notify(msg, lvl)
  lvl = lvl or vim.log.levels.INFO
  vim.notify(msg, lvl, {
    title = c.___plugin_name,
  })
  log.debug(msg)
end

-- safe require
---@param  module string module name
function utils.sreq(module)
  local ok, m = pcall(require, module)
  assert(ok, string.format("gopher.nvim dependency error: %s not installed", module))
  return m
end

return utils
