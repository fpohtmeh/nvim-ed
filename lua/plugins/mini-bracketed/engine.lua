Bracketed = {}

local M = {}

M.is_disabled = function()
  return false
end

M.error = function(msg)
  error("(mini.bracketed) " .. msg, 0)
end

M.validate_direction = function(direction, choices, fun_name)
  if not vim.tbl_contains(choices, direction) then
    local choices_string = "'" .. table.concat(choices, "', '") .. "'"
    local error_text = string.format("In `%s()` argument `direction` should be one of %s.", fun_name, choices_string)
    M.error(error_text)
  end
end

M.edit = function(path, win_id)
  if type(path) ~= "string" then
    return
  end
  local b = vim.api.nvim_win_get_buf(win_id or 0)
  local try_mimic_buf_reuse = (vim.fn.bufname(b) == "" and vim.bo[b].buftype ~= "quickfix" and not vim.bo[b].modified)
    and (#vim.fn.win_findbuf(b) == 1 and vim.deep_equal(vim.fn.getbufline(b, 1, "$"), { "" }))
  local buf_id = vim.fn.bufadd(vim.fn.fnamemodify(path, ":."))
  pcall(vim.api.nvim_win_set_buf, win_id or 0, buf_id)
  vim.bo[buf_id].buflisted = true
  if try_mimic_buf_reuse then
    pcall(vim.api.nvim_buf_delete, b, { unload = false })
  end
  return buf_id
end

return M
