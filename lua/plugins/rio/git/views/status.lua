local H = {}

local actions = require("plugins.rio.git.actions")
local open = require("plugins.rio.open")
local parse = require("plugins.rio.git.parse")
local togglers = require("rio.togglers")

---@type Rio.KeyDef
H.open_path = {
  fn = function(handle)
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
  end,
  desc = "open in split",
}

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
      cc = actions.commit,
      ce = actions.amend,
      st = actions.stash_all,
      su = actions.stash_unstaged,
      ss = actions.stash_staged,
      R = actions.reset_staged,
      tt = togglers.key("porcelain"),
      te = togglers.key("expand_untracked"),
      tu = togglers.key("untracked"),
      ts = togglers.key("submodules"),
    },
  })
end
