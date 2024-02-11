local c = require "gopher.config"
local ts_utils = require "gopher._utils.ts"
local r = require "gopher._utils.runner"
local u = require "gopher._utils"
local gotests = {}

---@param args table
local function add_test(args)
  if c.gotests.named then
    table.insert(args, "-named")
  end

  if c.gotests.template_dir then
    table.insert(args, "-template_dir")
    table.insert(args, c.gotests.template_dir)
  end

  if c.gotests.template ~= "default" then
    table.insert(args, "-template")
    table.insert(args, c.gotests.template)
  end

  table.insert(args, "-w")
  table.insert(args, vim.fn.expand "%")

  return r.sync(c.commands.gotests, {
    args = args,
    on_exit = function(data, status)
      if not status == 0 then
        error("gotests failed: " .. data)
      end

      u.notify "unit test(s) generated"
    end,
  })
end

---generate unit test for one function
function gotests.func_test()
  local ns = ts_utils.get_func_method_node_at_pos(unpack(vim.api.nvim_win_get_cursor(0)))
  if ns == nil or ns.name == nil then
    u.notify("cursor on func/method and execute the command again", vim.log.levels.WARN)
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
