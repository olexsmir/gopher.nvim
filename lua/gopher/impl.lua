---@toc_entry Auto implementation of interface methods
---@tag gopher.nvim-impl
---@text impl is utilizing the `impl` tool to generate method stubs for interfaces.
---@usage
--- 1. Automatically implement an interface for a struct:
---    - Place your cursor on the struct where you want to implement the interface.
---    - Run `:GoImpl io.Reader`
---    - This will automatically determine the receiver and implement the `io.Reader` interface.
---
--- 2. Specify a custom receiver:
---    - Place your cursor on the struct
---    - Run `:GoImpl w io.Writer`, where:
---      - `w` is the receiver.
---      - `io.Writer` is the interface to implement.
---
--- 3. Explicitly specify the receiver, struct, and interface:
---    - No need to place the cursor on the struct if all arguments are provided.
---    - Run `:GoImpl r RequestReader io.Reader`, where:
---      - `r` is the receiver.
---      - `RequestReader` is the struct.
---      - `io.Reader` is the interface to implement.
---
--- Example:
--- >go
---    type BytesReader struct{}
---    //    ^ put your cursor here
---    // run `:GoImpl b io.Reader`
---
---    // this is what you will get
---    func (b *BytesReader) Read(p []byte) (n int, err error) {
---        panic("not implemented") // TODO: Implement
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
    u.notify "put cursor on a struct or specify a receiver"
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

  local rs = r.sync { c.impl, "-dir", vim.fn.fnameescape(vim.fn.expand "%:p:h"), recv, iface }
  if rs.code ~= 0 then
    error("failed to implement interface: " .. rs.stderr)
  end

  local pos = vim.fn.getcurpos()[2]
  local output = u.remove_empty_lines(vim.split(rs.stdout, "\n"))

  table.insert(output, 1, "")
  vim.fn.append(pos, output)
end

return impl
