local H = require("plugins.rio.helpers")

return function(hash, parent_state)
  local state = parent_state and { buf = parent_state.diff_buf, win = parent_state.diff_win } or {}
  require("rio").run("git diff {name_only} {whitespace} {word_diff} {stat} {commit}~1 {commit}", {
    state = state,
    params = {
      commit = hash,
      name_only = H.make_toggle_param("name_only", "--name-only", false),
      whitespace = H.make_toggle_param("whitespace", "-w", false),
      word_diff = H.make_toggle_param("word_diff", "--word-diff", false),
      stat = H.make_toggle_param("stat", "--stat", false),
    },
    callbacks = {
      on_start = {},
      on_finish = function(callbacks)
        table.insert(callbacks, function(handle)
          vim.bo[handle.state.buf].filetype = "diff"
          if parent_state then
            parent_state.diff_buf = handle.state.buf
            parent_state.diff_win = handle.state.win
          end
        end)
      end,
    },
    keys = {
      ["<CR>"] = function(handle)
        if not H.toggles.name_only.enabled then
          return
        end
        local file = require("plugins.rio.git").file_under_cursor()
        if not file then
          return
        end
        require("rio").run("git diff {commit}~1 {commit} -- {file}", {
          params = {
            commit = hash,
            file = file,
          },
          state = { buf = handle.state.diff_buf, win = handle.state.diff_win },
          callbacks = {
            on_finish = function(callbacks)
              table.insert(callbacks, function(inner)
                vim.bo[inner.state.buf].filetype = "diff"
                handle.state.diff_buf = inner.state.buf
                handle.state.diff_win = inner.state.win
              end)
            end,
          },
        })
      end,
      tt = H.make_toggle_key("name_only"),
      tw = H.make_toggle_key("whitespace"),
      ts = H.make_toggle_key("stat"),
    },
  })
end
