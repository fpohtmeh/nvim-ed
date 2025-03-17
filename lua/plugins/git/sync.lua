local M = {}
local H = {}

H.is_invalidated = false

function H.is_fugitive_buffer(buf)
  local bufname = vim.api.nvim_buf_get_name(buf)
  return vim.startswith(bufname, "fugitive:")
end

function H.is_fugitive_opened()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if H.is_fugitive_buffer(buf) then
      return true
    end
  end
  return false
end

H.close_fugitive_windows = function()
  local wins = vim.api.nvim_list_wins()
  if #wins == 1 then
    return
  end
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    if H.is_fugitive_buffer(buf) then
      vim.api.nvim_win_close(win, true)
    end
  end
end

H.attach_to_fugitive_buf = function(buf)
  local function refresh()
    if not H.is_invalidated then
      return
    end

    H.is_invalidated = false
    vim.schedule(function()
      vim.cmd.edit()
    end)
  end

  vim.api.nvim_create_autocmd("BufEnter", {
    buffer = buf,
    callback = refresh,
  })
end

M.create_autocmds = function()
  vim.api.nvim_create_autocmd("User", {
    pattern = "PersistenceSavePre",
    callback = H.close_fugitive_windows,
  })

  vim.api.nvim_create_autocmd({ "TermClose", "TermLeave" }, {
    callback = M.touch_hunks,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "fugitive",
    callback = function(event)
      H.attach_to_fugitive_buf(event.buf)
    end,
  })
end

M.touch_hunks = function()
  H.is_invalidated = H.is_fugitive_opened()
end

return M
