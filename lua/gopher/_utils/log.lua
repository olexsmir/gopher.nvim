-- thanks https://github.com/tjdevries/vlog.nvim
-- and https://github.com/williamboman/mason.nvim
-- for the code i have stolen(or have inspected by idk)
local c = require "gopher.config"

local config = {
  -- Name of the plugin. Prepended to log messages
  name = c.___plugin_name,

  -- level of looging
  log_level = c.log_level,

  -- Should print the output to neovim while running
  -- values: 'sync','async',false
  use_console = vim.env.GOPHER_VERBOSE_LOGS == "1",

  -- Should highlighting be used in console (using echohl)
  highlights = true,

  -- Should write to a file
  use_file = true,

  -- Level configuration
  modes = {
    { name = "trace", hl = "Comment", level = vim.log.levels.TRACE },
    { name = "debug", hl = "Comment", level = vim.log.levels.DEBUG },
    { name = "info", hl = "None", level = vim.log.levels.INFO },
    { name = "warn", hl = "WarningMsg", level = vim.log.levels.WARN },
    { name = "error", hl = "ErrorMsg", level = vim.log.levels.ERROR },
  },

  -- Can limit the number of decimals displayed for floats
  float_precision = 0.01,
}

---@class Gopher.Logger
---@field outfile string
---@field trace fun(...)
---@field fmt_trace fun(...)
---@field debug fun(...)
---@field fmt_debug fun(...)
---@field info fun(...)
---@field fmt_info fun(...)
---@field warn fun(...)
---@field fmt_warn fun(...)
---@field error fun(...)
---@field fmt_error fun(...)

---@type Gopher.Logger
---@diagnostic disable-next-line: missing-fields
local log = {
  outfile = table.concat {
    (vim.fn.has "nvim-0.8.0" == 1) and vim.fn.stdpath "log" or vim.fn.stdpath "cache",
    ("/%s.log"):format(config.name),
  },
}

-- selene: allow(incorrect_standard_library_use)
local unpack = unpack or table.unpack

do
  local round = function(x, increment)
    increment = increment or 1
    x = x / increment
    return (x > 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)) * increment
  end

  local tbl_has_tostring = function(tbl)
    local mt = getmetatable(tbl)
    return mt and mt.__tostring ~= nil
  end

  local make_string = function(...)
    local t = {}
    for i = 1, select("#", ...) do
      local x = select(i, ...)

      if type(x) == "number" and config.float_precision then
        x = tostring(round(x, config.float_precision))
      elseif type(x) == "table" and not tbl_has_tostring(x) then
        x = vim.inspect(x)
      else
        x = tostring(x)
      end

      t[#t + 1] = x
    end
    return table.concat(t, " ")
  end

  local log_at_level = function(level_config, message_maker, ...)
    -- Return early if we're below the current_log_level
    if level_config.level < config.log_level then
      return
    end
    local nameupper = level_config.name:upper()

    local msg = message_maker(...)
    local info = debug.getinfo(2, "Sl")
    local lineinfo = info.short_src .. ":" .. info.currentline

    -- Output to console
    if config.use_console then
      local log_to_console = function()
        local console_string =
          string.format("[%-6s%s] %s: %s", nameupper, os.date "%H:%M:%S", lineinfo, msg)

        if config.highlights and level_config.hl then
          vim.cmd(string.format("echohl %s", level_config.hl))
        end

        local split_console = vim.split(console_string, "\n")
        for _, v in ipairs(split_console) do
          local formatted_msg = string.format("[%s] %s", config.name, vim.fn.escape(v, [["\]]))

          ---@diagnostic disable-next-line: param-type-mismatch
          local ok = pcall(vim.cmd, string.format([[echom "%s"]], formatted_msg))
          if not ok then
            vim.api.nvim_out_write(msg .. "\n")
          end
        end

        if config.highlights and level_config.hl then
          vim.cmd "echohl NONE"
        end
      end
      if config.use_console == "sync" and not vim.in_fast_event() then
        log_to_console()
      else
        vim.schedule(log_to_console)
      end
    end

    -- Output to log file
    if config.use_file then
      local fp = assert(io.open(log.outfile, "a"))
      local str = string.format("[%-6s%s] %s: %s\n", nameupper, os.date(), lineinfo, msg)
      fp:write(str)
      fp:close()
    end
  end

  for _, x in ipairs(config.modes) do
    -- log.info("these", "are", "separated")
    log[x.name] = function(...) ---@diagnostic disable-line: assign-type-mismatch
      return log_at_level(x, make_string, ...)
    end

    -- log.fmt_info("These are %s strings", "formatted")
    log[("fmt_%s"):format(x.name)] = function(...) ---@diagnostic disable-line: assign-type-mismatch
      return log_at_level(x, function(...)
        local passed = { ... }
        local fmt = table.remove(passed, 1)
        local inspected = {}
        for _, v in ipairs(passed) do
          if type(v) == "table" and tbl_has_tostring(v) then
            table.insert(inspected, v)
          else
            table.insert(inspected, vim.inspect(v))
          end
        end
        return string.format(fmt, unpack(inspected))
      end, ...)
    end
  end
end

return log
