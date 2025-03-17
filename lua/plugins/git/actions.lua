local M = {}
local sync = require("plugins.git.sync")

local function gs()
  return require("gitsigns")
end

function M.nav_next_hunk()
  if vim.wo.diff then
    vim.cmd.normal({ "]c", bang = true })
  else
    gs().nav_hunk("next")
  end
end

function M.nav_prev_hunk()
  if vim.wo.diff then
    vim.cmd.normal({ "[c", bang = true })
  else
    gs().nav_hunk("prev")
  end
end

function M.nav_first_hunk()
  gs().nav_hunk("first")
end

function M.nav_last_hunk()
  gs().nav_hunk("last")
end

function M.stage_hunk()
  gs().stage_hunk()
  sync.touch_hunks()
end

function M.reset_hunk()
  gs().reset_hunk()
  sync.touch_hunks()
end

function M.stage_buffer()
  gs().stage_buffer()
  sync.touch_hunks()
end

function M.stage_lines()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)

  local fn = require("core.fn")
  if fn.is_visual_mode() then
    local startline = vim.fn.getpos("v")[2]
    local endline = vim.fn.getpos(".")[2]
    if startline > endline then
      startline, endline = endline, startline
    end
    gs().stage_hunk({ startline, endline })
  else
    local row, _ = unpack(cursor_pos)
    local count = math.max(vim.v.count - 1, 0)
    gs().stage_hunk({ row, row + count })
  end

  pcall(vim.api.nvim_win_set_cursor, 0, cursor_pos)
  sync.touch_hunks()
end

function M.undo_stage_hunk()
  ---@diagnostic disable-next-line: deprecated
  gs().undo_stage_hunk()
  sync.touch_hunks()
end

function M.reset_buffer()
  gs().reset_buffer()
  sync.touch_hunks()
end

function M.unstage_buffer()
  gs().reset_buffer_index()
  sync.touch_hunks()
end

function M.preview_hunk_inline()
  gs().preview_hunk_inline()
end

function M.show_line_blame()
  gs().blame_line({ full = true })
end

function M.show_buffer_blame()
  gs().blame()
end

function M.show_buffer_diff()
  gs().diffthis()
end

function M.show_buffer_diff_prev_commit()
  gs().diffthis("~")
end

function M.create(cmd)
  return function()
    vim.cmd("vert Git " .. cmd)
    vim.cmd("vert resize 80")
  end
end

M.status = M.create("")

function M.add_file()
  vim.cmd("update | Git add %")
end

function M.add_all_files()
  vim.cmd("wall | Git add .")
end

return M
