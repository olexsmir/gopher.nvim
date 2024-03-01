# gopher.nvim

[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner-direct-single.svg)](https://stand-with-ukraine.pp.ua)

Minimalistic plugin for Go development in Neovim written in Lua.

It's **NOT** an LSP tool, the main goal of this plugin is to add go tooling support in Neovim.

## Install (using [lazy.nvim](https://github.com/folke/lazy.nvim)

Pre-dependency:

- [go](https://github.com/golang/go) (tested on 1.17 and 1.18)
- Go treesitter parser, install by `:TSInstall go`

```lua
{
  "olexsmir/gopher.nvim",
  ft = "go",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "mfussenegger/nvim-dap", -- (optional) only if you use `gopher.dap`
  },
  -- (optional) update plugin's deps on every update
  build = function()
    vim.cmd.GoInstallDeps()
  end,
  ---@type gopher.Config
  opts = {},
}
```

## Configuratoin

>[!IMPORTANT]
>
> If you need more info look `:h gopher.nvim`

```lua
require("gopher").setup {
  commands = {
    go = "go",
    gomodifytags = "gomodifytags",
    gotests = "~/go/bin/gotests", -- also you can set custom command path
  },
  gotests = {
    template = "default",
  },
  gotag = {
    transform = "pascalcase"
  }
}
```

>[!NOTE]
>
> <details>
>   <summary>
>     For named tests to work you have to install gotests from develop branch. Next code snippets could be placed into the build step in the Lazy plugin declaration
>   </summary>
>
>   ```lua
>   -- using mason-tool-installer
>   require("mason-tool-installer").setup {
>     ensure_installed = {
>       { "gotests", version = "develop" },
>     }
>   }
>
>   -- using `vim.fn.jobstart`
>   vim.fn.jobstart("go install github.com/cweill/gotests/...@develop")
>   ```
> </details>

## Features

<!-- markdownlint-disable -->

<details>
  <summary>
    <b>Install plugin's go deps</b>
  </summary>

  ```vim
  :GoInstallDeps
  ```

  This will install the following tools:

  - [gomodifytags](https://github.com/fatih/gomodifytags)
  - [impl](https://github.com/josharian/impl)
  - [gotests](https://github.com/cweill/gotests)
  - [iferr](https://github.com/koron/iferr)
  - [dlv](github.com/go-delve/delve/cmd/dlv)
</details>

<details>
  <summary>
    <b>Add and remove tags for structs via <a href="https://github.com/fatih/gomodifytags">gomodifytags</a>)</b>
  </summary>

  By default `json` tag will be added/removed, if not set:

  ```vim
  " add json tag
  :GoTagAdd json

  " remove yaml tag
  :GoTagRm yaml
  ```

  ```lua
  --- or you can use lua api
  require("gopher").tags.add "xml"
  require("gopher").tags.rm  "proto"
  ```
</details>

<details>
  <summary>
    <b>Generating tests via <a href="https://github.com/cweill/gotests">gotests</a></b>
  </summary>

  ```vim
  " Generate one test for a specific function/method(one under cursor)
  :GoTestAdd

  " Generate all tests for all functions/methods in the current file
  :GoTestsAll

  " Generate tests only for exported functions/methods in the current file:
  :GoTestsExp
  ```

  ```lua
  --- or you can use lua api
  require("gopher").test.add()
  ```
</details>

<details>
  <summary>
    <b>Run commands like `go mod/get/etc` inside of nvim</b>
  </summary>

  ```vim
  :GoGet github.com/gorilla/mux

  " Link can have an `http` or `https` prefix.
  :GoGet https://github.com/lib/pq

  " You can provide more than one package url
  :GoGet github.com/jackc/pgx/v5 github.com/google/uuid/

  " go mod commands
  :GoMod tidy
  :GoMod init new-shiny-project

  " go work commands
  :GoWork sync

  " run go generate in cwd
  :GoGenerate

  " run go generate for the current file
  :GoGenerate %
  ```
</details>

<details>
  <summary>
    <b>Interface implementation via <a href="https://github.com/josharian/impl">impl<a></b>
  </summary>

  Syntax of the command:
  ```vim
  :GoImpl [receiver] [interface]

  " also you can put a cursor on the struct and run
  :GoImpl [interface]
  ```

  Usage examples:
  ```vim
  :GoImpl r Read io.Reader
  :GoImpl Write io.Writer

  " or you can put a cursor on the struct and run
  :GoImpl io.Reader
  ```
</details>

<details>
  <summary>
    <b>Generate boilerplate for doc comments</b>
  </summary>

  First set a cursor on **public** package/function/interface/struct and execute:

  ```vim
  :GoCmt
  ```
</details>


<details>
  <summary>
    <b>Generate `if err != nil {` via <a href="https://github.com/koron/iferr">iferr</a></b>
  </summary>

  Set the cursor on the line with `err` and execute

  ```vim
  :GoIfErr
  ```
</details>

<details>
  <summary>
    <b>Setup <a href="https://github.com/mfussenegger/nvim-dap">nvim-dap</a> for go in one line</b>
  </summary>

>[!IMPORTANT]
>
> [nvim-dap](https://github.com/mfussenegger/nvim-dap) has to be installed

  ```lua
  require("gopher.dap").setup()
  ```
</details>

## Contributing

PRs are always welcome. See [CONTRIBUTING.md](./CONTRIBUTING.md)

## Thanks

- [go.nvim](https://github.com/ray-x/go.nvim)
- [nvim-dap-go](https://github.com/leoluz/nvim-dap-go)
- [iferr](https://github.com/koron/iferr)
