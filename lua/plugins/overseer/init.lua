local tasks = require("plugins.overseer.tasks")
local output = require("plugins.overseer.output")

local options = {
  task_list = {
    keymaps = {
      -- Disable defaults
      ["dd"] = false,
      ["o"] = false,
      ["{"] = false,
      ["}"] = false,
      ["g."] = false,
      ["<C-j>"] = false,
      ["<C-k>"] = false,
      ["<C-e>"] = false,
      ["<C-f>"] = false,
      ["<C-s>"] = false,
      ["<C-v>"] = false,
      ["<C-t>"] = false,
      ["<C-q>"] = false,
      -- Custom
      ["d"] = { callback = tasks.dispose_selected, mode = { "n", "v" }, desc = "Dispose tasks" },
      ["D"] = { callback = tasks.dispose_all, desc = "Dispose all tasks" },
      ["s"] = { callback = tasks.stop_selected, mode = { "n", "v" }, desc = "Stop tasks" },
      ["S"] = { callback = tasks.stop_all, desc = "Stop all tasks" },
      ["r"] = { callback = tasks.restart_selected, mode = { "n", "v" }, desc = "Restart tasks" },
      ["R"] = { callback = tasks.restart_all, desc = "Restart all tasks" },
      ["<CR>"] = { callback = output.open, desc = "Open task output" },
      ["a"] = { "<cmd>OverseerTaskAction<cr>", desc = "Run action" },
      ["p"] = { callback = output.toggle_pin, desc = "Toggle pin" },
      ["<C-p>"] = "keymap.toggle_preview",
      ["e"] = { "keymap.run_action", opts = { action = "edit" }, desc = "Edit task" },
    },
  },
  component_aliases = require("plugins.overseer.components").aliases,
}

return {
  "stevearc/overseer.nvim",
  opts = options,
  keys = require("plugins.overseer.mappings").keys,
}
