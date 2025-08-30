local config = {}

---@tag gopher.nvim-config.ConfigGoTagTransform
---@text Possible values for |gopher.Config|.gotag.transform:
---
---@dochide
---@alias gopher.ConfigGoTagTransform
---| "snakecase"  "GopherUser" -> "gopher_user"
---| "camelcase"  "GopherUser" -> "gopherUser"
---| "lispcase"   "GopherUser" -> "gopher-user"
---| "pascalcase" "GopherUser" -> "GopherUser"
---| "titlecase"  "GopherUser" -> "Gopher User"
---| "keep"       keeps the original field name

---@toc_entry Config
---@tag gopher.nvim-config
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section)
---@class gopher.Config
local default_config = {
  -- log level, you might consider using DEBUG or TRACE for debugging the plugin
  ---@type number
  log_level = vim.log.levels.INFO,

  -- timeout for running internal commands
  ---@type number
  timeout = 2000,

  --- timeout for running installer commands(e.g :GoDepsInstall, :GoDepsInstallSync)
  installer_timeout = 999999,

  -- user specified paths to binaries
  ---@class gopher.ConfigCommand
  commands = {
    go = "go",
    gomodifytags = "gomodifytags",
    gotests = "gotests",
    impl = "impl",
    iferr = "iferr",
  },
  ---@class gopher.ConfigGotests
  gotests = {
    -- gotests doesn't have template named "default" so this plugin uses "default" to set the default template
    template = "default",
    -- path to a directory containing custom test code templates
    ---@type string|nil
    template_dir = nil,
    -- switch table tests from using slice to map (with test name for the key)
    named = false,
  },
  ---@class gopher.ConfigGoTag
  gotag = {
    ---@type gopher.ConfigGoTagTransform
    transform = "snakecase",

    -- default tags to add to struct fields
    default_tag = "json",
  },
  iferr = {
    -- choose a custom error message
    ---@type string|nil
    message = nil,
  },
}
--minidoc_afterlines_end

---@type gopher.Config
---@dochide
local _config = default_config

-- I am kinda secret so don't tell anyone about me even dont use me
--
-- if you don't believe me that i am secret see
-- the line below it says @private
---@private
_config.___plugin_name = "gopher.nvim" ---@diagnostic disable-line: inject-field

---@param user_config? gopher.Config
---@dochide
function config.setup(user_config)
  vim.validate("user_config", user_config, "table", true)

  _config = vim.tbl_deep_extend("force", vim.deepcopy(default_config), user_config or {})

  vim.validate("log_level", _config.log_level, "number")
  vim.validate("timeout", _config.timeout, "number")
  vim.validate("installer_timeout", _config.timeout, "number")
  vim.validate("commands", _config.commands, "table")
  vim.validate("commands.go", _config.commands.go, "string")
  vim.validate("commands.gomodifytags", _config.commands.gomodifytags, "string")
  vim.validate("commands.gotests", _config.commands.gotests, "string")
  vim.validate("commands.impl", _config.commands.impl, "string")
  vim.validate("commands.iferr", _config.commands.iferr, "string")
  vim.validate("gotests", _config.gotests, "table")
  vim.validate("gotests.template", _config.gotests.template, "string")
  vim.validate("gotests.template_dir", _config.gotests.template_dir, "string", true)
  vim.validate("gotests.named", _config.gotests.named, "boolean")
  vim.validate("gotag", _config.gotag, "table")
  vim.validate("gotag.transform", _config.gotag.transform, "string")
  vim.validate("gotag.default_tag", _config.gotag.default_tag, "string")
  vim.validate("iferr", _config.iferr, "table")
  vim.validate("iferr.message", _config.iferr.message, "string", true)
end

setmetatable(config, {
  __index = function(_, key)
    return _config[key]
  end,
})

---@dochide
---@return gopher.Config
return config
