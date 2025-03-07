local styles = require("plugins.snacks.styles")

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    dashboard = require("plugins.snacks.dashboard"),
    indent = { enabled = false },
    lazygit = {
      configure = false,
    },
    notifier = {
      top_down = false,
      style = styles.notification,
    },
    picker = require("plugins.snacks.picker"),
    styles = styles.config,
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
