---@toc_entry Configuration
---@tag gopher.nvim-config
---@text config it is the place where you can configure the plugin.
--- also this is optional is you're ok with default settings.
--- You can look at default options |gopher.nvim-config-defaults|

---@type gopher.Config
--minidoc_replace_start
local config = {}
--minidoc_replace_end

---@tag gopher.nvim-config.ConfigGoTagTransform
---@text Possible values for |gopher.Config|.gotag.transform:
---
---@alias gopher.ConfigGoTagTransform
---| "snakecase"  "GopherUser" -> "gopher_user"
---| "camelcase"  "GopherUser" -> "gopherUser"
---| "lispcase"   "GopherUser" -> "gopher-user"
---| "pascalcase" "GopherUser" -> "GopherUser"
---| "titlecase"  "GopherUser" -> "Gopher User"
---| "keep"       keeps the original field name

---@tag gopher.nvim-config-defaults
---@text Default values:
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section):gsub(">", ">lua")
---
---@class gopher.Config
--minidoc_replace_start {
local default_config = {
  --minidoc_replace_end
  -- user specified paths to binaries
  ---@class gopher.ConfigCommand
  commands = {
    go = "go",
    gomodifytags = "gomodifytags",
    gotests = "gotests",
    impl = "impl",
    iferr = "iferr",
    dlv = "dlv",
  },
  ---@class gopher.ConfigGotests
  gotests = {
    -- gotests doesn't have template named "default" so this plugin uses "default" to set the default template
    template = "default",
    -- path to a directory containing custom test code templates
    ---@type string|nil
    template_dir = nil,
    -- switch table tests from using slice to map (with test name for the key)
    -- works only with gotests installed from develop branch
    ---@type boolean
    named = false,
  },
  ---@class gopher.ConfigGoTag
  gotag = {
    ---@type gopher.ConfigGoTagTransform
    transform = "snakecase",
  },
}
--minidoc_afterlines_end

---@type gopher.Config
---@private
local _config = default_config

---@toc_entry Setup
---@tag gopher.nvim-setup
---@text Setup function. This method simply merges default configs with opts table.
--- You can read more about configuration at |gopher.nvim-config|
--- Calling this function is optional, if you ok with default settings. Look |gopher.nvim.config-defaults|
---
---@usage `require("gopher").setup {}` (replace `{}` with your `config` table)
---
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
