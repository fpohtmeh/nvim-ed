local actions = require("plugins.oil.actions")

return {
  "stevearc/oil.nvim",
  config = function()
    local opts = {
      view_options = { show_hidden = true },
      watch_for_changes = true,
      keymaps = actions.keymaps,
      buf_options = {
        buflisted = false,
        bufhidden = "hide",
      },
      float = { border = "single" },
      keymaps_help = { border = "single" },
      confirmation = { border = "single" },
      progress = { border = "single", minimized_border = "single" },
      ssh = { border = "single" },
    }
    require("oil").setup(opts)
    actions.setup()
  end,
  keys = {
    { "<leader>e", actions.open_oil, desc = "Open explorer" },
    { "<leader>E", actions.open_oil_cwd, desc = "Open explorer (cwd)" },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "Oil",
}
