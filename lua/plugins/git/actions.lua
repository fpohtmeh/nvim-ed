local M = {}

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
  vim.cmd("Gitsigns stage_hunk")
end

function M.reset_hunk()
  vim.cmd("Gitsigns reset_hunk")
end

function M.stage_buffer()
  gs().stage_buffer()
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
end

function M.undo_stage_hunk()
  gs().undo_stage_hunk()
end

function M.reset_buffer()
  gs().reset_buffer()
end

function M.unstage_buffer()
  gs().reset_buffer_index()
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

function M.send_hunks_to_qflist()
  vim.cmd("Gitsigns setqflist")
end

function M.make_action(cmd, args)
  return function()
    local args_str = args and (" " .. table.concat(args, " ")) or ""
    return vim.cmd("Git " .. cmd .. args_str)
  end
end

function M.add_file()
  vim.cmd("update | Git add %")
end

function M.add_all_files()
  vim.cmd("wall | Git add .")
end

function M.show_log()
  M.make_action("log")()
end

function M.show_diff()
  M.make_action("diff")()
end

return M
