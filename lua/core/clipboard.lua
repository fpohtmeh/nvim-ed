local H = {}
local M = {}

H.yank = function(value)
  vim.fn.setreg("+", value)
  Snacks.notify.info("Copied: " .. value)
end

H.git_output = function(args)
  local result = vim.fn.systemlist(args)
  return vim.v.shell_error == 0 and result[1] or nil
end

H.copy = {
  file = {
    full_path = function(p)
      return p
    end,
    dir_path = function(p)
      return vim.fn.fnamemodify(p, ":h") .. "/"
    end,
    filename = function(p)
      return vim.fn.fnamemodify(p, ":t")
    end,
    relative_path = function(p)
      return vim.fn.fnamemodify(p, ":.")
    end,
  },
  oil = {
    full_path = function(dir, entry)
      return dir .. (entry and entry.name or "")
    end,
    dir_path = function(dir, _)
      return dir
    end,
    filename = function(_, entry)
      return entry and entry.name or ""
    end,
    relative_path = function(dir, entry)
      return vim.fn.fnamemodify(dir .. (entry and entry.name or ""), ":.")
    end,
  },
}

H.resolve = function(name)
  if vim.bo.filetype == "oil" then
    local oil = require("oil")
    local dir = require("core.fs").to_unix(oil.get_current_dir())
    return H.copy.oil[name](dir, oil.get_cursor_entry())
  end
  return H.copy.file[name](vim.fn.expand("%:p"))
end

M.yank_filepath = function()
  H.yank(H.resolve("full_path"))
end
M.yank_filename = function()
  H.yank(H.resolve("filename"))
end
M.yank_relative_path = function()
  H.yank(H.resolve("relative_path"))
end
M.yank_directory = function()
  H.yank(H.resolve("dir_path"))
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
  if not branch then return H.yank("not a git repo") end
  local remote = H.git_output("git config branch." .. branch .. ".remote") or "origin"
  H.yank(remote .. "/" .. branch)
end
M.yank_git_origin = function()
  H.yank(H.git_output("git remote get-url origin") or "no remote")
end

return M
