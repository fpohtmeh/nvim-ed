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

M.buf_name = function(buf)
  return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf or 0), ":t")
end

M.create_new_file = function()
  local filename = vim.fn.input("Enter file name: ")
  if filename == "" then
    vim.cmd("enew | startinsert")
  else
    local file = io.open(filename, "w")
    if file then
      file:close()
      vim.cmd("edit " .. filename)
    else
      Snacks.notify.warn("Failed to create file: " .. filename)
    end
  end
end

M.delete_current_file = function()
  local short_path = M.buf_name()
  local full_path = M.buf_full_path()

  local choice = vim.fn.confirm("Delete " .. short_path .. "?", "&Yes\n&No", 2)
  if choice ~= 1 then
    Snacks.notify.warn("Operation cancelled.")
    return
  end

  Snacks.bufdelete({ force = true })
  if M.path_exists(full_path) then
    if os.remove(full_path) then
      Snacks.notify.info("File deleted: " .. short_path)
    else
      Snacks.notify.warn("Failed to delete file: " .. short_path)
    end
  end
end

return M
