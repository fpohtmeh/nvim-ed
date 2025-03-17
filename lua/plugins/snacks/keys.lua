local zoom = function()
  Snacks.zen.zoom()
  require("plugins.incline.core").toggle_zoom()
end

return {
  -- stylua: ignore start
  { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
  { "<leader><cr>", function() Snacks.picker.grep() end, desc = "Grep" },
  { "<leader>b", function() Snacks.picker.buffers() end, desc = "Buffers" },

  { "<leader>S", function() Snacks.picker() end, desc = "All Pickers" },
  { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume" },

  { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
  { "<leader>sb", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
  { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
  { "<leader>n", function() require("noice").cmd("all") end, desc = "Noice Messages" },
  { "<A-t>", zoom, desc = "Toggle Zen", mode = { "n", "x", "i" } },
  -- stylua: ignore end
}
