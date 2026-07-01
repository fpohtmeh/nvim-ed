local H = {}
local M = {}

local context = require("core.context")

H.yank = function(value)
  vim.fn.setreg("+", value)
  Snacks.notify.info("Copied: " .. value)
end

H.git_output = function(args)
  local result = vim.fn.systemlist(args)
  return vim.v.shell_error == 0 and result[1] or nil
end

M.yank_filepath = function()
  H.yank(table.concat(context.selection.full_path, "\n"))
end
M.yank_filename = function()
  H.yank(table.concat(context.selection.filename, "\n"))
end
M.yank_relative_path = function()
  H.yank(table.concat(context.selection.relative_path, "\n"))
end
M.yank_directory = function()
  H.yank(context.current.dir_path)
end
M.yank_git_branch = function()
  H.yank(H.git_output("git branch --show-current") or "not a git repo")
end
M.yank_git_commit = function()
  H.yank(H.git_output("git log -1 --format=%H") or "no commits")
end
M.yank_git_short_commit = function()
  H.yank(H.git_output("git log -1 --format=%h") or "no commits")
end
M.yank_git_remote_branch = function()
  local branch = H.git_output("git branch --show-current")
  if not branch then
    return H.yank("not a git repo")
  end
  local remote = H.git_output("git config branch." .. branch .. ".remote") or "origin"
  H.yank(remote .. "/" .. branch)
end
M.yank_git_origin = function()
  H.yank(H.git_output("git remote get-url origin") or "no remote")
end

return M
