---@toc_entry Auto implementation of interface methods
---@tag gopher.nvim-impl
---@text impl is utilizing the `impl` tool to generate method stubs for interfaces.
---@usage
--- 1. put your coursor on the struct on which you want implement the interface
---    and run `:GoImpl io.Reader`
---    which will automatically choose the reciver for the methods and
---    implement the `io.Reader` interface
--- 2. same as previous but with custom receiver, so put your coursor on the struct
---    run `:GoImpl w io.Writer`
---    where `w` is the receiver and `io.Writer` is the interface
--- 3. specift receiver, struct, and interface
---    there's no need to put your coursor on the struct if you specify all arguments
---    `:GoImpl r RequestReader io.Reader`
---    where `r` is the receiver, `RequestReader` is the struct and `io.Reader` is the interface
---
--- simple example:
--- >go
---    type BytesReader struct{}
---    //    ^ put your cursor here
---    // run `:GoImpl b io.Reader`
---
---    // this is what you will get
---    func (b *BytesReader) Read(p []byte) (n int, err error) {
---    	panic("not implemented") // TODO: Implement
---    }
--- <

local c = require("gopher.config").commands
local r = require "gopher._utils.runner"
local ts_utils = require "gopher._utils.ts"
local u = require "gopher._utils"
local impl = {}

---@return string
---@private
local function get_struct()
  local ns = ts_utils.get_struct_node_at_pos(unpack(vim.api.nvim_win_get_cursor(0)))
  if ns == nil then
    u.deferred_notify("put cursor on a struct or specify a receiver", vim.log.levels.INFO)
    return ""
  end

  vim.api.nvim_win_set_cursor(0, {
    ns.dim.e.r,
    ns.dim.e.c,
  })

  return ns.name
end

function impl.impl(...)
  local args = { ... }
  local iface, recv_name = "", ""
  local recv = get_struct()

  if #args == 0 then
    iface = vim.fn.input "impl: generating method stubs for interface: "
    vim.cmd "redraw!"
    if iface == "" then
      u.deferred_notify("usage: GoImpl f *File io.Reader", vim.log.levels.INFO)
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

  local output = r.sync(c.impl, {
    args = {
      "-dir",
      vim.fn.fnameescape(vim.fn.expand "%:p:h" --[[@as string]]),
      recv,
      iface,
    },
    on_exit = function(data, status)
      if not status == 0 then
        error("impl failed: " .. data)
      end
    end,
  })

  local pos = vim.fn.getcurpos()[2]
  table.insert(output, 1, "")
  vim.fn.append(pos, output)
end

return impl
