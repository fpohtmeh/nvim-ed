return {
  "fpohtmeh/rio.nvim",
  dev = true,
  opts = {},
  keys = {
    {
      "<leader>R",
      function()
        require("plugins.rio.git_log")()
      end,
      desc = "Rio: git log",
    },
    {
      "<leader>Y",
      function()
        require("plugins.rio.git_status")()
      end,
      desc = "Rio: git status",
    },
  },
}
