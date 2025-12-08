Output json2go.gif
Require nvim
Require json2go

Set FontFamily "JetBrains Mono"
Set Height 800
Set Width 1500
Set Padding 20
Set Shell "bash"
Set Theme "tokyonight"
Set TypingSpeed 250ms

Hide Type@0ms "./nvim.sh json2go.go" Enter Show

Type@0ms "G"
Type@400ms ":GoJson" Sleep 500ms Enter
Type@70ms "{" Enter
Type@70ms `"json": true,` Enter
Type@70ms `"user": {"name": "Name", "of_age": true}` Enter
Type@70ms "}"
Escape Type@500ms ":wq" Enter
Sleep 1s

Type@25ms "G2o" Escape
Type@120ms `:GoJson {"json": true}` Enter

Sleep 5s
