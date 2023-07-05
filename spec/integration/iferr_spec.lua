local cur_dir = vim.fn.expand "%:p:h"

describe("gopher.iferr", function()
  it("should be able to add iferr", function()
    local temp_file = vim.fn.tempname() .. ".go"
    local input_file = vim.fn.readfile(cur_dir .. "/spec/fixtures/iferr/input.go")
    local output_file = vim.fn.join(vim.fn.readfile(cur_dir .. "/spec/fixtures/iferr/output.go"), "\n")

    vim.fn.writefile(input_file, temp_file)
    vim.bo.filetype = "go"
    vim.cmd("silent exe 'e " .. temp_file .. "'")

    local bufn = vim.fn.bufnr(0)
    vim.fn.setpos(".", { bufn, 6, 4, 0 })
    require "gopher.iferr"()
    vim.cmd "w"

    vim.wait(100)
    assert.are.same(output_file, vim.fn.join(vim.fn.readfile(temp_file), "\n"))
    vim.cmd("bd! " .. temp_file)
  end)
end)
