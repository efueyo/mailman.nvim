local M = {}

function M.read_if_exists(file)
  local fd = io.open(file, "r")
  if fd == nil then
    return nil
  end
  local data = fd:read("*a")
  fd:close()
  return data
end

function M.write_file(file, contents)
  local fd = assert(io.open(file, "w+"))
  fd:write(contents)
  fd:close()
end

return M
