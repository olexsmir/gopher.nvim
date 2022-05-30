# gopher.nvim

Minimalistic plugin for Go development in Neovim written in Lua.

It's not an LSP tool, the main goal of this plugin add go tooling support in neovim

## Install
Pre-dependency: [go](https://github.com/golang/go) (tested on 1.17 and 1.18)

```lua
use {
    "olexsmir/gopher.nvim",
    requires = {
        "nvim-treesitter/nvim-treesitter", -- dependencie
    },
}
```

Also, run `TSInstall go` if install the `go` parser if not installed yet.

## Features
1. Install requires go tools:
```lua
require"gopher".install_deps()
```

1. Modify struct tags by:
`json` default tag for add & remove

```lua
require"gopher".tags_add("json") -- add json tag
require"gopher".tags_rm("json")  -- remove json tag
```
