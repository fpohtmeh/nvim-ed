local M = {}

M.find_by_filetype = function(filetype)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == filetype then
      return win
    end
  end
end

M.go_to = function(index)
  local ft = vim.bo.filetype
  if (ft == "snacks_terminal" or ft == "terminal") and vim.api.nvim_win_get_config(0).relative ~= "" then
    return
  end
  if index <= vim.fn.winnr("$") then
    vim.cmd(tostring(index) .. " wincmd w")
  end
end

return M
