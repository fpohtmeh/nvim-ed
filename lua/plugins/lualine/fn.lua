local M = {}
local H = {}

H.display_names = {
  help = "Help",
  snacks_terminal = "Terminal",
  fugitive = "Git",
  git = "Git",
  gitcommit = "Commit",
  qf = "Quickfix",
  OverseerList = "Tasks",
  OverseerOutput = "Task output",
}

function M.display_name(filetype)
  return H.display_names[filetype]
end

return M
