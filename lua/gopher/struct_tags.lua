---@toc_entry Modify struct tags
---@tag gopher.nvim-struct-tags
---@text struct-tags is utilizing the `gomodifytags` tool to add or remove tags to struct fields.
---@usage
--- How to add/remove tags to struct fields:
--  1. Place cursor on the struct
--- 2. Run `:GoTagAdd json` to add json tags to struct fields
--- 3. Run `:GoTagRm json` to remove json tags to struct fields
---
--- NOTE: if you dont specify the tag it will use `json` as default
---
--- Example:
--- >go
---    // before
---    type User struct {
---    // ^ put your cursor here
---    // run `:GoTagAdd yaml`
---        ID int
---        Name string
---    }
---
---    // after
---    type User struct {
---        ID int      `yaml:id`
---        Name string `yaml:name`
---    }
--- <

local ts_utils = require "gopher._utils.ts"
local r = require "gopher._utils.runner"
local c = require "gopher.config"
local struct_tags = {}

local function modify(...)
  local fpath = vim.fn.expand "%" ---@diagnostic disable-line: missing-parameter
  local ns = ts_utils.get_struct_node_at_pos(unpack(vim.api.nvim_win_get_cursor(0)))
  if ns == nil then
    return
  end

  -- by struct name of line pos
  local cmd_args = {}
  if ns.name == nil then
    local _, csrow, _, _ = unpack(vim.fn.getpos ".")
    table.insert(cmd_args, "-line")
    table.insert(cmd_args, csrow)
  else
    table.insert(cmd_args, "-struct")
    table.insert(cmd_args, ns.name)
  end

  -- set user args for cmd
  local arg = { ... }
  for _, v in ipairs(arg) do
    table.insert(cmd_args, v)
  end

  local rs = r.sync {
    c.commands.gomodifytags,
    "-transform",
    c.gotag.transform,
    "-format",
    "json",
    "-w",
    "-file",
    fpath,
    unpack(cmd_args),
  }

  if rs.code ~= 0 then
    error("failed to set tags " .. rs.stderr)
  end

  -- decode value
  local tagged = vim.json.decode(rs.stdout)
  if
    tagged.errors ~= nil
    or tagged.lines == nil
    or tagged["start"] == nil
    or tagged["start"] == 0
  then
    error("failed to set tags " .. vim.inspect(tagged))
  end

  vim.api.nvim_buf_set_lines(
    0,
    tagged.start - 1,
    tagged.start - 1 + #tagged.lines,
    false,
    tagged.lines
  )
  vim.cmd "write"
end

-- add tags to struct under cursor
function struct_tags.add(...)
  local arg = { ... }
  if #arg == nil or arg == "" then
    arg = { c.gotag.default_tag }
  end

  local cmd_args = { "-add-tags" }
  for _, v in ipairs(arg) do
    table.insert(cmd_args, v)
  end

  modify(unpack(cmd_args))
end

-- remove tags to struct under cursor
function struct_tags.remove(...)
  local arg = { ... }
  if #arg == nil or arg == "" then
    arg = { c.gotag.default_tag }
  end

  local cmd_args = { "-remove-tags" }
  for _, v in ipairs(arg) do
    table.insert(cmd_args, v)
  end

  modify(unpack(cmd_args))
end

return struct_tags
