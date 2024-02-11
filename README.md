# gopher.nvim

[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner-direct-single.svg)](https://stand-with-ukraine.pp.ua)

Minimalistic plugin for Go development in Neovim written in Lua.

It's not an LSP tool, the main goal of this plugin is add go tooling support in Neovim.

## Install

Pre-dependency: [go](https://github.com/golang/go) (tested on 1.17 and 1.18)

```lua
use {
  "olexsmir/gopher.nvim",
  requires = { -- dependencies
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
}
```

Also, run `TSInstall go` if `go` parser if isn't installed yet.

## Config

By `.setup` function you can configure the plugin.

Note:

- `installer` does not install the tool in user set path

```lua
require("gopher").setup {
  commands = {
    go = "go",
    gomodifytags = "gomodifytags",
    gotests = "~/go/bin/gotests", -- also you can set custom command path
    impl = "impl",
    iferr = "iferr",
  },
  gotests = {
    -- gotests doesn't have template named "default" so this plugin uses "default" to set the default template
    template = "default",
    -- path to a directory containing custom test code templates
    template_dir = nil,
    -- switch table tests from using slice to map (with test name for the key)
    -- works only with gotests installed from develop branch
    named = false,
  },
}
```

### Named tests with testify (using map instead of slice for test cases)

```lua
require("gopher").setup({
  gotests = {
    template = "testify",
    named = true
  }
})
```

For named tests to work you have to install gotests from develop branch, for example using [mason-tool-installer](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim):

```lua
 require('mason-tool-installer').setup({
  ensure_installed = {
    { "gotests", version = "develop" },
  }
})
```

Or by calling `vim.fn.jobstart`:

```lua
vim.fn.jobstart("go install github.com/cweill/gotests/...@develop")
```

If you're using `lazy.nvim` you can put in `build` function inside `setup()`

## Features

1. Installation requires this go tool:

```vim
:GoInstallDeps
```

It will install next tools:

- [gomodifytags](https://github.com/fatih/gomodifytags)
- [impl](https://github.com/josharian/impl)
- [gotests](https://github.com/cweill/gotests)
- [iferr](https://github.com/koron/iferr)

2. Modify struct tags:
  By default `json` tag will be added/removed, if not set:

```vim
:GoTagAdd json " For add json tag
:GoTagRm yaml " For remove yaml tag
```

3. Run `go mod` command:

```vim
:GoMod tidy " Runs `go mod tidy`
:GoMod init asdf " Runs `go mod init asdf`
```

4. Run `go get` command

Link can have a `http` or `https` prefix.

You can provide more than one package url:

```vim
:GoGet github.com/gorilla/mux
```

5. Interface implementation

Command syntax:

```vim
:GoImpl [receiver] [interface]

" Also you can put cursor on the struct and run:
:GoImpl [interface]
```

Example of usage:

```vim
" Example
:GoImpl r Read io.Reader
" or simply put your cursor in the struct and run:
:GoImpl io.Reader
```

6. Generate tests with [gotests](https://github.com/cweill/gotests)

Generate one test for a specific function/method:

```vim
:GoTestAdd
```

Generate all tests for all functions/methods in current file:

```vim
:GoTestsAll
```

Generate tests only for exported functions/methods in current file:

```vim
:GoTestsExp
```

7. Run `go generate` command;

```vim
" Run `go generate` in cwd path
:GoGenerate

" Run `go generate` for current file
:GoGenerate %
```

8. Generate doc comment

First set a cursor on **public** package/function/interface/struct and execute:

```vim
:GoCmt
```

9. Generate `if err`

Set cursor on the line with **err** and execute:

```vim
:GoIfErr
```

10. Setup nvim-dap for go in one line.

Notice: [nvim-dap](https://github.com/mfussenegger/nvim-dap) is required

```lua
require"gopher.dap".setup()
```

## Contributing

PRs are always welcome. See [CONTRIBUTING.md](./CONTRIBUTING.md)

## Thanks

- [go.nvim](https://github.com/ray-x/go.nvim)
- [nvim-dap-go](https://github.com/leoluz/nvim-dap-go)
