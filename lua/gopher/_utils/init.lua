local c = require "gopher.config"
local log = require "gopher._utils.log"
local utils = {}

---@param msg string
---@param lvl? number
function utils.deferred_notify(msg, lvl)
  lvl = lvl or vim.log.levels.INFO
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

---@param path string
---@return string
function utils.readfile_joined(path)
  return table.concat(vim.fn.readfile(path), "\n")
end

return utils
