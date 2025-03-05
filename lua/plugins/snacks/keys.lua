return {
  -- stylua: ignore start
  { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
  { "<leader>sA", function() Snacks.picker() end, desc = "All Pickers" },
  { "<leader>sR", function() Snacks.picker.recent() end, desc = "Recent" },
  { "<leader>sb", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
  { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume" },
  -- stylua: ignore end
}
