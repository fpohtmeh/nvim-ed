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
  vim.cmd("enew | startinsert")
end

M.save_current_file = function()
  local buf_name = vim.api.nvim_buf_get_name(0)
  local cmd = "w"

  if buf_name == "" then
    local default_dir = vim.fn.getcwd() .. M.path_sep
    local filename = vim.fn.input({ prompt = "Enter file name: ", default = default_dir, completion = "file" })
    if filename == "" then
      Snacks.notify.warn("No filename provided, file not saved.")
      return
    end
    cmd = cmd .. " " .. filename
  end

  local ok, err = pcall(function()
    vim.cmd(cmd)
  end)
  if not ok then
    Snacks.notify.warn("Failed to save file: " .. err)
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

M.rename_current_file = function()
  local current_path = M.buf_full_path()
  if current_path == "" then
    Snacks.notify.warn("No file to rename")
    return
  end
  local new_path = vim.fn.input({ prompt = "New path: ", default = current_path, completion = "file" })
  if new_path == "" or new_path == current_path then
    return
  end

  if M.path_exists(new_path) then
    local choice = vim.fn.confirm("File already exists. Overwrite?", "&Yes\n&No", 2)
    if choice ~= 1 then
      return
    end
  end

  local ok, err = pcall(function()
    os.rename(current_path, new_path)
    vim.cmd.edit(new_path)
    vim.cmd.bdelete("#")
  end)
  if not ok then
    Snacks.notify.warn("Failed to rename file: " .. err)
  end
end

return M
