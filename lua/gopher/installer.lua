local c = require("gopher.config").commands
local r = require "gopher._utils.runner"
local u = require "gopher._utils"
local log = require "gopher._utils.log"
local installer = {}

local urls = {
  gomodifytags = "github.com/fatih/gomodifytags@latest",
  impl = "github.com/josharian/impl@latest",
  gotests = "github.com/cweill/gotests/...@develop",
  iferr = "github.com/koron/iferr@latest",
}

---@param opt vim.SystemCompleted
---@param url string
local function handle_intall_exit(opt, url)
  if opt.code ~= 0 then
    vim.schedule(function()
      u.notify("go install failed: " .. url)
    end)

    log.error("go install failed:", "url", url, "opt", vim.inspect(opt))
    return
  end

  vim.schedule(function()
    u.notify("go install-ed: " .. url)
  end)
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
---@param opts? {sync:boolean}
function installer.install_deps(opts)
  opts = opts or {}
  for _, url in pairs(urls) do
    if opts.sync then
      install_sync(url)
    else
      install(url)
    end
  end
end

return installer
