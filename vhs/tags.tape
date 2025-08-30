Output tags.gif
Require nvim
Require gomodifytags

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

Type "nvim tags.go" Sleep 150ms Enter

Type "3j"
Type ":GoTagAdd json yaml" Sleep 500ms Enter
Type@120ms ":w" Enter
Sleep 1s

Type ":GoTagRm json" Sleep 500ms Enter
Type@120ms ":w" Enter
Sleep 1s

Type ":GoTagClear" Sleep 500ms Enter
Type@120ms ":w" Enter
Sleep 1s

Type "jV2j"
Type ":GoTagAdd xml" Sleep 500ms Enter

Sleep 5s
