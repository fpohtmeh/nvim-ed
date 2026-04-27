local H = {}

local helpers = require("plugins.rio.helpers")

H.open_commit_diff = function(handle)
  local hash = require("plugins.rio.git").commit_hash_under_cursor()
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
        table.insert(callbacks, helpers.make_filetype("git"))
      end,
    },
    params = {
      limit = helpers.make_toggle_param("limit", "-100"),
      oneline = helpers.make_toggle_param("oneline", "--oneline"),
      merges = helpers.make_toggle_param("merges", "--no-merges"),
    },
    keys = {
      ["<CR>"] = H.open_commit_diff,
      tl = helpers.make_toggle_key("limit"),
      tt = helpers.make_toggle_key("oneline"),
      tm = helpers.make_toggle_key("merges"),
    },
  })
end
