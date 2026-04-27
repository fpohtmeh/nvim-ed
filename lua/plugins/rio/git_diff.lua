local H = require("plugins.rio.helpers")

return function(hash)
  require("rio").run("git diff {name_only} {whitespace} {word_diff} {stat} {commit}~1 {commit}", {
    params = {
      commit = hash,
      name_only = H.make_toggle_param("name_only", "--name-only", false),
      whitespace = H.make_toggle_param("whitespace", "-w", false),
      word_diff = H.make_toggle_param("word_diff", "--word-diff", false),
      stat = H.make_toggle_param("stat", "--stat", false),
    },
    callbacks = {
      on_start = {},
      on_finish = H.make_filetype("diff"),
    },
    keys = {
      ["<CR>"] = function()
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
          callbacks = {
            on_finish = H.make_filetype("diff"),
          },
        })
      end,
      tt = H.make_toggle_key("name_only"),
      tw = H.make_toggle_key("whitespace"),
      ts = H.make_toggle_key("stat"),
    },
  })
end
