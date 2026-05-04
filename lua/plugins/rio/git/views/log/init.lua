local H = {}

local builtin = require("rio.callbacks.builtin")
local rio = require("rio")
local togglers = require("rio.togglers")
local win_builtin = require("rio.resolver.win.builtin")
local diff = require("plugins.rio.git.views.diff")
local file_view = require("plugins.rio.git.views.log.file")
local util = require("plugins.rio.git.util")

---@type Rio.Parser
H.parser = {
  parse = function(param, handle)
    if param ~= "commit" then
      return nil
    end
    local cursor = vim.api.nvim_win_get_cursor(handle.state.win)
    local line = vim.api.nvim_buf_get_lines(handle.state.buf, cursor[1] - 1, cursor[1], false)[1]
    local hash = line:match("^(%x%x%x%x%x%x%x+)") or line:match("^commit (%x+)")
    if hash then
      return hash
    end
    for i = cursor[1] - 1, 1, -1 do
      line = vim.api.nvim_buf_get_lines(handle.state.buf, i - 1, i, false)[1]
      hash = line:match("^commit (%x+)")
      if hash then
        return hash
      end
    end
  end,
}

---@type Rio.KeyDef
H.open_commit_diff = {
  action = diff.for_commit,
  desc = "open diff",
  group = "Navigate",
}

---@type Rio.KeyDef
H.reset_last_commit = {
  action = function(handle)
    util.run_then_refresh("git reset HEAD~1", handle, {
      util.confirm_action("Reset last commit?"),
    })
  end,
  desc = "reset last commit",
  group = "Reset",
}

---@type Rio.KeyDef
H.pull = {
  action = function(handle)
    util.run_then_refresh("git pull", handle)
  end,
  desc = "pull",
  group = "Remote",
}

---@type Rio.KeyDef
H.push = {
  action = function(handle)
    util.run_then_refresh("git push", handle)
  end,
  desc = "push",
  group = "Remote",
}

---@param opts? { oneline?: boolean, file?: boolean }
return function(opts)
  opts = opts or {}
  local oneline = opts.oneline ~= false
  local file = opts.file and vim.fn.expand("%:.") or nil
  local cmd = "git log {limit} {oneline} {merges} {decorate}" .. (file and " -- {file}" or "")
  rio.run(cmd, {
    resolver = {
      win = { win_builtin.reuse, win_builtin.current },
    },
    callbacks = {
      on_finish = { builtin.set_filetype("git") },
    },
    params = {
      file = file or "",
      limit = togglers.param("limit", "-100"),
      oneline = togglers.param("oneline", "--oneline", oneline),
      merges = togglers.switch("merges", "", "--no-merges"),
      decorate = togglers.param("decorate", "--decorate"),
    },
    parsers = { H.parser },
    keys = {
      ["<CR>"] = H.open_commit_diff,
      R = H.reset_last_commit,
      o = file and file_view.show_at_commit(file) or false,
      d = file and file_view.show_diff_at_commit or false,
      p = H.pull,
      P = H.push,
      tl = togglers.key("limit"),
      tt = togglers.key("oneline"),
      tm = togglers.key("merges"),
      td = togglers.key("decorate"),
    },
  })
end
