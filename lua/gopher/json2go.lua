---@toc_entry json2go
---@tag gopher.nvim-json2go
---@text
--- Convert json to go type annotations.
---
---@usage
--- `:GoJson` opens a temporary buffer where you can paste or write JSON.
--- Saving the buffer (`:w` or `:wq`) automatically closes it and inserts the
--- generated Go struct into the original buffer at the cursor position.
---
--- Alternatively, you can pass JSON directly as an argument:
--- >vim
---    :GoJson {"name": "Alice", "age": 30}
--- <

local c = require "gopher.config"
local log = require "gopher._utils.log"
local u = require "gopher._utils"
local r = require "gopher._utils.runner"
local json2go = {}

---@dochide
---@param bufnr integer
---@param cpos integer
---@param type_ string
local function apply(bufnr, cpos, type_)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local input_lines = u.remove_empty_lines(vim.split(type_, "\n"))
  for i, line in pairs(input_lines) do
    table.insert(lines, cpos + i, line)
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
end

-- Convert json string to go type.
---
---@param json_str string Json string that is going to be converted to go type.
---@return string? Go type, or nil if failed.
function json2go.transform(json_str)
  local cmd = { c.commands.json2go }
  if c.json2go.type_name then
    table.insert(cmd, "-type", c.json2go.type_name)
  end

  local rs = r.sync(cmd, { stdin = json_str })
  if rs.code ~= 0 then
    u.notify("json2go: got this error: " .. rs.stdout, vim.log.levels.ERROR)
    log.error("json2go: got this error: " .. rs.stdout)
    return
  end
  return rs.stdout
end

---@dochide
---@param ocpos integer
local function interactive(ocpos)
  local obuf = vim.api.nvim_get_current_buf()
  local owin = vim.api.nvim_get_current_win()

  -- setup the input window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.cmd(c.json2go.interactive_cmd)

  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_buf_set_name(buf, "[GoJson input]")
  vim.api.nvim_set_option_value("filetype", "jsonc", { buf = buf })
  vim.api.nvim_set_option_value("buftype", "acwrite", { buf = buf })
  vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
  vim.api.nvim_set_option_value("bufhidden", "delete", { buf = buf })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    "// Write your json here.",
    "// Writing and quitting (:wq), will generate go struct under the cursor.",
    "",
    "",
  })

  vim.api.nvim_create_autocmd("BufLeave", { buffer = buf, command = "stopinsert" })
  vim.api.nvim_create_autocmd("BufWriteCmd", {
    buffer = buf,
    once = true,
    callback = function()
      local input = vim.api.nvim_buf_get_lines(buf, 0, -1, true)
      local inp = table.concat(
        vim
          .iter(input)
          :filter(function(line)
            local found = string.find(line, "^//.*")
            return (not found) or (line == "")
          end)
          :totable(),
        "\n"
      )

      local go_type = json2go.transform(inp)
      if not go_type then
        error "cound't convert json to go type"
      end

      vim.api.nvim_set_option_value("modified", false, { buf = buf })
      apply(obuf, ocpos, go_type)

      vim.api.nvim_set_current_win(owin)
      vim.api.nvim_win_set_cursor(owin, { ocpos + 1, 0 })

      vim.schedule(function()
        pcall(vim.api.nvim_win_close, win, true)
        pcall(vim.api.nvim_buf_delete, buf, {})
      end)
    end,
  })

  vim.cmd "normal! G"
  vim.cmd "startinsert"
end

--- Converts json string to go type, and puts result under the cursor. If
--- [json_str] is nil, will open an interactive prompt (with cmd set in
--- config).
---
---@param json_str? string
function json2go.json2go(json_str)
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  if not json_str then
    interactive(cur_line)
    return
  end

  local go_type = json2go.transform(json_str)
  if not go_type then
    error "cound't convert json to go type"
  end

  apply(0, cur_line, go_type)
end

return json2go
