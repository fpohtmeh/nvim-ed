local M = {}

M.commit_hash_under_cursor = function(handle)
  local line = vim.api.nvim_get_current_line()
  if handle.state.toggles.oneline.enabled then
    return line:match("^(%x%x%x%x%x%x%x+)")
  end
  local hash = line:match("^commit (%x+)")
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

M.path_under_cursor = function()
  return vim.fn.getline("."):match("%S+")
end

M.is_staged = function(path)
  local out = vim.fn.systemlist({ "git", "status", "--porcelain", "--", path })
  if #out == 0 then
    return false
  end
  local x = out[1]:sub(1, 1)
  return x ~= " " and x ~= "?"
end

M.status_path_under_cursor = function(handle)
  local line = vim.api.nvim_get_current_line()
  local path
  if handle.state.toggles.porcelain.enabled then
    -- " M path" / "?? path" — first 3 chars are "XY "
    path = line:match("^...(.+)$")
  else
    -- "	modified:   path" / "	new file:   path" or untracked "	path"
    path = line:match("^\t.+:%s+(.+)$") or line:match("^\t(%S.*)$")
  end
  if not path then
    return
  end
  path = path:match("->%s*(.+)$") or path
  -- full format may append extra info: "submodule-name (modified content)"
  return path:match("^(%S+)%s+%(") or path
end

return M
