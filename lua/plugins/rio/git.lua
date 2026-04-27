local M = {}

M.commit_hash_under_cursor = function()
  local line = vim.api.nvim_get_current_line()
  return line:match("^(%x+)")
end

return M
