return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    incremental = true,
    highlight = {
      backdrop = false,
    },
    modes = {
      search = {
        enabled = true,
      },
    },
  },
  keys = {
    -- stylua: ignore
    { "s", mode = "n", function() require("flash").jump() end, desc = "Flash" },
  },
}
