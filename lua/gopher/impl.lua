local c = require("gopher.config").config.commands
local Job = require "plenary.job"
local ts_utils = require "gopher._utils.ts"
local u = require "gopher._utils"

---@return string
local function get_struct()
  local ns = ts_utils.get_struct_node_at_pos(unpack(vim.api.nvim_win_get_cursor(0)))
  if ns == nil then
    u.notify("put cursor on a struct or specify a receiver", "info")
    return ""
  end

  vim.api.nvim_win_set_cursor(0, {
    ns.dim.e.r,
    ns.dim.e.c,
  })

  return ns.name
end

return function(...)
  local args = { ... }
  local iface, recv_name = "", ""
  local recv = get_struct()

  if #args == 0 then
    iface = vim.fn.input "impl: generating method stubs for interface: "
    vim.cmd "redraw!"
    if iface == "" then
      u.notify("usage: GoImpl f *File io.Reader", "info")
      return
    end
  elseif #args == 1 then -- :GoImpl io.Reader
    recv = string.lower(recv) .. " *" .. recv
    vim.cmd "redraw!"
    iface = select(1, ...)
  elseif #args == 2 then -- :GoImpl w io.Writer
    recv_name = select(1, ...)
    recv = string.format("%s *%s", recv_name, recv)
    iface = select(#args, ...)
  elseif #args > 2 then
    iface = select(#args, ...)
    recv = select(#args - 1, ...)
    recv_name = select(#args - 2, ...)
    recv = string.format("%s %s", recv_name, recv)
  end

  -- stylua: ignore
  local cmd_args = {
    "-dir", vim.fn.fnameescape(vim.fn.expand "%:p:h"), ---@diagnostic disable-line: missing-parameter
    recv,
    iface
  }

  local res_data
  Job:new({
    command = c.impl,
    args = cmd_args,
    on_exit = function(data, retval)
      if retval ~= 0 then
        u.notify("command 'impl " .. unpack(cmd_args) .. "' exited with code " .. retval, "error")
        return
      end

      res_data = data:result()
    end,
  }):sync()

  local pos = vim.fn.getcurpos()[2]
  table.insert(res_data, 1, "")
  vim.fn.append(pos, res_data)
end
