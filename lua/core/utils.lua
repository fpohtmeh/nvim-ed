local M = {}

M.find_window_by_filetype = function(filetype)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == filetype then
      return win
    end
  end
end

return M
