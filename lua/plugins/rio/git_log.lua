local H = {}

local builtin = require("rio.callbacks.builtin")
local togglers = require("rio.togglers")

H.open_commit_diff = function(handle)
  local hash = require("plugins.rio.git_parse").commit_hash_under_cursor(handle)
  if not hash then
    return
  end
  require("plugins.rio.git_diff")(hash, handle.state)
end

return function()
  local cmd = "git log {limit} {oneline} {merges}"
  require("rio").run(cmd, {
    callbacks = {
      on_finish = function(callbacks)
        table.insert(callbacks, builtin.set_filetype("git"))
      end,
    },
    params = {
      limit = togglers.param("limit", "-100"),
      oneline = togglers.param("oneline", "--oneline"),
      merges = togglers.param("merges", "--no-merges"),
    },
    keys = {
      ["<CR>"] = H.open_commit_diff,
      tl = togglers.key("limit"),
      tt = togglers.key("oneline"),
      tm = togglers.key("merges"),
    },
  })
end
