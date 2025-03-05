return {
  -- stylua: ignore
  { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
  -- stylua: ignore
  { "<leader>sA", function() Snacks.picker() end, desc = "All Pickers" },
  -- stylua: ignore
  { "<leader>sR", function() Snacks.picker.recent() end, desc = "Recent" },
  -- stylua: ignore
  { "<leader>sb", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
  -- stylua: ignore
  { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume" },
}
