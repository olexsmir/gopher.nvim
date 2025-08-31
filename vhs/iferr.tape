Output iferr.gif
Require nvim
Require iferr

Set FontFamily "JetBrains Mono"
Set Height 800
Set Width 1500
Set Padding 20
Set Shell "bash"
Set Theme "tokyonight"
Set TypingSpeed 250ms

Hide Type@0ms "./nvim.sh iferr.go" Enter Show

Type "3j"
Type ":GoIfErr" Sleep 500ms Enter

Sleep 5s
