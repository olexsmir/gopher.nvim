return {
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
}
