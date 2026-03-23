local M = {}

local keys = require("core").keys.window

M.expression = "%{%v:lua.require('core.winbar').render()%}"
M.ignored_filetypes = { "snacks_dashboard" }

local aliases = {
  help = "Help",
  snacks_terminal = "Terminal",
  fugitive = "Git",
  git = "Git",
  gitcommit = "Commit",
  qf = "quickfix",
  OverseerList = "Tasks",
  OverseerOutput = "Task output",
}

function M.render()
  local ft = vim.bo.filetype
  if vim.tbl_contains(M.ignored_filetypes, ft) then
    return ""
  end
  local key = keys[vim.api.nvim_win_get_number(0)] or ""
  local right = key ~= "" and ("%=  #" .. key .. " ") or ""
  local alias = aliases[ft]
  if alias then
    return "  " .. alias .. right
  end
  local icon = require("nvim-web-devicons").get_icon(vim.fn.expand("%:t"), nil, { default = true })
  local filename = vim.fn.expand("%:.")
  if filename == "" then
    filename = "[No Name]"
  end
  local modified = vim.bo.modified and " [+]" or ""
  local readonly = vim.bo.readonly and " " .. require("core.icons").readonly or ""
  return "  " .. icon .. " " .. filename .. modified .. readonly .. right
end

return M
