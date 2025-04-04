local function root(p)
  local f = debug.getinfo(1, "S").source:sub(2)
  return vim.fn.fnamemodify(f, ":p:h:h") .. "/" .. (p or "")
end

local function install_plug(plugin)
  local name = plugin:match ".*/(.*)"
  local package_root = root ".tests/site/pack/deps/start/"
  if not vim.uv.fs_stat(package_root .. name) then
    print("Installing " .. plugin)
    vim
      .system({
        "git",
        "clone",
        "--depth=1",
        "https://github.com/" .. plugin .. ".git",
        package_root .. "/" .. name,
      })
      :wait()
  end
end

install_plug "nvim-lua/plenary.nvim"
install_plug "nvim-treesitter/nvim-treesitter"
install_plug "echasnovski/mini.doc" -- used for docs generation
install_plug "echasnovski/mini.test"

vim.env.XDG_CONFIG_HOME = root ".tests/config"
vim.env.XDG_DATA_HOME = root ".tests/data"
vim.env.XDG_STATE_HOME = root ".tests/state"
vim.env.XDG_CACHE_HOME = root ".tests/cache"

vim.opt.runtimepath:append(root())
vim.opt.packpath:append(root ".tests/site")
vim.notify = vim.print

-- install go treesitter parse
require("nvim-treesitter.install").ensure_installed_sync "go"

require("gopher").setup {
  log_level = vim.log.levels.OFF,
  timeout = 4000,
}

-- setup mini.test only when running headless nvim
if #vim.api.nvim_list_uis() == 0 then
  require("mini.test").setup {
    collect = {
      find_files = function()
        return vim.fn.globpath("spec", "**/*_test.lua", true, true)
      end,
    },
  }
end

-- needed for tests, i dont know the reason why, but on start
-- vim is not able to use treesitter for go by default
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function(args)
    vim.treesitter.start(args.buf, "go")
  end,
})
