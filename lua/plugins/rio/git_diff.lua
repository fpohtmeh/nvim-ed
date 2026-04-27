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
      tt = H.make_toggle_key("name_only"),
      tw = H.make_toggle_key("whitespace"),
      ts = H.make_toggle_key("stat"),
    },
  })
end
