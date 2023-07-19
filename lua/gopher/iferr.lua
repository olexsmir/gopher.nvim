local c = require("gopher.config").commands
local u = require "gopher._utils"
local iferr = {}

-- That's Lua of vimscript implementation of: github.com/koron/iferr
iferr.iferr = function()
  local boff = vim.fn.wordcount().cursor_bytes
  local cmd = (c.iferr .. " -pos " .. boff)
  local data = vim.fn.systemlist(cmd, vim.fn.bufnr "%")

  if vim.v.shell_error ~= 0 then
    u.deferred_notify("command " .. cmd .. " exited with code " .. vim.v.shell_error, vim.log.levels.ERROR)
    return
  end

  local pos = vim.fn.getcurpos()[2]
  vim.fn.append(pos, data)
  vim.cmd [[silent normal! j=2j]]
  vim.fn.setpos(".", pos)
end

return iferr
