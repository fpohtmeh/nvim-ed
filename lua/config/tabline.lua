local M = {}
local H = {}

H.get_tab_name = function(bufnr)
  local buftype = vim.bo[bufnr].buftype
  if buftype == "terminal" then
    return "[terminal]"
  elseif buftype == "quickfix" then
    return "[quickfix]"
  elseif buftype == "help" then
    return "[help]"
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    local filetype = vim.bo[bufnr].filetype
    if filetype ~= "" then
      return "[" .. filetype .. "]"
    else
      return "[noname]"
    end
  end

  local filename = vim.fn.fnamemodify(name, ":t")
  if filename == "" then
    filename = name
  end
  if #filename > 20 then
    filename = filename:sub(1, 17) .. "..."
  end
  return filename
end

H.render_tab = function(tabnr)
  local is_current = tabnr == vim.fn.tabpagenr()
  local winnr = vim.fn.tabpagewinnr(tabnr)
  local bufnr = vim.fn.tabpagebuflist(tabnr)[winnr]

  local hl = is_current and "%#TabLineActive#" or "%#TabLineInactive#"
  local name = H.get_tab_name(bufnr)
  local click = "%" .. tabnr .. "T"

  return string.format("%s%s %d: %s ", hl, click, tabnr, name)
end

function M.render()
  local tabs = {}
  for i = 1, vim.fn.tabpagenr("$") do
    table.insert(tabs, H.render_tab(i))
  end
  return table.concat(tabs, "") .. "%#TabLineFill#%T"
end

return M
