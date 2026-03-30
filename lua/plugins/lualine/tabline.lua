local H = {}

local fs = require("core.fs")
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
  local seen = {}
  local parts = {}
  local has_editor = false
  for _, buf in ipairs(bufs) do
    local bufname = vim.fn.bufname(buf)
    local label = titles.by_filetype(vim.bo[buf].filetype, { icons = false })
    if bufname:match("^term://") then
      label = titles.by_bufname(bufname, { icons = false }) or label
    end
    if label then
      if not seen[label] then
        seen[label] = true
        parts[#parts + 1] = label
      end
    else
      has_editor = true
    end
  end
  if has_editor then
    table.insert(parts, 1, "Editor")
  end
  if #parts == 0 then
    return "Editor"
  end
  return table.concat(parts, ":")
end

H.initial_cwd = vim.fn.getcwd()

H.tab_dir = function(tabnr)
  local tab_cwd = fs.tab_cwd(tabnr)
  if tab_cwd == H.initial_cwd then
    return nil
  end
  return vim.fn.fnamemodify(tab_cwd, ":t")
end

H.min_width = 10

H.cell = function(index, tabid, selected)
  local hl_nr = selected and "%#TabLineActiveNr#" or "%#TabLineInactiveNr#"
  local hl = selected and "%#TabLineActive#" or "%#TabLineInactive#"
  local name = H.tab_display_name(tabid)
  local dir = H.tab_dir(index)
  local hl_dir = selected and "%#TabLineDir#" or "%#TabLineDirInactive#"
  local dir_part = dir and hl_dir .. "[" .. dir .. "] " .. hl or ""
  local full = dir_part .. name
  local len = vim.fn.strcharlen((dir or "") .. (dir and " " or "") .. name)
  local padding = len >= H.min_width and "  " or string.rep(" ", H.min_width - len)
  return string.format("%%%dT%s %d %s %s%s", index, hl_nr, index, hl, full, padding)
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
