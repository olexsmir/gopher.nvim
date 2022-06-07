local cur_dir = vim.fn.expand "%:p:h"

describe("gopher.struct_tags", function()
  it("can be required", function()
    require "gopher.struct_tags"
  end)

  it("can add json tag to struct", function()
    local add = require("gopher.struct_tags").add
    local name = vim.fn.tempname() .. ".go"
    local input_file = vim.fn.readfile(cur_dir .. "/spec/fixtures/tags/add_input.go")
    local output_file = vim.fn.join(
      vim.fn.readfile(cur_dir .. "/spec/fixtures/tags/add_output.go"),
      "\n"
    )

    vim.fn.writefile(input_file, name)
    vim.cmd("silent exe 'e " .. name .. "'")

    local bufn = vim.fn.bufnr ""
    vim.bo.filetype = "go"
    vim.fn.setpos(".", { bufn, 3, 6, 0 })
    add()

    vim.wait(100, function() end)
    local fmt = vim.fn.join(vim.fn.readfile(name), "\n")
    assert.are.same(output_file, fmt)

    vim.cmd("bd! " .. name)
  end)

  it("can remove json tag from struct", function()
    local remove = require("gopher.struct_tags").remove
    local name = vim.fn.tempname() .. ".go"
    local input_file = vim.fn.readfile(cur_dir .. "/spec/fixtures/tags/remove_input.go")
    local output_file = vim.fn.join(
      vim.fn.readfile(cur_dir .. "/spec/fixtures/tags/remove_output.go"),
      "\n"
    )

    vim.fn.writefile(input_file, name)
    vim.cmd("silent exe 'e " .. name .. "'")

    local bufn = vim.fn.bufnr ""
    vim.bo.filetype = "go"
    vim.fn.setpos(".", { bufn, 3, 6, 0 })
    remove()

    vim.wait(100, function() end)

    local fmt = vim.fn.join(vim.fn.readfile(name), "\n")
    assert.are.same(output_file, fmt)

    vim.cmd("bd! " .. name)
  end)
end)
