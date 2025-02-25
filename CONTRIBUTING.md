# Contributing to `gopher.nvim`

Thank you for taking the time to submit some code to gopher.nvim. It means a lot!

### Task running

In this codebase for running tasks is used [Taskfile](https://taskfile.dev).
You can install it with:
```bash
go install github.com/go-task/task/v3/cmd/task@latest
```

### Styling and formatting

Code is formatted by [stylua](https://github.com/JohnnyMorganz/StyLua) and linted using [selene](https://github.com/Kampfkarren/selene).
You can install these with:

```bash
sudo pacman -S selene stylua
# or whatever is your package manager
```

For formatting use this following commands, or setup your editor to integrate with selene/stylua:
```bash
task format
task format:check  # will check if your code formatted
task lint
```

### Documentation

Here we are using [mini.doc](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-doc.md)
for generating help files based on EmmyLua-like annotations in comments

You can generate docs with:
```bash
task docgen
```

### Commit messages

We use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/), please follow it.

### Testing

For testing this plugins uses [plenary.nvim](https://github.com/nvim-lua/plenary.nvim).
All tests live in [/spec](https://github.com/olexsmir/gopher.nvim/tree/main/spec) dir.

You can run tests with:
```bash
task tests
```
