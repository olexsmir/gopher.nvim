-- Thanks https://github.com/koron/iferr for vim implementation

---@toc_entry Iferr
---@tag gopher.nvim-iferr
---@text
--- `iferr` provides a way to automatically insert `if err != nil` check.
--- To configure a default `-message` option for the `iferr` tool, see |gopher.nvim-config|
---
---@usage
--- 1. Insert error check:
---  - Place your cursor near any `err` variable
---  - Run `:GoIfErr`
---
--- 2. Insert error check with custom `-message`:
---  - Place your cursor near any`err` variable
---  - Run `:GoIfErr fmt.Errorf("failed to %w", err)`
---
--- Example:
--- >go
---    func test() error {
---        err := doSomething()
---        //  ^ put your cursor here
---        // run `:GoIfErr` or `:GoIfErr log.Printf("error: %v", err)`
---    }
---

local c = require "gopher.config"
local u = require "gopher._utils"
local r = require "gopher._utils.runner"
local log = require "gopher._utils.log"
local iferr = {}

---@param message? string Optional custom error message to use instead of config default
function iferr.iferr(message)

  local curb = vim.fn.wordcount().cursor_bytes
  local pos = vim.fn.getcurpos()[2]
  local fpath = vim.fn.expand "%"

  local cmd = { c.commands.iferr, "-pos", curb }
  local msg = message or c.iferr.message
  if msg ~= nil and type(msg) == "string" then
    table.insert(cmd, "-message")
    table.insert(cmd, msg)
  end

  local rs = r.sync(cmd, {
    stdin = u.readfile_joined(fpath),
  })

  if rs.code ~= 0 then
    if string.find(rs.stderr, "no functions at") then
      u.notify("iferr: no function at " .. curb, vim.log.levels.ERROR)
      log.warn("iferr: no function at " .. curb)
      return
    end

    log.error("ferr: failed. output: " .. rs.stderr)
    error("iferr failed: " .. rs.stderr)
  end

  vim.fn.append(pos, u.remove_empty_lines(vim.split(rs.stdout, "\n")))
  vim.cmd [[silent normal! j=2j]]
  vim.fn.setpos(".", pos --[[@as integer[] ]])
end

return iferr
