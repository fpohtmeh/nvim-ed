local H = {}

local actions = require("plugins.rio.git_actions")
local git = require("plugins.rio.git")
local togglers = require("rio.togglers")

H.open_path = function(handle)
  local path = git.status_path_under_cursor(handle)
  if not path then
    return
  end
  local win = handle.state.path_win
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_current_win(win)
    vim.cmd("edit " .. vim.fn.fnameescape(path))
  else
    vim.cmd("vsplit " .. vim.fn.fnameescape(path))
    handle.state.path_win = vim.api.nvim_get_current_win()
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
