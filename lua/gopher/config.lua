---@class gopher.Config
---@field commands gopher.ConfigCommands

---@class gopher.ConfigCommands
---@field go string
---@field gomodifytags string
---@field gotests string
---@field impl string
---@field iferr string
---@field dlv string

local config = {
  ---@type gopher.Config
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
  },
}

---Plugin setup function
---@param opts gopher.Config user config
function config.setup(opts)
  config.config = vim.tbl_deep_extend("force", config.config, opts or {})
end

return config
