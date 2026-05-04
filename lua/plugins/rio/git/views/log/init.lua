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
H.show_commit = {
  action = function(parent)
    rio.run("git show {whitespace} {word_diff} {stat} {commit}", {
      parent = parent,
      link = { key = "show" },
      parsers = diff.parsers,
      params = {
        whitespace = togglers.param("whitespace", "-w", false),
        word_diff = togglers.param("word_diff", "--word-diff", false),
        stat = togglers.param("stat", "--stat", false),
      },
      callbacks = {
        on_finish = { builtin.set_filetype("diff") },
      },
      keys = {
        [";h"] = diff.keys[";h"],
        [",h"] = diff.keys[",h"],
        tw = togglers.key("whitespace"),
        td = togglers.key("word_diff"),
        ts = togglers.key("stat"),
      },
    })
  end,
  desc = "show commit",
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

H.notify_remote = function(label)
  return function(handle)
    local result = handle.result
    local msg = (result.stdout ~= "" and result.stdout or result.stderr):gsub("%s+$", "")
    local opts = { id = "git-" .. label, title = "[rio]" }
    if result.code ~= 0 then
      Snacks.notify.error(msg ~= "" and msg or ("git " .. label .. " failed"), opts)
      return false
    end
    Snacks.notify.info(msg ~= "" and msg or ("git " .. label .. " done"), opts)
  end
end

H.refresh_parent = function(handle)
  builtin.refresh().action(handle.parent)
end

H.remote_action = function(cmd, label)
  return function(parent)
    Snacks.notify.info("git " .. label .. "…", { id = "git-" .. label, title = "[rio]", timeout = false })
    rio.run(cmd, {
      parent = parent,
      resolver = {
        callbacks = {
          on_finish = function()
            return { H.notify_remote(label), H.refresh_parent }
          end,
        },
      },
    })
  end
end

---@type Rio.KeyDef
H.pull = {
  action = H.remote_action("git pull", "pull"),
  desc = "pull",
  group = "Remote",
}

---@type Rio.KeyDef
H.push = {
  action = H.remote_action("git push", "push"),
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
      dd = H.show_commit,
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
