local Job = require "plenary.job"
local urls = {
  gomodifytags = "github.com/fatih/gomodifytags",
  impl = "github.com/josharian/impl",
  gotests = "github.com/cweill/gotests/...",
}

---@param pkg string
local function install(pkg)
  local url = urls[pkg] .. "@latest"

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
    :start()
end

---Install required go deps
return function()
  for pkg, _ in pairs(urls) do
    install(pkg)
  end
end
