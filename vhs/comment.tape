Output comment.gif
Require nvim

Set FontFamily "JetBrains Mono"
Set Height 800
Set Width 1500
Set Padding 20
Set Shell "bash"
Set Theme "tokyonight"
Set TypingSpeed 250ms

Hide
Type@0ms "alias nvim='./nvim.sh'" Enter
Type@0ms "clear" Enter
Show

Type "nvim comment.go" Sleep 150ms Enter

# package
Type ":GoCmt" Enter Sleep 500ms Escape Sleep 700ms

# func
Type "3j"
Type ":GoCmt" Enter Sleep 500ms Escape Sleep 700ms

# struct
Type "3j"
Type ":GoCmt" Enter Sleep 500ms Escape Sleep 700ms

# interface
Type "3j"
Type ":GoCmt" Enter Sleep 500ms Escape Sleep 700ms

Sleep 5s
