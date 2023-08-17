---@type gopher.Config
local config = {}

---@class gopher.Config
local default_config = {
  ---@class gopher.ConfigCommand
  commands = {
    go = "go",
    gomodifytags = "gomodifytags",
    gotests = "gotests",
    impl = "impl",
    iferr = "iferr",
    dlv = "dlv",
  },
  ---@class gopjer.ConfigGotests
  gotests = {
    -- gotests doesn't have template named "default" so this plugin uses "default" to set the default template
    template = "default",
    -- path to a directory containing custom test code templates
    ---@type string|nil
    template_dir = nil,
  },
}

---@type gopher.Config
local _config = default_config

---@param user_config? gopher.Config
function config.setup(user_config)
  _config = vim.tbl_deep_extend("force", default_config, user_config or {})
end

setmetatable(config, {
  __index = function(_, key)
    return _config[key]
  end,
})

return config
