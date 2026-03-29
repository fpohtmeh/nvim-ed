local M = {}
local H = {}

local icons = require("core.icons")

H.filetype = {
  help = { "Help" },
  snacks_terminal = { "Terminal", icons.terminal },
  fugitive = { "Git", icons.git.icon },
  git = { "Git", icons.git.icon },
  gitcommit = { "Commit", icons.git.icon },
  qf = { "Quickfix" },
  oil = { "Files" },
  OverseerList = { "Tasks" },
  OverseerOutput = { "Output" },
}

H.bufname = {
  {
    "^oil://",
    function(bufname)
      return icons.directory .. " " .. bufname:gsub("^oil://", "")
    end,
  },
  { "claude%-prompt%-.*%.md$", icons.prompt .. " Prompt Editor" },
  { "^term://.-//[%d]*:claude%f[%A]", icons.claude .. " Claude" },
}

M.by_filetype = function(ft, opts)
  local entry = H.filetype[ft]
  if not entry then
    return nil
  end
  local label, icon = entry[1], entry[2]
  if icon and (not opts or opts.icons ~= false) then
    return icon .. " " .. label
  end
  return label
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
