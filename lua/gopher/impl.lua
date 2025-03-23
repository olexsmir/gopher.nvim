---@toc_entry Auto implementation of interface methods
---@tag gopher.nvim-impl
---@text
--- Integration of `impl` tool to generate method stubs for interfaces.
---
---@usage 1. Automatically implement an interface for a struct:
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

function impl.impl(...)
  local args = { ... }
  local iface, recv = "", ""
  local bufnr = vim.api.nvim_get_current_buf()

  if #args == 1 then -- :GoImpl io.Reader
    local st = ts_utils.get_struct_under_cursor(bufnr)
    iface = args[1]
    recv = string.lower(st.name) .. " *" .. st.name
  elseif #args == 2 then -- :GoImpl w io.Writer
    local st = ts_utils.get_struct_under_cursor(bufnr)
    iface = args[2]
    recv = args[1] .. " *" .. st.name
  elseif #args == 3 then -- :GoImpl r Struct io.Reader
    recv = args[1] .. " *" .. args[2]
    iface = args[3]
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
