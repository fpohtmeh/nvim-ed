local M = {}
local H = {}

local icons = require("core.icons")

H.filetype = {
  help = "Help",
  snacks_terminal = "Terminal",
  fugitive = icons.git.icon .. " Git",
  git = icons.git.icon .. " Git",
  gitcommit = icons.git.icon .. " Commit",
  qf = "Quickfix",
  oil = "Files",
  OverseerList = "Tasks",
  OverseerOutput = "Output",
}

H.bufname = {
  {
    "^oil://",
    function(bufname)
      return icons.directory .. " " .. bufname:gsub("^oil://", "")
    end,
  },
  { "claude%-prompt%-.*%.md$", icons.prompt .. " Claude Prompt" },
}

M.by_filetype = function(ft)
  return H.filetype[ft]
end

M.by_bufname = function(bufname)
  for _, entry in ipairs(H.bufname) do
    if bufname:match(entry[1]) then
      local title = entry[2]
      if type(title) == "function" then
        return title(bufname)
      end
      return title
    end
  end
end

return M
