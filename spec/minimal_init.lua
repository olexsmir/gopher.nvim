local function root(p)
  local f = debug.getinfo(1, "S").source:sub(2)
  return vim.fn.fnamemodify(f, ":p:h:h") .. "/" .. (p or "")
end

local function install_plug(plugin)
  local name = plugin:match ".*/(.*)"
  local package_root = root ".tests/site/pack/deps/start/"
  if not vim.loop.fs_stat(package_root .. name) then
    print("Installing " .. plugin)
    vim.fn.mkdir(package_root, "p")
    vim.fn.system {
      "git",
      "clone",
      "--depth=1",
      "https://github.com/" .. plugin .. ".git",
      package_root .. "/" .. name,
    }
  end
end

vim.cmd [[set runtimepath=$VIMRUNTIME]]
vim.opt.runtimepath:append(root())
vim.opt.packpath = { root ".tests/site" }
vim.notify = print

install_plug "nvim-lua/plenary.nvim"
install_plug "nvim-treesitter/nvim-treesitter"

vim.env.XDG_CONFIG_HOME = root ".tests/config"
vim.env.XDG_DATA_HOME = root ".tests/data"
vim.env.XDG_STATE_HOME = root ".tests/state"
vim.env.XDG_CACHE_HOME = root ".tests/cache"
