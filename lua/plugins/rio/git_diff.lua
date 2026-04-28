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

H.open_file_diff = function(handle, hash)
  if not handle.state.toggles.name_only.enabled then
    return
  end
  local file = require("plugins.rio.git").file_under_cursor()
  if not file then
    return
  end
  local cmd = "git diff {commit}~1 {commit} -- {file}"
  require("rio").run(cmd, {
    params = { commit = hash, file = file },
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
end

return function(hash, parent_state)
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
      ["<CR>"] = function(handle)
        H.open_file_diff(handle, hash)
      end,
      tt = togglers.key("name_only"),
      tw = togglers.key("whitespace"),
      ts = togglers.key("stat"),
    },
  })
end
