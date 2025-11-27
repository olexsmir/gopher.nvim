---@toc_entry Modify struct tags
---@tag gopher.nvim-struct-tags
---@text
--- `struct_tags` is utilizing the `gomodifytags` tool to add or remove tags to
--- struct fields.
---
---@usage
--- How to add/remove/clear tags to struct fields:
--- 1. Place cursor on the struct
--- 2. Run `:GoTagAdd json` to add json tags to struct fields
--- 3. Run `:GoTagRm json` to remove json tags to struct fields
--- 4. Run `:GoTagClear` to clear all tags from struct fields
---
--- If you want to add/remove tag with options, you can use `json=omitempty`
--- (where json is tag, and omitempty is its option).
--- Example: `:GoTagAdd xml json=omitempty`
---
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
local u = require "gopher._utils"
local log = require "gopher._utils.log"
local struct_tags = {}

---@dochide
---@class gopher.StructTagInput
---@field input string[] User provided tags
---@field range? gopher.StructTagRange  (optional)

---@dochide
---@class gopher.StructTagRange
---@field start number
---@field end_ number

---@param fpath string
---@param bufnr integer
---@param range? gopher.StructTagRange
---@param user_args string[]
---@dochide
local function handle_tags(fpath, bufnr, range, user_args)
  local st = ts.get_struct_under_cursor(bufnr)

  -- stylua: ignore
  local cmd = {
    c.commands.gomodifytags,
    "-transform", c.gotag.transform,
    "-format", "json",
    "-file", fpath,
    "-w",
  }

  -- `-struct` and `-line` cannot be combined, setting them separately
  if range or st.is_varstruct then
    table.insert(cmd, "-line")
    table.insert(cmd, string.format("%d,%d", (range or st).start, (range or st).end_))
  else
    table.insert(cmd, "-struct")
    table.insert(cmd, st.name)
  end

  for _, v in ipairs(user_args) do
    table.insert(cmd, v)
  end

  local rs = r.sync(cmd)
  if rs.code ~= 0 then
    log.error("tags: failed to set tags " .. rs.stderr)
    error("failed to set tags " .. rs.stderr)
  end

  local res = vim.json.decode(rs.stdout)
  if res["errors"] then
    log.error("tags: got an error " .. vim.inspect(res))
    error("failed to set tags " .. vim.inspect(res["errors"]))
  end

  for i, v in ipairs(res["lines"]) do
    res["lines"][i] = u.trimend(v)
  end

  vim.api.nvim_buf_set_lines(
    bufnr,
    res["start"] - 1,
    res["start"] - 1 + #res["lines"],
    true,
    res["lines"]
  )
end

---@dochide
---@param option string
local function option_to_tag(option)
  return option:match "^(.-)="
end

---@dochide
---@param args string[]
local function unwrap_if_needed(args)
  local out = {}
  for _, v in pairs(args) do
    for _, p in pairs(vim.split(v, ",")) do
      table.insert(out, p)
    end
  end
  return out
end

---@dochide
---@class gopher.StructTagsArgs
---@field tags string
---@field options string

---@dochide
---@param args string[]
---@return gopher.StructTagsArgs
function struct_tags.parse_args(args)
  args = unwrap_if_needed(args)

  local tags, options = {}, {}
  for _, v in pairs(args) do
    if string.find(v, "=") then
      table.insert(options, v)
      table.insert(tags, option_to_tag(v))
    else
      table.insert(tags, v)
    end
  end

  return {
    tags = table.concat(u.list_unique(tags), ","),
    options = table.concat(u.list_unique(options), ","),
  }
end

-- Adds tags to a struct under the cursor. See `:h gopher.nvim-struct-tags`.
---@param opts gopher.StructTagInput
---@dochide
function struct_tags.add(opts)
  log.debug("adding tags", opts)

  local fpath = vim.fn.expand "%"
  local bufnr = vim.api.nvim_get_current_buf()

  local user_args = struct_tags.parse_args(opts.input)
  handle_tags(fpath, bufnr, opts.range, {
    "-add-tags",
    (user_args.tags ~= "") and user_args.tags or c.gotag.default_tag,
    (user_args.options ~= "" or c.gotag.option) and "-add-options" or nil,
    (user_args.options ~= "") and user_args.options or c.gotag.option,
  })
end

-- Removes tags from a struct under the cursor. See `:h gopher.nvim-struct-tags`.
---@dochide
---@param opts gopher.StructTagInput
function struct_tags.remove(opts)
  log.debug("removing tags", opts)

  local fpath = vim.fn.expand "%"
  local bufnr = vim.api.nvim_get_current_buf()

  local user_args = struct_tags.parse_args(opts.input)
  handle_tags(fpath, bufnr, opts.range, {
    "-remove-tags",
    (user_args.tags ~= "") and user_args.tags or c.gotag.default_tag,
    (user_args.options ~= "" or c.gotag.option ~= nil) and "-remove-options" or nil,
    (user_args.options ~= "") and user_args.options or c.gotag.option,
  })
end

-- Removes all tags from a struct under the cursor.
-- See `:h gopher.nvim-struct-tags`.
---@dochide
function struct_tags.clear()
  local fpath = vim.fn.expand "%"
  local bufnr = vim.api.nvim_get_current_buf()
  handle_tags(fpath, bufnr, nil, { "-clear-tags" })
end

return struct_tags
