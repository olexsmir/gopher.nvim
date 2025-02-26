local c = require("gopher.config").commands
local r = require "gopher._utils.runner"
local u = require "gopher._utils"
local log = require "gopher._utils.log"
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
  local function on_exit(opt)
    if opt.code ~= 0 then
      u.deferred_notify("go install failed: " .. url)
      log.debug("go install failed:", "url", url, "stderr", opt.stderr)
      return
    end

    u.deferred_notify("go install'ed: " .. url)
  end

  r.async({ c.go, "install", url }, on_exit)
end

---Install required go deps
function installer.install_deps()
  for pkg, _ in pairs(urls) do
    install(pkg)
  end
end

return installer
