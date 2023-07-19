local Job = require "plenary.job"
local c = require("gopher.config").commands
local u = require "gopher._utils"
local installer = {}

local urls = {
  gomodifytags = "github.com/fatih/gomodifytags",
  impl = "github.com/josharian/impl",
  gotests = "github.com/cweill/gotests/...",
  iferr = "github.com/koron/iferr",
  dlv = "github.com/go-delve/delve/cmd/dlv",
}

---@param pkg string
local function install(pkg)
  local url = urls[pkg] .. "@latest"

  Job:new({
    command = c.go,
    args = { "install", url },
    on_exit = function(_, retval)
      if retval ~= 0 then
        u.notify("command 'go install " .. url .. "' exited with code " .. retval, "error")
        return
      end

      u.notify("install " .. url .. " finished", "info ")
    end,
  }):start()
end

---Install required go deps
function installer.install_deps()
  for pkg, _ in pairs(urls) do
    install(pkg)
  end
end

return installer
