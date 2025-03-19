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

local ts = require "gopher._utils.ts"
local r = require "gopher._utils.runner"
local c = require "gopher.config"
local log = require "gopher._utils.log"
local struct_tags = {}

local function handle_tags(fpath, bufnr, user_args)
  local st = ts.get_struct_under_cursor(bufnr)

  -- stylua: ignore
  local cmd = {
    c.commands.gomodifytags,
    "-transform", c.gotag.transform,
    "-format", "json",
    "-struct", st.name,
    "-file", fpath,
    "-w",
  }

  for _, v in ipairs(user_args) do
    table.insert(cmd, v)
  end

  local rs = r.sync(cmd)
  if rs.code ~= 0 then
    log.error("tags: failed to set tags " .. rs.stderr)
    error("failed to set tags " .. rs.stdout)
  end

  local res = vim.json.decode(rs.stdout)

  if res["errors"] then
    log.error("tags: got an error " .. vim.inspect(res))
    error("failed to set tags " .. vim.inspect(res["errors"]))
  end

  for i, v in ipairs(res["lines"]) do
    res["lines"][i] = string.gsub(v, "%s+$", "")
  end

  vim.api.nvim_buf_set_lines(
    bufnr,
    res["start"] - 1,
    res["start"] - 1 + #res["lines"],
    true,
    res["lines"]
  )
  vim.cmd "write"
end

local function handler_user_args(args)
  local res = {}
  if #args == 0 then
    table.insert(res, c.gotag.default_tag)
  else
    for _, v in ipairs(args) do
      table.insert(res, v)
    end
  end

  return res
end

---Adds tags to a struct under the cursor
---@param ... string Tags to add to the struct fields. If not provided, it will use [config.tag.default_tag]
function struct_tags.add(...)
  local args = { ... }
  local fpath = vim.fn.expand "%"
  local bufnr = vim.api.nvim_get_current_buf()

  local user_args = handler_user_args(args)
  table.insert(user_args, 1, "-add-tags")

  handle_tags(fpath, bufnr, user_args)
end

---Removes tags from a struct under the cursor
---@param ... string Tags to add to the struct fields. If not provided, it will use [config.tag.default_tag]
function struct_tags.remove(...)
  local args = { ... }
  local fpath = vim.fn.expand "%"
  local bufnr = vim.api.nvim_get_current_buf()

  local user_args = handler_user_args(args)
  table.insert(user_args, 1, "-remove-tags")

  handle_tags(fpath, bufnr, user_args)
end

---Removes all tags from a struct under the cursor
function struct_tags.clear()
  local fpath = vim.fn.expand "%"
  local bufnr = vim.api.nvim_get_current_buf()
  handle_tags(fpath, bufnr, { "-clear-tags" })
end

return struct_tags
