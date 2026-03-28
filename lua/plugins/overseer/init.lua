local actions = require("plugins.overseer.actions")

local options = {
  task_list = {
    keymaps = {
      ["<C-h>"] = false,
      ["<C-j>"] = false,
      ["<C-k>"] = false,
      ["<C-l>"] = false,
      ["d"] = { "keymap.run_action", opts = { action = "dispose" }, desc = "Dispose task" },
      ["D"] = { actions.dispose_all_tasks, desc = "Dispose all tasks" },
      ["s"] = { "keymap.run_action", opts = { action = "stop" }, desc = "Stop task" },
      ["S"] = { actions.stop_all_tasks, desc = "Stop all tasks" },
      ["r"] = { actions.restart_task, desc = "Restart task" },
      ["R"] = { actions.restart_all_tasks, desc = "Restart all tasks" },
      ["<CR>"] = { actions.open_task_output, desc = "Open task output" },
      ["a"] = "keymap.run_action",
      ["p"] = { actions.toggle_pin, desc = "Toggle pin" },
    },
  },
  form = { border = "single" },
  confirm = { border = "single" },
  task_win = { border = "single", padding = 0 },
  component_aliases = require("plugins.overseer.components").aliases,
}

return {
  "stevearc/overseer.nvim",
  config = function()
    require("overseer").setup(options)
  end,
  keys = require("plugins.overseer.mappings").keys,
}
