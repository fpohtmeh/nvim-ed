return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "moon",
  },
  init = function()
    require("tokyonight").load()
  end,
}
