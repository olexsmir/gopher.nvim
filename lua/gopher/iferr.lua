-- Thanks https://github.com/koron/iferr for vim implementation

---@toc_entry Iferr
---@tag gopher.nvim-iferr
---@text
--- `iferr` provides a way to way to automatically insert `if err != nil` check.
--- If you want to change `-message` option of `iferr` tool, see |gopher.nvim-config|
---
---@usage Execute `:GoIfErr` near any `err` variable to insert the check

local c = require "gopher.config"
local u = require "gopher._utils"
local r = require "gopher._utils.runner"
local log = require "gopher._utils.log"
local iferr = {}

function iferr.iferr()
  local curb = vim.fn.wordcount().cursor_bytes
  local pos = vim.fn.getcurpos()[2]
  local fpath = vim.fn.expand "%"

  local cmd = { c.commands.iferr, "-pos", curb }
  if c.iferr.message ~= nil and type(c.iferr.message) == "string" then
    table.insert(cmd, "-message")
    table.insert(cmd, c.iferr.message)
  end

  local rs = r.sync(cmd, {
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
