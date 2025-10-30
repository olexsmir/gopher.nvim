local c = require "gopher.config"
local log = require "gopher._utils.log"
local utils = {}

---@param msg string
---@param lvl? integer by default `vim.log.levels.INFO`
function utils.notify(msg, lvl)
  lvl = lvl or vim.log.levels.INFO
  vim.notify(msg, lvl, {
    ---@diagnostic disable-next-line:undefined-field
    title = c.___plugin_name,
  })
  log.debug(msg)
end

---@param path string
---@return string
function utils.readfile_joined(path)
  return table.concat(vim.fn.readfile(path), "\n")
end

---@param t string[]
---@return string[]
function utils.remove_empty_lines(t)
  local res = {}
  for _, line in ipairs(t) do
    if line ~= "" then
      table.insert(res, line)
    end
  end
  return res
end

---@param s string
---@return string
function utils.trimend(s)
  local r, _ = string.gsub(s, "%s+$", "")
  return r
end

-- Since indentation can be spaces or tabs, that's my hack around it
---@param line string
---@param indent integer
---@return string
function utils.indent(line, indent)
  local char = string.sub(line, 1, 1)
  if char ~= " " and char ~= "\t" then
    char = " "
  end
  return string.rep(char, indent)
end

---@generic T
---@param tbl T[]
---@return T[]
function utils.list_unique(tbl)
  if vim.fn.has "nvim-0.12" == 1 then
    return vim.list.unique(tbl)
  end

  for i = #tbl, 1, -1 do
    for j = 1, i - 1 do
      if tbl[i] == tbl[j] then
        table.remove(tbl, i)
        break
      end
    end
  end
  return tbl
end

return utils
