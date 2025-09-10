local lsp = {}

local gopls = "gopls"

-- Restarts gopls server (see: `:h lsp-restart`)
function lsp.restart()
  vim.lsp.enable(gopls, false)
  vim.lsp.enable(gopls, true)
end

return lsp
