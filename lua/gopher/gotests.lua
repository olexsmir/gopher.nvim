local Job = require "plenary.job"
local ts_utils = require "gopher._utils.ts"
local M = {}

---@param cmd_args table
local function run(cmd_args)
  Job
    :new({
      command = "gotests",
      args = cmd_args,
      on_exit = function(_, retval)
        if retval ~= 0 then
          print("command exited with code " .. retval)
          return
        end

        print "unit test(s) generated"
      end,
    })
    :start()
end

---@param args table
local function add_test(args)
  local fpath = vim.fn.expand "%" ---@diagnostic disable-line: missing-parameter
  table.insert(args, "-w")
  table.insert(args, fpath)
  run(args)
end

---generate unit test for one function
---@param parallel boolean
function M.func_test(parallel)
  local ns = ts_utils.get_func_method_node_at_pos(unpack(vim.api.nvim_win_get_cursor(0)))
  if ns == nil or ns.name == nil then
    print "cursor on func/method and execute the command again"
    return
  end

  local cmd_args = { "-only", ns.name }
  if parallel then
    table.insert(cmd_args, "-parallel")
  end

  add_test(cmd_args)
end

function M.all_tests(parallel)
  local cmd_args = { "-all" }
  if parallel then
    table.insert(cmd_args, "-parallel")
  end

  add_test(cmd_args)
end

return M
