local c = require("gopher.config").commands
local u = require "gopher._utils"
local ts_utils = require "gopher._utils.ts"
local r = require "gopher._utils.runner"
local gotests = {}

---@param args table
local function add_test(args)
  local fpath = vim.fn.expand "%" ---@diagnostic disable-line: missing-parameter
  table.insert(args, "-w")
  table.insert(args, fpath)

  return r.spawn(c.gotests, {
    args = args,
    on_exit = function(ok, data)
      if not ok then
        vim.notify("gotests failed: " .. data, vim.log.levels.ERROR)
        return
      end

      vim.notify("unit test(s) generated", vim.log.levels.INFO)
    end,
  })
end

---generate unit test for one function
---@param parallel boolean
function gotests.func_test(parallel)
  local ns = ts_utils.get_func_method_node_at_pos(unpack(vim.api.nvim_win_get_cursor(0)))
  if ns == nil or ns.name == nil then
    u.deferred_notify("cursor on func/method and execute the command again", vim.log.levels.INFO)
    return
  end

  local cmd_args = { "-only", ns.name }
  if parallel then
    table.insert(cmd_args, "-parallel")
  end

  add_test(cmd_args)
end

---generate unit tests for all functions in current file
---@param parallel boolean
function gotests.all_tests(parallel)
  local cmd_args = { "-all" }
  if parallel then
    table.insert(cmd_args, "-parallel")
  end

  add_test(cmd_args)
end

---generate unit tests for all exported functions
---@param parallel boolean
function gotests.all_exported_tests(parallel)
  local cmd_args = {}
  if parallel then
    table.insert(cmd_args, "-parallel")
  end

  table.insert(cmd_args, "-exported")
  add_test(cmd_args)
end

return gotests
