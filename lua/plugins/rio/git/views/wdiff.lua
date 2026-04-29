local builtin = require("rio.callbacks.builtin")
local togglers = require("rio.togglers")

---@param opts? { staged?: boolean }
return function(opts)
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
