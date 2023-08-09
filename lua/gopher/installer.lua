local c = require("gopher.config").commands
local r = require "gopher._utils.runner"
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
  r.sync(c.go, {
    args = { "install", url },
    on_exit = function(data, status)
      if not status == 0 then
        error("go install failed: " .. data, vim.log.levels.ERROR)
        return
      end
      vim.notify("installed: " .. url, vim.log.levels.INFO)
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
