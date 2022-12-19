local cur_dir = vim.fn.expand "%:p:h"

describe("gopher.struct_tags", function()
  it("can be required", function()
    require "gopher.struct_tags"
  end)

  it("can add json tag to struct", function()
    local tag = require "gopher.struct_tags"
    local temp_file = vim.fn.tempname() .. ".go"
    local input_file = vim.fn.readfile(cur_dir .. "/spec/fixtures/tags/add_input.go")
    local output_file =
      vim.fn.join(vim.fn.readfile(cur_dir .. "/spec/fixtures/tags/add_output.go"), "\n")

    vim.fn.writefile(input_file, temp_file)
    vim.cmd("silent exe 'e " .. temp_file .. "'")
    vim.bo.filetype = "go"

    local bufn = vim.fn.bufnr(0)
    vim.fn.setpos(".", { bufn, 3, 6, 0 })
    tag.add()

    vim.wait(100)
    assert.are.same(output_file, vim.fn.join(vim.fn.readfile(temp_file), "\n"))

    vim.cmd("bd! " .. temp_file)
  end)

  it("can remove json tag from struct", function()
    local tag = require "gopher.struct_tags"
    local temp_file = vim.fn.tempname() .. ".go"
    local input_file = vim.fn.readfile(cur_dir .. "/spec/fixtures/tags/remove_input.go")
    local output_file =
      vim.fn.join(vim.fn.readfile(cur_dir .. "/spec/fixtures/tags/remove_output.go"), "\n")

    vim.fn.writefile(input_file, temp_file)
    vim.cmd("silent exe 'e " .. temp_file .. "'")
    vim.bo.filetype = "go"

    local bufn = vim.fn.bufnr()
    vim.fn.setpos(".", { bufn, 3, 6, 0 })
    tag.remove()

    vim.wait(100)
    assert.are.same(output_file, vim.fn.join(vim.fn.readfile(temp_file), "\n"))

    vim.cmd("bd! " .. temp_file)
  end)
end)
