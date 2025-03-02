---@toc_entry Iferr
---@tag gopher.nvim-iferr
---@text If you're using `iferr` tool, this module provides a way to automatically insert `if err != nil` check.
---@usage Execute `:GoIfErr` near any `err` variable to insert the check

local c = require "gopher.config"
local u = require "gopher._utils"
local r = require "gopher._utils.runner"
local log = require "gopher._utils.log"
local iferr = {}

-- That's Lua implementation: https://github.com/koron/iferr
function iferr.iferr()
  local curb = vim.fn.wordcount().cursor_bytes
  local pos = vim.fn.getcurpos()[2]
  local fpath = vim.fn.expand "%"

  local rs = r.sync({ c.commands.iferr, "-pos", curb }, {
    stdin = u.readfile_joined(fpath),
  })

  if rs.code ~= 0 then
    if string.find(rs.stderr, "no functions at") then
      u.notify("iferr: no function at " .. curb, vim.log.levels.ERROR)
      log.warn("iferr: no function at " .. curb)
      return
    end

    log.error("ferr: failed. output: " .. rs.stderr)
    error("iferr failed: " .. rs.stderr)
  end

  vim.fn.append(pos, u.remove_empty_lines(vim.split(rs.stdout, "\n")))
  vim.cmd [[silent normal! j=2j]]
  vim.fn.setpos(".", pos)
end

return iferr
