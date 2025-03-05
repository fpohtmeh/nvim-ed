local actions = require("plugins.oil.actions")

return {
  "stevearc/oil.nvim",
  config = function()
    local opts = {
      view_options = { show_hidden = true },
      watch_for_changes = true,
      keymaps = actions.keymaps,
    }
    require("oil").setup(opts)
    actions.setup()
  end,
  keys = {
    { "<leader>e", actions.open_oil, desc = "Open explorer" },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "Oil",
}
