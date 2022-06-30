# gopher.nvim

Minimalistic plugin for Go development in Neovim written in Lua.

It's not an LSP tool, the main goal of this plugin add go tooling support in neovim.

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

Also, run `TSInstall go` if install the `go` parser if not installed yet.

## Config

By `.setup` function you can configure the plugin.

Note:

- Installer does not install the tool in user set path

```lua
require("gopher").setup {
  commands = {
    go = "go",
    gomodifytags = "gomodifytags",
    gotests = "~/go/bin/gotests", -- also you can set custom command path
    impl = "impl",
  },
}
```

## Features

1. Install requires go tools:

```vim
:GoInstallDeps
```

This will install next tools:

- [gomodifytags](https://github.com/fatih/gomodifytags)
- [impl](https://github.com/josharian/impl)
- [gotests](https://github.com/cweill/gotests)

2. Modify struct tags:
By default be added/removed `json` tag, if not set.

```vim
:GoTagAdd json " For add json tag
:GoTagRm yaml " For remove yaml tag
```

3. Run `go mod` command

```vim
:GoMod tidy " Runs `go mod tidy`
:GoMod init asdf " Runs `go mod init asdf`
```

4. Run `go get` command

Link can has a `http` or `https` prefix.

You can provide more that one package url.

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

Generate one test for spesific function/method

```vim
:GoTestAdd
```

Generate all tests for all functions/methods in current file

```vim
:GoTestsAll
```

Generate tests only for exported functions/methods in current file

```vim
:GoTestsExp
```

7. Run `go generate` command

```vim
" Run `go generate` in cwd path
:GoGenerate

" Run `go generate` for current file
:GoGenerate %
```

8. Generate doc comment

First set a cursor on **public** package/function/interface/struct and execure:

```vim
:GoCmt
```

## Thanks

- [go.nvim](https://github.com/ray-x/go.nvim)
