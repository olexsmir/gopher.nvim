local M = {}

local function modify(...)
  local ts_utils = require "gopher._utils.ts"
  local Job = require "plenary.job"
  local c = require("gopher.config").config.commands
  local u = require "gopher._utils"

  local fpath = vim.fn.expand "%" ---@diagnostic disable-line: missing-parameter
  local ns = ts_utils.get_struct_node_at_pos(unpack(vim.api.nvim_win_get_cursor(0)))
  if ns == nil then
    return
  end

  -- stylua: ignore
  local cmd_args = {
    "-format", "json",
    "-file", fpath,
    "-w"
  }

  -- by struct name of line pos
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

  -- set default tag for "clear tags"
  if #arg == 1 and arg[1] ~= "-clear-tags" then
    table.insert(cmd_args, "json")
  end

  -- get result of "gomodifytags" works
  local res_data
  Job:new({
    command = c.gomodifytags,
    args = cmd_args,
    on_exit = function(data, retval)
      if retval ~= 0 then
        u.notify(
          "command 'gomodifytags " .. unpack(cmd_args) .. "' exited with code " .. retval,
          "error"
        )
        return
      end

      res_data = data:result()
    end,
  }):sync()

  -- decode goted value
  local tagged = vim.json.decode(table.concat(res_data))
  if
    tagged.errors ~= nil
    or tagged.lines == nil
    or tagged["start"] == nil
    or tagged["start"] == 0
  then
    u.notify("failed to set tags " .. vim.inspect(tagged), "error")
  end

  for i, v in ipairs(tagged.lines) do
    tagged.lines[i] = u.rtrim(v)
  end

  -- write goted tags
  vim.api.nvim_buf_set_lines(
    0,
    tagged.start - 1,
    tagged.start - 1 + #tagged.lines,
    false,
    tagged.lines
  )
  vim.cmd "write"
end

---add tags to struct under cursor
---@param ... unknown
function M.add(...)
  local arg = { ... }
  if #arg == nil or arg == "" then
    arg = { "json" }
  end

  local cmd_args = { "-add-tags" }
  for _, v in ipairs(arg) do
    table.insert(cmd_args, v)
  end

  modify(unpack(cmd_args))
end

---remove tags to struct under cursor
---@param ... unknown
function M.remove(...)
  local arg = { ... }
  if #arg == nil or arg == "" then
    arg = { "json" }
  end

  local cmd_args = { "-remove-tags" }
  for _, v in ipairs(arg) do
    table.insert(cmd_args, v)
  end

  modify(unpack(cmd_args))
end

---clear all tags to struct under cursor
function M.clear()
  if #arg == nil or arg == "" then
    arg = { "json" }
  end

  local cmd_args = { "-clear-tags" }

  modify(unpack(cmd_args))
end

return M
