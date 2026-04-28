local M = {}

M.commit_hash_under_cursor = function()
  local line = vim.api.nvim_get_current_line()
  local hash = line:match("^commit (%x+)") or line:match("^(%x%x%x%x%x%x%x+)")
  if hash then
    return hash
  end
  local row = vim.api.nvim_win_get_cursor(0)[1]
  for i = row - 1, 1, -1 do
    line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
    hash = line:match("^commit (%x+)")
    if hash then
      return hash
    end
  end
end

M.file_under_cursor = function()
  local file = vim.trim(vim.api.nvim_get_current_line())
  if file == "" then
    return nil
  end
  return file
end

return M
