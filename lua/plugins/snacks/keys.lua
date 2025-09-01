local H = {}

H.zoom = function()
  Snacks.zen.zoom()
  require("plugins.incline.core").toggle_zoom()
end

H.opts = {}

H.opts.lsp = {
  layout = {
    preset = "sidebar",
    preview = "main",
    layout = {
      position = "right",
      width = 60,
    },
  },
}

H.opts.no_preview = {
  layout = { preview = false },
}

H.opts.main_preview = {
  layout = { preview = { main = true } },
}

return {
  -- stylua: ignore start
  { "<leader><space>", function() Snacks.picker.smart(H.opts.no_preview) end, desc = "Smart Find Files" },
  { "<leader>/", function() Snacks.picker.grep(H.opts.main_preview) end, desc = "Grep" },
  { "<leader>b", function() Snacks.picker.buffers(H.opts.main_preview) end, desc = "Buffers" },
  { "<leader>sl", function() Snacks.picker.lsp_symbols(H.opts.lsp) end, desc = "Lsp Symbols (Buffer)" },
  { "<leader>sh", function() Snacks.picker.help(H.opts.main_preview) end, desc = "Help Pages" },
  { "<leader>sw", function() Snacks.picker.grep_word(H.opts.main_preview) end, desc = "Word (Visual Selection)", mode = { "n", "x" } },
  { "<leader>sb", function() Snacks.picker.grep_buffers(H.opts.main_preview) end, desc = "Grep (Open Buffers)" },
  { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
  { "<leader>sp", function() Snacks.picker.projects(H.opts.no_preview) end, desc = "Projects" },

  { "<leader>ss", function() Snacks.picker(H.opts.no_preview) end, desc = "All Pickers" },
  { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume" },

  { "<leader>n", function() require("noice").cmd("all") end, desc = "Noice Messages" },
  { "<A-t>", H.zoom, desc = "Toggle Zen", mode = { "n", "x", "i" } },
  -- stylua: ignore end
}
