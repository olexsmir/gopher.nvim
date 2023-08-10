local c = require("gopher.config").commands
local iferr = {}

-- That's Lua of vimscript implementation of: github.com/koron/iferr
function iferr.iferr()
  local boff = vim.fn.wordcount().cursor_bytes
  local pos = vim.fn.getcurpos()[2]

  local data = vim.fn.systemlist((c.iferr .. " -pos " .. boff), vim.fn.bufnr "%")
  if vim.v.shell_error ~= 0 then
    error("iferr failed: " .. data, vim.log.levels.ERROR)
  end

  vim.fn.append(pos, data)
  vim.cmd [[silent normal! j=2j]]
  vim.fn.setpos(".", pos)
end

return iferr
