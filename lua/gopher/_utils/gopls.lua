local M = {}

---@class gopher.Gopls
local gopls = {
  ---@private
  ---@type vim.lsp.Client
  client = nil,

  ---@private
  ---@type number
  bufnr = 0,
}
gopls.__index = gopls

---@param bufnr number
---@return gopher.Gopls?
function M.get(bufnr)
  local u = require "gopher._utils"

  local clients = vim.lsp.get_clients { name = "gopls", bufnr = bufnr }
  if #clients > 0 then
    return setmetatable({ client = clients[1], bufnr = bufnr }, gopls)
  end

  u.notify("gopher: gopls seems not to be connected", vim.log.levels.ERROR)
  return nil
end

-- TODO: improve error handler
local function on_error(err, res)
  if err then
    error("errorer " .. vim.inspect(err))
    return
  end
  vim.print("got result", res)
end

---@return gopher.Gopls?
function M.get_current()
  return M.get(vim.api.nvim_get_current_buf())
end

---@param opts {recursive:boolean}
function gopls:generate(opts)
  local dir = vim.uri_from_fname(vim.fn.expand "%:p:h")
  self.client:exec_cmd({
    title = opts.recursive and ("Run go generate on " .. dir) or "Run go generate ./...",
    command = "gopls.generate",
    arguments = { {
      dir = dir,
      recursive = opts.recursive,
    } },
  }, { bufnr = self.bufnr }, on_error)
end

function gopls:tidy()
  self.client:exec_cmd({
    title = "Run go mod tidy",
    command = "gopls.tidy",
    arguments = { { uri = vim.uri_from_bufnr(self.bufnr) } },
  }, { bufnr = self.bufnr }, on_error)
end

---@param opts {pkg:string[]}
function gopls:get(opts)
  self.client:exec_cmd({
    title = "Run go get " .. opts.pkg,
    command = "gopls.add_dependency",
    arguments = { {
      uri = vim.uri_from_bufnr(self.bufnr),
      GoCmdArgs = opts.pkg,
      AddRequire = true,
    } },
  }, { bufnr = self.bufnr }, on_error)
end

return M
