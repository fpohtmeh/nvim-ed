local M = {}

M.commit_hash_under_cursor = function()
  local line = vim.api.nvim_get_current_line()
  return line:match("^(%x+)")
end

M.file_under_cursor = function()
  local file = vim.trim(vim.api.nvim_get_current_line())
  if file == "" then
    return nil
  end
  return file
end

return M
