local M = {}

M.path_sep = package.config:sub(1, 1)

M.cwd = function()
  return vim.fn.getcwd()
end

M.path_exists = function(path)
  return vim.uv.fs_stat(path) and true or false
end

M.join = function(path, name)
  return path .. M.path_sep .. name
end

M.to_escaped = function(path)
  return path:gsub(" ", "\\ ")
end

M.to_native = function(path)
  if M.path_sep == "\\" then
    return path:gsub("/", "\\")
  elseif M.path_sep == "/" then
    return path:gsub("\\", "/")
  else
    return path
  end
end

M.buf_full_path = function(buf)
  return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf or 0), ":p")
end

return M
