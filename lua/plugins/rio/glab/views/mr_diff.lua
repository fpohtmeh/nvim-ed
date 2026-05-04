local M = {}

local builtin = require("rio.callbacks.builtin")
local diff = require("plugins.rio.git.views.diff")
local rio = require("rio")
local util = require("plugins.rio.glab.util")

---@param parent Rio.Handle
function M.show(parent)
  rio.run("glab mr diff {iid} --color=never", {
    parent = parent,
    link = { key = "diff" },
    parsers = diff.parsers,
    resolver = { callbacks = util.notify_callbacks("loading MR diff") },
    callbacks = { on_finish = { builtin.set_filetype("diff") } },
    keys = {
      [";h"] = diff.keys[";h"],
      [",h"] = diff.keys[",h"],
      [";H"] = diff.keys[";H"],
      [",H"] = diff.keys[",H"],
    },
  })
end

return M
