local function add_buffer_mappings(buffer)
  local keys = require("core").keys
  local actions = require("plugins.git.actions")

  local function map(mode, l, r, desc)
    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
  end

  map("n", keys.prev .. "h", actions.nav_prev_hunk, "Prev Hunk")
  map("n", keys.next .. "h", actions.nav_next_hunk, "Next Hunk")
  map("n", keys.prev .. "H", actions.nav_first_hunk, "First Hunk")
  map("n", keys.next .. "H", actions.nav_last_hunk, "Last Hunk")

  map("n", "<leader>hs", actions.stage_hunk, "Stage Hunk")
  map("n", "<leader>hr", actions.reset_hunk, "Reset Hunk")
  map("n", "<leader>hS", actions.stage_buffer, "Stage Buffer")
  map("n", "<leader>hh", actions.stage_lines, "Stage Line(s)")
  map("v", "<leader>h", actions.stage_lines, "Stage Line(s)")
  map("n", "<leader>hu", actions.undo_stage_hunk, "Undo Stage Hunk")
  map("n", "<leader>hR", actions.reset_buffer, "Reset Buffer")
  map("n", "<leader>hU", actions.unstage_buffer, "Unstage Buffer")

  map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Hunk")
end

return {
  "lewis6991/gitsigns.nvim",
  event = "LazyFile",
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "🬽" },
      topdelete = { text = "▔" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    signs_staged_enable = false,
    on_attach = add_buffer_mappings,
  },
}
