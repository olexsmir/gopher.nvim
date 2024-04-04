---@toc_entry Iferr
---@tag gopher.nvim-iferr
---@text if you're using `iferr` tool, this module provides a way to automatically insert `if err != nil` check.
---@usage execute `:GoIfErr` near any err variable to insert the check

local c = require "gopher.config"
local iferr = {}

-- That's Lua implementation: github.com/koron/iferr
function iferr.iferr()
  local boff = vim.fn.wordcount().cursor_bytes
  local pos = vim.fn.getcurpos()[2]

  local data = vim.fn.systemlist((c.commands.iferr .. " -pos " .. boff), vim.fn.bufnr "%")
  if vim.v.shell_error ~= 0 then
    error("iferr failed: " .. data)
  end

  vim.fn.append(pos, data)
  vim.cmd [[silent normal! j=2j]]
  vim.fn.setpos(".", pos)
end

return iferr
