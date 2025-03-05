return {
  "folke/snacks.nvim",
  opts = {
    dashboard = require("plugins.snacks.dashboard"),
    lazygit = {
      configure = false,
    },
    notifier = {
      top_down = false,
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
      show = { statusline = true },
    },
  },
}
