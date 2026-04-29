local H = {}

local actions = require("plugins.rio.git_actions")
local open = require("plugins.rio.open")
local parse = require("plugins.rio.git_parse")
local togglers = require("rio.togglers")

H.open_path = function(handle)
  local path = parse.status_path_under_cursor(handle)
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
  open(path)
end

return function()
  local cmd = "git status {porcelain} {expand_untracked} {untracked} {submodules}"
  require("rio").run(cmd, {
    params = {
      porcelain = togglers.param("porcelain", "--porcelain"),
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
      tt = togglers.key("porcelain"),
      te = togglers.key("expand_untracked"),
      tu = togglers.key("untracked"),
      ts = togglers.key("submodules"),
    },
  })
end
