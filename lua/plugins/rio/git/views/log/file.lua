local M = {}

local builtin = require("rio.callbacks.builtin")
local link_builtin = require("rio.link.builtin")
local rio = require("rio")

---@param file string
---@return Rio.KeyDef
M.show_at_commit = function(file)
  local ft = vim.filetype.match({ filename = file }) or ""
  return {
    action = function(handle)
      rio.run("git show {commit}:{file}", {
        parent = handle,
        link = link_builtin.preserve_cursor("file"),
        callbacks = { on_finish = { builtin.set_filetype(ft) } },
      })
    end,
    desc = "show file at commit",
    group = "Navigate",
  }
end

---@type Rio.KeyDef
M.show_diff_at_commit = {
  action = function(handle)
    rio.run("git diff {commit}~1 {commit} -- {file}", {
      parent = handle,
      link = { key = "file" },
      callbacks = { on_finish = { builtin.set_filetype("diff") } },
    })
  end,
  desc = "show file diff at commit",
  group = "Navigate",
}

return M
