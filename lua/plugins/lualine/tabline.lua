local H = {}

local fn = require("plugins.lualine.fn")

H.tab_bufs = function(tabnr)
  local bufs = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabnr)) do
    local is_float = vim.api.nvim_win_get_config(win).relative ~= ""
    if not is_float then
      local buf = vim.api.nvim_win_get_buf(win)
      local is_empty = vim.fn.bufname(buf) == "" and vim.bo[buf].filetype == ""
      if not is_empty then
        bufs[#bufs + 1] = buf
      end
    end
  end
  return bufs
end

H.tab_display_name = function(tabnr)
  local bufs = H.tab_bufs(tabnr)
  local name = nil
  for _, buf in ipairs(bufs) do
    local title = fn.display_name(vim.bo[buf].filetype)
    if not title then
      return nil
    end
    if name and name ~= title then
      return nil
    end
    name = title
  end
  return name
end

H.tab_name = function(tabnr)
  local ok, custom = pcall(vim.api.nvim_tabpage_get_var, vim.api.nvim_list_tabpages()[tabnr], "tab_name")
  if ok and custom and custom ~= "" then
    return custom
  end
  if tabnr == 1 then
    return "Main"
  end
  return H.tab_display_name(tabnr) or "Tab"
end

H.cell = function(index, selected)
  local hl = selected and "%#TabLineActive#" or "%#TabLineInactive#"
  local name = H.tab_name(index)
  return string.format("%s%%%dT %d %s ", hl, index, index, name)
end

H.tabline = function()
  local parts = {}
  local tab_count = vim.fn.tabpagenr("$")
  for i = 1, tab_count do
    parts[#parts + 1] = H.cell(i, vim.fn.tabpagenr() == i)
  end
  return table.concat(parts) .. "%#TabLineFill#%T"
end

return H.tabline
