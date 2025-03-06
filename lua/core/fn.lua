local M = {}

M.capitalize = function(word)
  if type(word) ~= "string" then
    return nil, "Input must be a string"
  end
  if #word == 0 then
    return ""
  end
  return string.upper(string.sub(word, 1, 1)) .. string.sub(word, 2)
end

M.find_window_by_filetype = function(filetype)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == filetype then
      return win
    end
  end
end

return M
