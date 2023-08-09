local c = require("gopher.config").commands
local ts_utils = require "gopher._utils.ts"
local r = require "gopher._utils.runner"
local gotests = {}

---@param args table
local function add_test(args)
  table.insert(args, "-w")
  table.insert(args, vim.fn.expand "%")

  return r.sync(c.gotests, {
    args = args,
    on_exit = function(data, status)
      if not status == 0 then
        vim.notify("gotests failed: " .. data, vim.log.levels.ERROR)
        return
      end

      vim.notify("unit test(s) generated", vim.log.levels.INFO)
    end,
  })
end

---generate unit test for one function
function gotests.func_test()
  local ns = ts_utils.get_func_method_node_at_pos(unpack(vim.api.nvim_win_get_cursor(0)))
  if ns == nil or ns.name == nil then
    vim.notify("cursor on func/method and execute the command again", vim.log.levels.INFO)
    return
  end

  add_test { "-only", ns.name }
end

---generate unit tests for all functions in current file
function gotests.all_tests()
  add_test { "-all" }
end

---generate unit tests for all exported functions
function gotests.all_exported_tests()
  add_test { "-exported" }
end

return gotests
