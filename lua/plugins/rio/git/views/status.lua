local H = {}

local actions = require("plugins.rio.git.actions")
local open = require("plugins.rio.open")
local togglers = require("rio.togglers")

H.parser = {
  ---@type fun(param: string, handle: Rio.Handle): string?
  parse = function(param, handle)
    if param ~= "path" then
      return nil
    end
    local cursor = vim.api.nvim_win_get_cursor(handle.state.win)
    local line = vim.api.nvim_buf_get_lines(handle.state.buf, cursor[1] - 1, cursor[1], false)[1]
    local path
    if handle.state.toggles.porcelain.enabled then
      path = line:match("^...(.+)$")
    else
      path = line:match("^\t.+:%s+(.+)$") or line:match("^\t(%S.*)$")
    end
    if not path then
      return nil
    end
    path = path:match("->%s*(.+)$") or path
    return path:match("^(%S+)%s+%(") or path
  end,
}

---@type Rio.KeyDef
H.open_path = {
  action = function(handle)
    local path = H.parser.parse("path", handle)
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
  group = "Navigate",
}

return function()
  local cmd = "git status {porcelain} {expand_untracked} {untracked} {submodules}"
  require("rio").run(cmd, {
    parsers = { H.parser },
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
      a = actions.stage_all,
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
