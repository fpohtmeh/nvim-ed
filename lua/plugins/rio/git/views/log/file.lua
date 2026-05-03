local M = {}

local builtin = require("rio.callbacks.builtin")
local rio = require("rio")
local parse = require("plugins.rio.git.parse")

local H = {}

H.linked_cursor = function(handle, key)
  local linked = handle.state.links and handle.state.links[key]
  if not linked then
    return nil
  end
  local win = linked.state.win
  if not win or not vim.api.nvim_win_is_valid(win) then
    return nil
  end
  return vim.api.nvim_win_get_cursor(win)
end

H.restore_cursor = function(cursor)
  return function(handle)
    local max = vim.api.nvim_buf_line_count(handle.state.buf)
    vim.api.nvim_win_set_cursor(handle.state.win, { math.min(cursor[1], max), cursor[2] })
  end
end

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
      local cursor = H.linked_cursor(handle, "file")
      local on_finish = { builtin.set_filetype(ft) }
      if cursor then
        table.insert(on_finish, H.restore_cursor(cursor))
      end
      rio.run("git show " .. hash .. ":" .. file, {
        link = "file",
        callbacks = { on_finish = on_finish },
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
        link = "file",
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
