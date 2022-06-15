local Job = require "plenary.job"
local M = {
  urls = {
    gomodifytags = "github.com/fatih/gomodifytags",
    impl = "github.com/josharian/impl",
  },
}

local function install(pkg)
  local url = M.urls[pkg] .. "@latest"

  Job
    :new({
      command = "go",
      args = { "install", url },
      on_exit = function(_, ret_val)
        if ret_val ~= 0 then
          print("command exited with code " .. ret_val)
          return
        end

        print("install " .. url .. " finished")
      end,
    })
    :sync()
end

---Install required go deps
function M.install_all()
  for pkg, _ in pairs(M.urls) do
    install(pkg)
  end
end

return M
