---@toc_entry Configuration
---@tag gopher.nvim-config
---@text config it is the place where you can configure the plugin.
--- also this is optional is you're ok with default settings.
--- You can look at default options |gopher.nvim-config-defaults|

---@type gopher.Config
---@private
local config = {}

---@tag gopher.nvim-config.ConfigGoTagTransform
---@text Possible values for |gopher.Config|.gotag.transform:
---
---@private
---@alias gopher.ConfigGoTagTransform
---| "snakecase"  "GopherUser" -> "gopher_user"
---| "camelcase"  "GopherUser" -> "gopherUser"
---| "lispcase"   "GopherUser" -> "gopher-user"
---| "pascalcase" "GopherUser" -> "GopherUser"
---| "titlecase"  "GopherUser" -> "Gopher User"
---| "keep"       keeps the original field name

--minidoc_replace_start {

---@tag gopher.nvim-config-defaults
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section)
---
---@class gopher.Config
local default_config = {
  --minidoc_replace_end

  -- log level, you might consider using DEBUG or TRACE for debugging the plugin
  ---@type number
  log_level = vim.log.levels.INFO,

  -- timeout for running commands
  ---@type number
  timeout = 2000,

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
---@private
local _config = default_config

-- I am kinda secret so don't tell anyone about me even dont use me
--
-- if you don't believe me that i am secret see
-- the line below it says @private
---@private
_config.___plugin_name = "gopher.nvim" ---@diagnostic disable-line: inject-field

---@param user_config? gopher.Config
---@private
function config.setup(user_config)
  vim.validate { user_config = { user_config, "table", true } }

  _config = vim.tbl_deep_extend("force", vim.deepcopy(default_config), user_config or {})

  vim.validate {
    log_level = { _config.log_level, "number" },
    timeout = { _config.timeout, "number" },
    ["commands"] = { _config.commands, "table" },
    ["commands.go"] = { _config.commands.go, "string" },
    ["commands.gomodifytags"] = { _config.commands.gomodifytags, "string" },
    ["commands.gotests"] = { _config.commands.gotests, "string" },
    ["commands.impl"] = { _config.commands.impl, "string" },
    ["commands.iferr"] = { _config.commands.iferr, "string" },
    ["gotests"] = { _config.gotests, "table" },
    ["gotests.template"] = { _config.gotests.template, "string" },
    ["gotests.template_dir"] = { _config.gotests.template, "string", true },
    ["gotests.named"] = { _config.gotests.named, "boolean" },
    ["gotag"] = { _config.gotag, "table" },
    ["gotag.transform"] = { _config.gotag.transform, "string" },
    ["gotag.default_tag"] = { _config.gotag.default_tag, "string" },
    ["iferr"] = { _config.iferr, "table" },
    ["iferr.message"] = { _config.iferr.message, "string", true },
  }
end

setmetatable(config, {
  __index = function(_, key)
    return _config[key]
  end,
})

---@return gopher.Config
---@private
return config
