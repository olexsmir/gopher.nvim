---@class gopher.Config
local config = {}

---@class gopher.Config
---@field commands gopher.ConfigCommands
local default_config = {
  ---@class gopher.ConfigCommands
  commands = {
    go = "go",
    gomodifytags = "gomodifytags",
    gotests = "gotests",
    impl = "impl",
    iferr = "iferr",
    dlv = "dlv",
  },
}

---@param user_config gopher.Config|nil
function config.setup(user_config)
  config = vim.tbl_deep_extend("force", {}, default_config, user_config or {})
end

-- setup ifself, needs for ability to get
-- default config without calling .setup()
config.setup()

return config
