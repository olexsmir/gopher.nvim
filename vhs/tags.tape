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

Hide Type@0ms "./nvim.sh tags.go" Enter Show

Type@400ms "jjj"
Type ":GoTagAdd json yaml" Sleep 500ms Enter
Type@120ms ":w" Enter
Sleep 1s

Type ":GoTagRm json" Sleep 500ms Enter
Type ":w" Enter
Sleep 1s

Type ":GoTagClear" Sleep 500ms Enter
Type ":w" Enter
Sleep 1s

Type@400ms "jVjj"
Type ":GoTagAdd json=omitempty" Sleep 500ms Enter

Sleep 5s
