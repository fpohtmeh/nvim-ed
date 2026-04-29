local M = {}
local H = {}

local builtin = require("rio.callbacks.builtin")
local togglers = require("rio.togglers")

H.update_parent_state = function(handle, parent_state)
  if not parent_state then
    return
  end
  parent_state.diff_buf = handle.state.buf
  parent_state.diff_win = handle.state.win
end

---@param hash string
---@return Rio.KeyDef
H.open_file_diff = function(hash)
  return {
    fn = function(handle)
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
        state = { buf = handle.state.diff_buf, win = handle.state.diff_win },
        callbacks = {
          on_finish = function(callbacks)
            table.insert(callbacks, builtin.set_filetype("diff"))
            table.insert(callbacks, function(inner)
              handle.state.diff_buf = inner.state.buf
              handle.state.diff_win = inner.state.win
            end)
          end,
        },
      })
    end,
    desc = "open file diff",
  }
end

function M.commit(hash, parent_state)
  local state = parent_state and { buf = parent_state.diff_buf, win = parent_state.diff_win } or {}
  local cmd = "git diff {name_only} {whitespace} {word_diff} {stat} {commit}~1 {commit}"
  require("rio").run(cmd, {
    state = state,
    params = {
      commit = hash,
      name_only = togglers.param("name_only", "--name-only", false),
      whitespace = togglers.param("whitespace", "-w", false),
      word_diff = togglers.param("word_diff", "--word-diff", false),
      stat = togglers.param("stat", "--stat", false),
    },
    callbacks = {
      on_finish = function(callbacks)
        table.insert(callbacks, builtin.set_filetype("diff"))
        table.insert(callbacks, function(handle)
          H.update_parent_state(handle, parent_state)
        end)
      end,
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
      on_finish = function(callbacks)
        table.insert(callbacks, builtin.set_filetype("diff"))
      end,
    },
    keys = {
      ts = togglers.key("staged"),
      tw = togglers.key("whitespace"),
      td = togglers.key("word_diff"),
      ta = togglers.key("stat"),
    },
  })
end

return M
