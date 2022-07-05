local M = {
  config = {
    ---set custom commands for tools
    commands = {
      go = "go",
      gomodifytags = "gomodifytags",
      gotests = "gotests",
      impl = "impl",
    },
  },
}

---Plugin setup function
---@param opts table user options
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

return M
