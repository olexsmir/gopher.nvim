.PHONY:
.SILENT:

format:
	stylua **/*.lua

lint:
	selene **/*.lua

test:
	nvim --headless -u ./spec/minimal_init.vim  -c "PlenaryBustedDirectory spec {minimal_init='./spec/minimal_init.vim'}"
