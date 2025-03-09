local actions = require("plugins.harpoon.actions")

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
    settings = {
      save_on_toggle = true,
    },
  },
  keys = {
    { "<leader>H", actions.add, desc = "Harpoon File" },
    { "<leader><c-h>", actions.show_picker, desc = "Harpoon Picker" },
    { "<leader><a-h>", actions.show_quick_menu, desc = "Harpoon Quick Menu" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}
