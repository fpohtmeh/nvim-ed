local H = require("plugins.rio.helpers")

return function()
  require("rio").run("git log {limit} {oneline} {merges}", {
    callbacks = {
      on_finish = H.make_filetype("git"),
    },
    params = {
      limit = H.make_toggle_param("limit", "-100"),
      oneline = H.make_toggle_param("oneline", "--oneline"),
      merges = H.make_toggle_param("merges", "--no-merges"),
    },
    keys = {
      ["<CR>"] = function(handle)
        local hash = require("plugins.rio.git").commit_hash_under_cursor()
        if not hash then
          return
        end
        require("plugins.rio.git_diff")(hash, handle.state)
      end,
      tl = H.make_toggle_key("limit"),
      tt = H.make_toggle_key("oneline"),
      tm = H.make_toggle_key("merges"),
    },
  })
end
