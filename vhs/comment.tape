Output comment.gif
Require nvim

Set FontFamily "JetBrains Mono"
Set Height 800
Set Width 1500
Set Padding 20
Set Shell "bash"
Set Theme "tokyonight"
Set TypingSpeed 250ms

Hide Type@0ms "./nvim.sh comment.go" Enter Show

# package
Type ":GoCmt" Enter Sleep 500ms Escape Sleep 700ms

# func
Type@400ms "jjj"
Type ":GoCmt" Enter Sleep 500ms Escape Sleep 700ms

# struct
Type@400ms "jjj"
Type ":GoCmt" Enter Sleep 500ms Escape Sleep 700ms

# interface
Type@400ms "jjj"
Type ":GoCmt" Enter Sleep 500ms Escape Sleep 700ms

Sleep 5s
