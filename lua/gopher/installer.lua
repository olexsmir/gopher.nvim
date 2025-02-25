local c = require("gopher.config").commands
local r = require "gopher._utils.runner"
local u = require "gopher._utils"
local installer = {}

local urls = {
  gomodifytags = "github.com/fatih/gomodifytags",
  impl = "github.com/josharian/impl",
  gotests = "github.com/cweill/gotests/...",
  iferr = "github.com/koron/iferr",
}

---@param pkg string
local function install(pkg)
  local url = urls[pkg] .. "@latest"
  r.sync(c.go, {
    args = { "install", url },
    on_exit = function(data, status)
      if not status == 0 then
        error("go install failed: " .. data)
        return
      end
      u.notify("installed: " .. url)
    end,
  })
end

---Install required go deps
function installer.install_deps()
  for pkg, _ in pairs(urls) do
    install(pkg)
  end
end

return installer
