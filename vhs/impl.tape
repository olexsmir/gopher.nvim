Output impl.gif
Require nvim
Require impl

Set FontFamily "JetBrains Mono"
Set Height 800
Set Width 1500
Set Padding 20
Set Shell "bash"
Set Theme "tokyonight"
Set TypingSpeed 250ms

Hide Type@0ms "./nvim.sh impl.go" Enter Show

Type "2j"
Type ":GoImpl c io.Reader" Sleep 700ms Enter

Sleep 5s
