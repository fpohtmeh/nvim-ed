return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    delay = 1000,
    win = { border = "single" },
    icons = { mappings = false },
    defaults = {},
    spec = {
      { "<leader>a", group = "Claude" },
      { "<leader>t", group = "Terminal" },
    },
  },
}
