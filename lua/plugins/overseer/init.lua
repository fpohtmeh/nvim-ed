local options = {
  templates = { "builtin" },
  task_list = {
    default_detail = 1,
    bindings = {
      ["<C-h>"] = false,
      ["<C-j>"] = false,
      ["<C-k>"] = false,
      ["<C-l>"] = false,
      ["d"] = "Dispose",
      ["D"] = "<Cmd>lua require('plugins.overseer.actions').dispose_all_tasks()<CR>",
      ["s"] = "Stop",
      ["S"] = "<Cmd>lua require('plugins.overseer.actions').stop_all_tasks()<CR>",
      ["r"] = "<Cmd>lua require('plugins.overseer.actions').restart_task()<CR>",
      ["R"] = "<Cmd>lua require('plugins.overseer.actions').restart_all_tasks()<CR>",
      ["<CR>"] = "<Cmd>lua require('plugins.overseer.actions').open_task_output()<CR>",
      ["a"] = "RunAction",
      ["p"] = "<Cmd>lua require('plugins.overseer.actions').toggle_pin()<CR>",
    },
  },
  form = { border = "single" },
  confirm = { border = "single" },
  task_win = { border = "single", padding = 0 },
  help_win = { border = "single" },
  component_aliases = require("plugins.overseer.components").aliases,
}

return {
  "stevearc/overseer.nvim",
  config = function()
    require("overseer").setup(options)
  end,
  keys = require("plugins.overseer.mappings").keys,
}
