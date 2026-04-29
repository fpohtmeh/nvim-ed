local M = {}
local H = {}

local builtin = require("rio.callbacks.builtin")
local git = require("plugins.rio.git")
local process = require("rio.process")

H.run_then_refresh = function(args, handle)
  process.spawn({
    cmd = args,
    cwd = vim.fn.getcwd(),
    on_exit = function(code, _, stderr)
      if code ~= 0 then
        vim.notify(stderr, vim.log.levels.ERROR)
        return
      end
      builtin.refresh()(handle)
    end,
  })
end

M.stage = function(handle)
  local path = git.status_path_under_cursor(handle)
  if not path then
    return
  end
  H.run_then_refresh({ "git", "add", "--", path }, handle)
end

M.unstage = function(handle)
  local path = git.status_path_under_cursor(handle)
  if not path then
    return
  end
  H.run_then_refresh({ "git", "restore", "--staged", "--", path }, handle)
end

M.toggle = function(handle)
  local path = git.status_path_under_cursor(handle)
  if not path then
    return
  end
  if git.is_staged(path) then
    M.unstage(handle)
  else
    M.stage(handle)
  end
end

M.discard = function(handle)
  local path = git.status_path_under_cursor(handle)
  if not path then
    return
  end
  local confirmed = vim.fn.confirm("Discard changes to " .. path .. "?", "&Yes\n&No") == 1
  if not confirmed then
    return
  end
  H.run_then_refresh({ "git", "checkout", "--", path }, handle)
end

return M
