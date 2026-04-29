local H = {}

local actions = require("plugins.rio.git_actions")
local git = require("plugins.rio.git")
local togglers = require("rio.togglers")

H.open_file = function(path)
  vim.cmd("edit " .. vim.fn.fnameescape(path))
end

H.open_dir = function(path)
  local ok, oil = pcall(require, "oil")
  if ok then
    oil.open(path)
  else
    H.open_file(path)
  end
end

H.open_path = function(handle)
  local path = git.status_path_under_cursor(handle)
  if not path then
    return
  end
  local win = handle.state.path_win
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_current_win(win)
  else
    vim.cmd("vsplit")
    handle.state.path_win = vim.api.nvim_get_current_win()
  end
  if vim.fn.isdirectory(path) == 1 then
    H.open_dir(path)
  else
    H.open_file(path)
  end
end

return function()
  local cmd = "git status {short} {expand_untracked} {untracked} {submodules}"
  require("rio").run(cmd, {
    params = {
      short = togglers.param("short", "--short"),
      expand_untracked = togglers.param("expand_untracked", "-uall"),
      untracked = togglers.param("untracked", "-uno", false),
      submodules = togglers.param("submodules", "--ignore-submodules", false),
    },
    keys = {
      ["<CR>"] = H.open_path,
      ["-"] = actions.toggle,
      s = actions.stage,
      u = actions.unstage,
      X = actions.discard,
      tt = togglers.key("short"),
      te = togglers.key("expand_untracked"),
      tu = togglers.key("untracked"),
      ts = togglers.key("submodules"),
    },
  })
end
