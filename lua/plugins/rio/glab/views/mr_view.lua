local M = {}

local builtin = require("rio.callbacks.builtin")
local rio = require("rio")
local togglers = require("rio.togglers")
local util = require("plugins.rio.glab.util")

---@param parent Rio.Handle
function M.show(parent)
  rio.run("glab mr view {iid} {comments}", {
    parent = parent,
    link = { key = "view" },
    params = { comments = togglers.param("comments", "--comments", false) },
    resolver = { callbacks = util.notify_callbacks("loading MR view") },
    callbacks = { on_finish = { builtin.set_filetype("markdown") } },
    keys = { tc = togglers.key("comments") },
  })
end

return M
