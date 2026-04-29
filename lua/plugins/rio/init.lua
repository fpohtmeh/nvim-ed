return {
  "fpohtmeh/rio.nvim",
  dev = true,
  opts = {},
  keys = {
    -- add
    {
      "<leader>ga",
      function()
        vim.cmd("update")
        vim.system({ "git", "add", vim.fn.expand("%:p") })
      end,
      desc = "Rio: git add (file)",
    },
    {
      "<leader>gA",
      function()
        vim.cmd("wall")
        vim.system({ "git", "add", "." })
      end,
      desc = "Rio: git add (all)",
    },
    {
      "<leader>gl",
      function()
        require("plugins.rio.git.views.log")()
      end,
      desc = "Rio: git log",
    },
    {
      "<leader>gL",
      function()
        require("plugins.rio.git.views.log")({ oneline = false })
      end,
      desc = "Rio: git log (full)",
    },
    {
      "<leader>gf",
      function()
        require("plugins.rio.git.views.log")({ file = true })
      end,
      desc = "Rio: git file log",
    },
    {
      "<leader>gF",
      function()
        require("plugins.rio.git.views.log")({ oneline = false, file = true })
      end,
      desc = "Rio: git file log (full)",
    },
    {
      "<leader>gd",
      function()
        require("plugins.rio.git.views.diff").working()
      end,
      desc = "Rio: git diff",
    },
    {
      "<leader>gD",
      function()
        require("plugins.rio.git.views.diff").working({ staged = true })
      end,
      desc = "Rio: git diff (staged)",
    },
    {
      "<leader>gb",
      function()
        require("plugins.rio.git.views.branch")()
      end,
      desc = "Rio: git branch",
    },
    {
      "<leader>gB",
      function()
        require("plugins.rio.git.views.branch")({ all = true })
      end,
      desc = "Rio: git branch (all)",
    },
    {
      "<leader>gg",
      function()
        require("plugins.rio.git.views.status")()
      end,
      desc = "Rio: git status",
    },
    {
      "<leader>gs",
      function()
        require("plugins.rio.git.views.stash")()
      end,
      desc = "Rio: git stash",
    },
  },
}
