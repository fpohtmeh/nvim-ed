local M = {}

local builtin = require("rio.callbacks.builtin")
local link_builtin = require("rio.link.builtin")
local rio = require("rio")
local parse = require("plugins.rio.git.parse")

---@param file string
---@return Rio.KeyDef
M.show_at_commit = function(file)
  local ft = vim.filetype.match({ filename = file }) or ""
  return {
    action = function(handle)
      local hash = parse.commit_hash_under_cursor(handle)
      if not hash then
        return
      end
      rio.run("git show " .. hash .. ":" .. file, {
        link = link_builtin.preserve_cursor("file"),
        callbacks = { on_finish = { builtin.set_filetype(ft) } },
      })
    end,
    desc = "show file at commit",
    group = "Navigate",
  }
end

---@param file string
---@return Rio.KeyDef
M.show_diff_at_commit = function(file)
  return {
    action = function(handle)
      local hash = parse.commit_hash_under_cursor(handle)
      if not hash then
        return
      end
      local cmd = "git diff " .. hash .. "~1 " .. hash .. " -- " .. file
      rio.run(cmd, {
        link = { key = "file" },
        callbacks = {
          on_finish = { builtin.set_filetype("diff") },
        },
      })
    end,
    desc = "show file diff at commit",
    group = "Navigate",
  }
end

return M
