return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    dashboard = require("plugins.snacks.dashboard"),
    lazygit = {
      configure = false,
    },
    notifier = {
      top_down = false,
    },
    picker = {
      layout = { preset = "ivy" },
    },
    styles = {
      notification = { focusable = false },
    },
    terminal = {
      win = {
        keys = { nav_h = false, nav_j = false, nav_k = false, nav_l = false },
        wo = { winbar = "" },
      },
    },
    zen = {
      toggles = { git_signs = true },
      show = { statusline = true, tabline = false },
    },
  },
  keys = require("plugins.snacks.keys"),
}
