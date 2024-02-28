---@diagnostic disable: undefined-global
--# selene: allow(undefined_variable)

local okay, minidoc = pcall(require, "mini.doc")
if not okay then
  error "mini.doc not found, please install it. https://github.com/echasnovski/mini.doc"
  return
end

local files = {
  "lua/gopher/init.lua",
  "lua/gopher/config.lua",
}

minidoc.setup()

local hooks = vim.deepcopy(minidoc.default_hooks)
hooks.write_pre = function(lines)
  -- Remove first two lines with `======` and `------` delimiters to comply
  -- with `:h local-additions` template
  table.remove(lines, 1)
  table.remove(lines, 1)

  return lines
end

print "Generating documentation...\n"
MiniDoc.generate(files, "doc/gopher.nvim.txt", { hooks = hooks })
print "Generation complete!\n"
