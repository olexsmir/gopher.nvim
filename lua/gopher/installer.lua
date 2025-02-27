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

---@param opt vim.SystemCompleted
---@param url string
local function handle_intall_exit(opt, url)
  if opt.code ~= 0 then
    u.deferred_notify("go install failed: " .. url)
    log.debug("go install failed:", "url", url, "stderr", opt.stderr)
    return
  end

  u.deferred_notify("go install-ed: " .. url)
end

---@param url string
local function install(url)
  r.async({ c.go, "install", url }, function(opt)
    handle_intall_exit(opt, url)
  end)
end

---@param url string
local function install_sync(url)
  local rs = r.sync { c.go, "install", url }
  handle_intall_exit(rs, url)
end

---Install required go deps
---@param sync? boolean
function installer.install_deps(sync)
  sync = sync or false

  for pkg, _ in pairs(urls) do
    local url = urls[pkg] .. "@latest"
    if sync then
      install_sync(url)
    else
      install(url)
    end
  end
end

return installer
