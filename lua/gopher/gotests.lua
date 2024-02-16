local u = require "gopher._utils"
local M = {}

---@param cmd_args table
local function run(cmd_args)
  local Job = require "plenary.job"
  local c = require("gopher.config").config.commands

  Job:new({
    command = c.gotests,
    args = cmd_args,
    on_exit = function(_, retval)
      if retval ~= 0 then
        u.notify("command 'go " .. unpack(cmd_args) .. "' exited with code " .. retval, "error")
        return
      end

      u.notify("unit test(s) generated", "info")
    end,
  }):start()
end

---@param args table
local function add_test(args)
  local c = require("gopher.config").config.gotests
  if c.template_dir ~= "" then
    table.insert(args, "-template_dir")
    table.insert(args, c.template_dir)
  end
  local fpath = vim.fn.expand "%" ---@diagnostic disable-line: missing-parameter
  table.insert(args, "-w")
  table.insert(args, fpath)
  run(args)
end

---generate unit test for one function
---@param parallel boolean
function M.func_test(parallel)
  local ts_utils = require "gopher._utils.ts"

  local ns = ts_utils.get_func_method_node_at_pos(unpack(vim.api.nvim_win_get_cursor(0)))
  if ns == nil or ns.name == nil then
    u.notify("cursor on func/method and execute the command again", "info")
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
function M.all_tests(parallel)
  local cmd_args = { "-all" }
  if parallel then
    table.insert(cmd_args, "-parallel")
  end

  add_test(cmd_args)
end

---generate unit tests for all exported functions
---@param parallel boolean
function M.all_exported_tests(parallel)
  local cmd_args = {}
  if parallel then
    table.insert(cmd_args, "-parallel")
  end

  table.insert(cmd_args, "-exported")
  add_test(cmd_args)
end

return M
