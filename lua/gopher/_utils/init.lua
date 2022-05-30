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
}
