local H = {}

local builtin = require("rio.callbacks.builtin")
local rio = require("rio")
local togglers = require("rio.togglers")
local diff = require("plugins.rio.git.views.diff")
local parse = require("plugins.rio.git.parse")
local util = require("plugins.rio.git.util")

---@type Rio.KeyDef
H.open_commit_diff = {
  fn = function(handle)
    local hash = parse.commit_hash_under_cursor(handle)
    if not hash then
      return
    end
    diff.commit(hash, handle.state)
  end,
  desc = "open diff",
  group = "Navigate",
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
  group = "Reset",
}

H.save_file_state = function(parent, cursor)
  return function(handle)
    parent.state.file_buf = handle.state.buf
    parent.state.file_win = handle.state.win
    if not cursor then
      return
    end
    local max = vim.api.nvim_buf_line_count(handle.state.buf)
    vim.api.nvim_win_set_cursor(handle.state.win, { math.min(cursor[1], max), cursor[2] })
  end
end

---@param file string
---@return Rio.KeyDef
H.show_file_at_commit = function(file)
  local ft = vim.filetype.match({ filename = file }) or ""
  return {
    fn = function(handle)
      local hash = parse.commit_hash_under_cursor(handle)
      if not hash then
        return
      end
      local win = handle.state.file_win
      local cursor = win and vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_cursor(win)
      local cmd = "git show " .. hash .. ":" .. file
      rio.run(cmd, {
        state = { buf = handle.state.file_buf, win = handle.state.file_win },
        callbacks = {
          on_finish = {
            builtin.set_filetype(ft),
            H.save_file_state(handle, cursor),
          },
        },
      })
    end,
    desc = "show file at commit",
    group = "Navigate",
  }
end

---@param file string
---@return Rio.KeyDef
H.show_file_diff_at_commit = function(file)
  return {
    fn = function(handle)
      local hash = parse.commit_hash_under_cursor(handle)
      if not hash then
        return
      end
      local cmd = "git diff " .. hash .. "~1 " .. hash .. " -- " .. file
      rio.run(cmd, {
        state = { buf = handle.state.file_buf, win = handle.state.file_win },
        callbacks = {
          on_finish = {
            builtin.set_filetype("diff"),
            function(inner)
              handle.state.file_buf = inner.state.buf
              handle.state.file_win = inner.state.win
            end,
          },
        },
      })
    end,
    desc = "show file diff at commit",
    group = "Navigate",
  }
end

---@type Rio.KeyDef
H.pull = {
  fn = function(handle)
    util.run_then_refresh({ "git", "pull" }, handle)
  end,
  desc = "pull",
  group = "Remote",
}

---@type Rio.KeyDef
H.push = {
  fn = function(handle)
    util.run_then_refresh({ "git", "push" }, handle)
  end,
  desc = "push",
  group = "Remote",
}

---@param opts? { oneline?: boolean, file?: boolean }
return function(opts)
  opts = opts or {}
  local oneline = opts.oneline ~= false
  local file = opts.file and vim.fn.expand("%:.") or nil
  local cmd = "git log {limit} {oneline} {merges} {decorate}" .. (file and " -- " .. file or "")
  rio.run(cmd, {
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
      o = file and H.show_file_at_commit(file) or false,
      d = file and H.show_file_diff_at_commit(file) or false,
      p = H.pull,
      P = H.push,
      tl = togglers.key("limit"),
      tt = togglers.key("oneline"),
      tm = togglers.key("merges"),
      td = togglers.key("decorate"),
    },
  })
end
