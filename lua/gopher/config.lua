---@class Config
---@field commands ConfigCommands

---@class ConfigCommands
---@field go string
---@field gomodifytags string
---@field gotests string
---@field impl string
---@field iferr string
---@field dlv string

local M = {
  ---@type Config
  config = {
    ---set custom commands for tools
    commands = {
      go = "go",
      gomodifytags = "gomodifytags",
      gotests = "gotests",
      impl = "impl",
      iferr = "iferr",
      dlv = "dlv",
    },
    gotests_args = {
      ---override gotests templates
      template_dir = "",
    },
  },
}

---Plugin setup function
---@param opts Config user config
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

return M
