local M = {}
local H = {}

local builtin = require("rio.callbacks.builtin")
local togglers = require("rio.togglers")

---@type Rio.KeyDef
H.next_hunk = {
  action = function()
    vim.fn.search("^@@", "W")
  end,
  desc = "next hunk",
  group = "Navigate",
}

---@type Rio.KeyDef
H.prev_hunk = {
  action = function()
    vim.fn.search("^@@", "bW")
  end,
  desc = "prev hunk",
  group = "Navigate",
}

---@type Rio.KeyDef
H.stage_hunk = {
  action = function(handle)
    local parse = require("plugins.rio.git.parse")
    local patch = parse.hunk_patch_under_cursor(handle.state.buf)
    if not patch then
      return
    end
    vim.fn.system({ "git", "apply", "--cached" }, patch)
    if vim.v.shell_error ~= 0 then
      Snacks.notify.error("Failed to stage hunk")
      return
    end
    builtin.refresh().action(handle)
  end,
  desc = "stage hunk",
  group = "Stage",
}

---@type Rio.KeyDef
H.unstage_hunk = {
  action = function(handle)
    local parse = require("plugins.rio.git.parse")
    local patch = parse.hunk_patch_under_cursor(handle.state.buf)
    if not patch then
      return
    end
    vim.fn.system({ "git", "apply", "--cached", "--reverse" }, patch)
    if vim.v.shell_error ~= 0 then
      Snacks.notify.error("Failed to unstage hunk")
      return
    end
    builtin.refresh().action(handle)
  end,
  desc = "unstage hunk",
  group = "Stage",
}

---@param hash string
---@return Rio.KeyDef
H.open_file_diff = function(hash)
  return {
    action = function(handle)
      if not handle.state.toggles.name_only.enabled then
        return
      end
      local path = require("plugins.rio.git.parse").path_under_cursor()
      if not path then
        return
      end
      local cmd = "git diff {commit}~1 {commit} -- {path}"
      require("rio").run(cmd, {
        params = { commit = hash, path = path },
        link = "diff",
        callbacks = {
          on_finish = { builtin.set_filetype("diff") },
        },
      })
    end,
    desc = "open file diff",
    group = "Navigate",
  }
end

---@param hash string
function M.commit(hash)
  local cmd = "git diff {name_only} {whitespace} {word_diff} {stat} {commit}~1 {commit}"
  require("rio").run(cmd, {
    link = "diff",
    params = {
      commit = hash,
      name_only = togglers.param("name_only", "--name-only", false),
      whitespace = togglers.param("whitespace", "-w", false),
      word_diff = togglers.param("word_diff", "--word-diff", false),
      stat = togglers.param("stat", "--stat", false),
    },
    callbacks = {
      on_finish = { builtin.set_filetype("diff") },
    },
    keys = {
      ["<CR>"] = H.open_file_diff(hash),
      tt = togglers.key("name_only"),
      tw = togglers.key("whitespace"),
      ts = togglers.key("stat"),
    },
  })
end

---@param opts? { staged?: boolean }
function M.working(opts)
  opts = opts or {}
  local staged = opts.staged or false
  local cmd = "git diff {staged} {whitespace} {word_diff} {stat}"
  require("rio").run(cmd, {
    params = {
      staged = togglers.param("staged", "--staged", staged),
      whitespace = togglers.param("whitespace", "-w", false),
      word_diff = togglers.param("word_diff", "--word-diff", false),
      stat = togglers.param("stat", "--stat", false),
    },
    callbacks = {
      on_finish = { builtin.set_filetype("diff") },
    },
    keys = {
      [";h"] = H.next_hunk,
      [",h"] = H.prev_hunk,
      s = H.stage_hunk,
      u = H.unstage_hunk,
      tt = togglers.key("staged"),
      tw = togglers.key("whitespace"),
      td = togglers.key("word_diff"),
      ts = togglers.key("stat"),
    },
  })
end

return M
