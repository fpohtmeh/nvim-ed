local M = {}

local builtin = require("rio.callbacks.builtin")
local rio = require("rio")
local parse = require("plugins.rio.git.parse")

M.save_state = function(parent, cursor)
  return function(handle)
    parent.state.file_buf = handle.state.buf
    parent.state.file_win = handle.state.win
    if not cursor then
      return
    end
    local max = vim.api.nvim_buf_line_count(handle.state.buf)
    vim.api.nvim_win_set_cursor(handle.state.win, { math.min(cursor[1], max), cursor[2] })
  end
end

---@param file string
---@return Rio.KeyDef
M.show_at_commit = function(file)
  local ft = vim.filetype.match({ filename = file }) or ""
  return {
    fn = function(handle)
      local hash = parse.commit_hash_under_cursor(handle)
      if not hash then
        return
      end
      local win = handle.state.file_win
      local cursor = win and vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_cursor(win)
      local cmd = "git show " .. hash .. ":" .. file
      rio.run(cmd, {
        state = { buf = handle.state.file_buf, win = handle.state.file_win },
        callbacks = {
          on_finish = {
            builtin.set_filetype(ft),
            M.save_state(handle, cursor),
          },
        },
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
    fn = function(handle)
      local hash = parse.commit_hash_under_cursor(handle)
      if not hash then
        return
      end
      local cmd = "git diff " .. hash .. "~1 " .. hash .. " -- " .. file
      rio.run(cmd, {
        state = { buf = handle.state.file_buf, win = handle.state.file_win },
        callbacks = {
          on_finish = {
            builtin.set_filetype("diff"),
            function(inner)
              handle.state.file_buf = inner.state.buf
              handle.state.file_win = inner.state.win
            end,
          },
        },
      })
    end,
    desc = "show file diff at commit",
    group = "Navigate",
  }
end

return M
