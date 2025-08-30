Output impl.gif
Require nvim
Require iferr

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

Type "nvim impl.go" Sleep 150ms Enter

Type "2j"
Type ":GoImpl io.Reader" Sleep 500ms Enter

Sleep 5s
