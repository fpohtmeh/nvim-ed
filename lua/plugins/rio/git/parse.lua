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

M.stash_ref_under_cursor = function()
  local line = vim.api.nvim_get_current_line()
  return line:match("^(stash@{%d+})")
end

M.hunk_patch_under_cursor = function(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local row = vim.api.nvim_win_get_cursor(0)[1]

  -- find hunk header at or above cursor
  local hunk_start
  for i = row, 1, -1 do
    if lines[i]:match("^@@") then
      hunk_start = i
      break
    end
  end
  if not hunk_start then
    return
  end

  -- find file header above hunk
  local header_start
  for i = hunk_start - 1, 1, -1 do
    if lines[i]:match("^diff %-%-git") then
      header_start = i
      break
    end
  end
  if not header_start then
    return
  end

  -- collect file header lines (up to but not including the hunk line)
  local patch = {}
  for i = header_start, hunk_start - 1 do
    table.insert(patch, lines[i])
  end

  -- collect hunk lines
  for i = hunk_start, #lines do
    local line = lines[i]
    if i > hunk_start and (line:match("^@@") or line:match("^diff %-%-git")) then
      break
    end
    table.insert(patch, line)
  end

  return table.concat(patch, "\n") .. "\n"
end

return M
