command! -nargs=* GoTagAdd :lua require"gopher".tags.add(<f-args>)
command! -nargs=* GoTagRm :lua require"gopher".tags.rm(<f-args>)
command! GoTestAdd :lua require"gopher".test.add()
command! GoTestsAll :lua require"gopher".test.all()
command! GoTestsExp :lua require"gopher".test.exported()
command! -nargs=* GoMod :lua require"gopher".mod(<f-args>)
command! -nargs=* GoGet :lua require"gopher".get(<f-args>)
command! -nargs=* GoWork :lua require"gopher".work(<f-args>)
command! -nargs=* GoImpl :lua require"gopher".impl(<f-args>)
command! -nargs=* GoGenerate :lua require"gopher".generate(<f-args>)
command! GoCmt :lua require"gopher".comment()
command! GoIfErr :lua require"gopher".iferr()
command! GoInstallDeps :lua require"gopher".install_deps()
command! GoInstallDepsSync :lua require"gopher".install_deps({ sync = true })
command! GopherLog :lua vim.cmd("tabnew " .. require("gopher._utils.log").get_outfile())
