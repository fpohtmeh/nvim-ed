local M = {}
local H = {}

local icons = require("core.icons")
local titles = require("plugins.lualine.titles")

H.predefined_filenames = {
  oil = function()
    return icons.directory .. " " .. vim.fn.expand("%:p"):gsub("^oil://", "")
  end,
}

H.filename = function()
  local ft = vim.bo.filetype
  local filename = H.predefined_filenames[ft]
  if filename then
    return filename()
  end

  local title = titles[ft]
  if title then
    return title
  end
  icon = require("nvim-web-devicons").get_icon(vim.fn.expand("%:t"), nil, { default = true })
  name = vim.fn.expand("%:.")
  if name == "" then
    name = "[No Name]"
  end

  local modified = vim.bo.modified and (" " .. core.modified) or ""
  local readonly = vim.bo.readonly and " " .. icons.readonly or ""
  return icon .. " " .. name .. modified .. readonly
end

H.key = function()
  local keys = require("core").keys.window
  local k = keys[vim.api.nvim_win_get_number(0)] or ""
  return k ~= "" and "#" .. k or ""
end

M.filename = { H.filename, color = "WinBar" }
M.filename_inactive = { H.filename, color = "WinBarNC" }
M.key = { H.key, color = "WinBar" }
M.key_inactive = { H.key, color = "WinBarNC" }

return M
