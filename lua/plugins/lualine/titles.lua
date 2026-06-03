local M = {}
local H = {}

local icons = require("core.icons")

H.filetype = {
  help = { "Help" },
  snacks_terminal = { "Terminal", icons.terminal },
  snacks_dashboard = { "Dashboard" },
  fugitive = { "Git", icons.git.icon },
  git = { "Git", icons.git.icon },
  diff = { "Git", icons.git.icon },
  gitcommit = { "Commit", icons.git.icon },
  qf = { "Quickfix" },
  oil = { "Files" },
  OverseerList = { "Tasks" },
  OverseerOutput = { "Output" },
}

-- Each entry: { pattern, label_or_fn, icon? }
-- label_or_fn: string label or function(bufname) -> string label (no icon)
-- icon: optional icon string
H.bufname = {
  {
    "^oil://",
    function(bufname)
      return bufname:gsub("^oil://", "")
    end,
    icons.directory,
  },
  { "claude%-prompt%-.*%.md$", "Prompt Editor", icons.prompt },
  { "^term://.-//[%d]*:claude%f[%A]", "Claude", icons.claude },
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

M.by_bufname = function(bufname, opts)
  for _, entry in ipairs(H.bufname) do
    if bufname:match(entry[1]) then
      local label_or_fn, icon = entry[2], entry[3]
      local label = type(label_or_fn) == "function" and label_or_fn(bufname) or label_or_fn
      if icon and (not opts or opts.icons ~= false) then
        return icon .. " " .. label
      end
      return label
    end
  end
end

return M
