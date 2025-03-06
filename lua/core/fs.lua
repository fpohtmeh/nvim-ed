local M = {}

M.path_exists = function(path)
  return vim.loop.fs_stat(path) and true or false
end

M.to_escaped = function(path)
  return path:gsub(" ", "\\ ")
end

M.to_native = function(path)
  local separator = package.config:sub(1, 1)
  if separator == "\\" then
    path = path:gsub("/", "\\")
  elseif separator == "/" then
    path = path:gsub("\\", "/")
  end
  return path
end

return M
