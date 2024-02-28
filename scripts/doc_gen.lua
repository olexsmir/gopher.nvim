---@diagnostic disable: undefined-global
--# selene: allow(undefined_variable)

local okay, minidoc = pcall(require, "mini.doc")
if not okay then
  error "mini.doc not found, please install it. https://github.com/echasnovski/mini.doc"
  return
end

minidoc.setup()

MiniDoc.generate({ "lua/gopher" }, "doc/gopher.nvim.txt")
