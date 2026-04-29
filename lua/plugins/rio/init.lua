return {
  "fpohtmeh/rio.nvim",
  dev = true,
  opts = {},
  keys = {
    {
      "<leader>U",
      function()
        require("plugins.rio.git.views.log")()
      end,
      desc = "Rio: git log",
    },
    {
      "<leader>gg",
      function()
        require("plugins.rio.git.views.status")()
      end,
      desc = "Rio: git status",
    },
    {
      "<leader>O",
      function()
        require("plugins.rio.git.views.stash")()
      end,
      desc = "Rio: git stash",
    },
  },
}
