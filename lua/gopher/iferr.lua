local c = require("gopher.config").config.commands

---Add iferr declaration
---That's Lua of vimscript implementation of:
---github.com/koron/iferr
return function()
  local boff = vim.fn.wordcount().cursor_bytes
  local cmd = (c.iferr .. " -pos " .. boff)
  local data = vim.fn.systemlist(cmd, vim.fn.bufnr(0)) --[[@as string]]

  if vim.v.shell_error ~= 0 then
    error("iferr exited with code: " .. vim.v.shell_error)
    return
  end

  local pos = vim.fn.getcurpos()[2]
  vim.fn.append(pos, data)
  vim.cmd [[silent normal! j=2j]]
  vim.fn.setpos(".", pos)
end
