local H = {}

local titles = require("plugins.lualine.titles")

H.tab_bufs = function(tabid)
  local bufs = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabid)) do
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

H.tab_display_name = function(tabid)
  local bufs = H.tab_bufs(tabid)
  local name = nil
  for _, buf in ipairs(bufs) do
    local title = titles[vim.bo[buf].filetype]
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

H.tab_name = function(tabnr, tabid)
  local ok, custom = pcall(vim.api.nvim_tabpage_get_var, tabid, "tab_name")
  if ok and custom and custom ~= "" then
    return custom
  end
  if tabnr == 1 then
    return "Main"
  end
  return H.tab_display_name(tabid) or "Tab"
end

H.min_width = 10

H.cell = function(index, tabid, selected)
  local hl_nr = selected and "%#TabLineActiveNr#" or "%#TabLineInactiveNr#"
  local hl = selected and "%#TabLineActive#" or "%#TabLineInactive#"
  local name = H.tab_name(index, tabid)
  local len = vim.fn.strcharlen(name)
  local padding = len >= H.min_width and "  " or string.rep(" ", H.min_width - len)
  return string.format("%%%dT%s %d %s %s%s", index, hl_nr, index, hl, name, padding)
end

H.tabline = function()
  local parts = {}
  local tabs = vim.api.nvim_list_tabpages()
  local current = vim.api.nvim_get_current_tabpage()
  for i, tabid in ipairs(tabs) do
    parts[#parts + 1] = H.cell(i, tabid, tabid == current)
  end
  return table.concat(parts) .. "%#TabLineFill#%T"
end

return H.tabline
