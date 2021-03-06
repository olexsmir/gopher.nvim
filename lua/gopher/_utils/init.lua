return {
  ---@param t table
  ---@return boolean
  empty = function(t)
    if t == nil then
      return true
    end

    return next(t) == nil
  end,

  ---@param s string
  ---@return string
  rtrim = function(s)
    local n = #s
    while n > 0 and s:find("^%s", n) do
      n = n - 1
    end

    return s:sub(1, n)
  end,

  ---@param lib string
  ---@return boolean
  lualib_is_found = function(lib)
    local is_found, _ = pcall(require, lib)
    return is_found
  end,

  ---@param bin string
  ---@return boolean
  binary_is_found = function(bin)
    if vim.fn.executable(bin) == 1 then
      return true
    end

    return false
  end,

  ---@param msg string
  ---@param lvl string|integer
  notify = function(msg, lvl)
    local l
    if lvl == "error" or lvl == 4 then
      l = vim.log.levels.ERROR
    elseif lvl == "info" or lvl == 2 then
      l = vim.log.levels.INFO
    elseif lvl == "debug" or lvl == 1 then
      l = vim.log.levels.DEBUG
    end

    vim.defer_fn(function()
      vim.notify(msg, l)
    end, 0)
  end,
}
