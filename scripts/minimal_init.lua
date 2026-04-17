local function root(p)
  local f = debug.getinfo(1, "S").source:sub(2)
  return vim.fn.fnamemodify(f, ":p:h:h") .. "/" .. (p or "")
end

local function install_plug(plugin, branch)
  local name = plugin:match ".*/(.*)"
  local package_root = root ".tests/site/pack/deps/start/"
  if not vim.uv.fs_stat(package_root .. name) then
    local cmd = { "git", "clone", "--depth" }
    if branch then
      table.insert(cmd, "--branch")
      table.insert(cmd, branch)
    end
    table.insert(cmd, "https://github.com/" .. plugin .. ".git")
    table.insert(cmd, package_root .. "/" .. name)

    print("Installing " .. plugin)
    vim.system(cmd):wait()
  end
end

install_plug "echasnovski/mini.doc" -- used for docs generation
install_plug "folke/tokyonight.nvim" -- theme for generating demos
install_plug "echasnovski/mini.test"

if vim.fn.has "nvim-0.12" == 1 then
  install_plug("nvim-treesitter/nvim-treesitter", "main")
else
  install_plug("nvim-treesitter/nvim-treesitter", "master")
end

vim.env.XDG_CONFIG_HOME = root ".tests/config"
vim.env.XDG_DATA_HOME = root ".tests/data"
vim.env.XDG_STATE_HOME = root ".tests/state"
vim.env.XDG_CACHE_HOME = root ".tests/cache"

vim.opt.runtimepath:append(root())
vim.opt.packpath:append(root ".tests/site")
vim.o.swapfile = false
vim.o.writebackup = false
vim.notify = vim.print

-- install go treesitter parse
if vim.fn.has "nvim-0.12" == 1 then
  require("nvim-treesitter").setup { install_dir = vim.fs.joinpath(vim.fn.stdpath "data", "site") }
  require("nvim-treesitter").install({ "go" }):wait()
else
  require("nvim-treesitter.install").ensure_installed_sync "go"
end

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

-- set colorscheme only when running ui
if #vim.api.nvim_list_uis() == 1 then
  vim.cmd.colorscheme "tokyonight-night"
  vim.o.cursorline = true
  vim.o.number = true
end

-- needed for tests, i dont know the reason why, but on start
-- vim is not able to use treesitter for go by default
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function(args)
    vim.treesitter.start(args.buf, "go")
  end,
})
