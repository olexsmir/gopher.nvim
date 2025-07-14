local function is_test_file()
  local file = vim.fn.expand "%"

  if #file <= 1 then
    vim.notify("no buffer name", vim.log.levels.ERROR)
    return nil, false, false
  end

  local is_test = string.find(file, "_test%.go$")
  local is_source = string.find(file, "%.go$")

  return file, (not is_test and is_source), is_test
end

local function alternate()
  local file, is_source, is_test = is_test_file()
  if not file then
    return nil
  end

  local alt_file = file

  if is_test then
    alt_file = string.gsub(file, "_test.go", ".go")
  elseif is_source then
    alt_file = vim.fn.expand "%:r" .. "_test.go"
  else
    vim.notify("not a go file", vim.log.levels.ERROR)
  end

  return alt_file
end

local alt = {}

function alt.switch(cmd)
  cmd = cmd or ""

  local alt_file = alternate()

  if #cmd <= 1 then
    local ocmd = "e " .. alt_file
    vim.cmd(ocmd)
  else
    local ocmd = cmd .. " " .. alt_file
    vim.cmd(ocmd)
  end
end

return alt
