local H = {}

local builtin = require("rio.callbacks.builtin")
local togglers = require("rio.togglers")
local util = require("plugins.rio.git.util")

---@type Rio.KeyDef
H.open_commit_diff = {
  fn = function(handle)
    local hash = require("plugins.rio.git.parse").commit_hash_under_cursor(handle)
    if not hash then
      return
    end
    require("plugins.rio.git.views.diff").commit(hash, handle.state)
  end,
  desc = "open diff",
}

---@type Rio.KeyDef
H.reset_last_commit = {
  fn = function(handle)
    if not util.confirm("Reset last commit?") then
      return
    end
    util.run_then_refresh({ "git", "reset", "HEAD~1" }, handle)
  end,
  desc = "reset last commit",
}

---@type Rio.KeyDef
H.pull = {
  fn = function(handle)
    util.run_then_refresh({ "git", "pull" }, handle)
  end,
  desc = "pull",
}

---@type Rio.KeyDef
H.push = {
  fn = function(handle)
    util.run_then_refresh({ "git", "push" }, handle)
  end,
  desc = "push",
}

---@param opts? { oneline?: boolean, file?: boolean }
return function(opts)
  opts = opts or {}
  local oneline = opts.oneline ~= false
  local file = opts.file and vim.fn.expand("%:p") or nil
  local cmd = "git log {limit} {oneline} {merges} {decorate}" .. (file and " -- " .. file or "")
  require("rio").run(cmd, {
    callbacks = {
      on_finish = { builtin.set_filetype("git") },
    },
    params = {
      limit = togglers.param("limit", "-100"),
      oneline = togglers.param("oneline", "--oneline", oneline),
      merges = togglers.switch("merges", "", "--no-merges"),
      decorate = togglers.param("decorate", "--decorate"),
    },
    keys = {
      ["<CR>"] = H.open_commit_diff,
      R = H.reset_last_commit,
      p = H.pull,
      P = H.push,
      tl = togglers.key("limit"),
      tt = togglers.key("oneline"),
      tm = togglers.key("merges"),
      td = togglers.key("decorate"),
    },
  })
end
