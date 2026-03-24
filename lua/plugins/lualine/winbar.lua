local M = {}
local H = {}

local icons = require("core.icons")

H.aliases = {
  help = "Help",
  snacks_terminal = "Terminal",
  fugitive = "Git",
  git = "Git",
  gitcommit = "Commit",
  qf = "Quickfix",
  OverseerList = "Tasks",
  OverseerOutput = "Task output",
}

H.filename = function()
  local ft = vim.bo.filetype
  local alias = H.aliases[ft]
  if alias then
    return alias
  end
  local icon = require("nvim-web-devicons").get_icon(vim.fn.expand("%:t"), nil, { default = true })
  local name = vim.fn.expand("%:.")
  if name == "" then
    name = "[No Name]"
  end
  local modified = vim.bo.modified and " [+]" or ""
  local readonly = vim.bo.readonly and " " .. icons.readonly or ""
  return icon .. " " .. name .. modified .. readonly
end

H.key = function()
  local keys = require("core").keys.window
  local k = keys[vim.api.nvim_win_get_number(0)] or ""
  if k == "" then
    return ""
  end
  return "#" .. k
end

M.filename = { H.filename, color = "WinBar" }
M.filename_inactive = { H.filename, color = "WinBarNC" }
M.key = { H.key, color = "WinBar" }
M.key_inactive = { H.key, color = "WinBarNC" }

return M
