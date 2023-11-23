local c = require("gopher.config").commands
local r = require "gopher._utils.runner"
local u = require "gopher._utils"
local installer = {}

local latest = "@latest"

local urls = {
  gomodifytags = { "github.com/fatih/gomodifytags", latest },
  impl = { "github.com/josharian/impl", latest },
  gotests = { "github.com/cweill/gotests/...", require("gopher.config").gotests.tag },
  iferr = { "github.com/koron/iferr", latest },
  dlv = { "github.com/go-delve/delve/cmd/dlv", latest },
}

---@param pkg string
local function install(pkg)
  local url = urls[pkg][1] .. urls[pkg][2]
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
