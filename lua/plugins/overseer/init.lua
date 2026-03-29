local actions = require("plugins.overseer.actions")

local options = {
  task_list = {
    keymaps = {
      ["<C-h>"] = false,
      ["<C-j>"] = false,
      ["<C-k>"] = false,
      ["<C-l>"] = false,
      ["dd"] = false,
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
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "OverseerList",
      callback = function(ev)
        local opts = function(desc)
          return { buffer = ev.buf, desc = desc }
        end
        vim.keymap.set("x", "d", actions.dispose_selected_tasks, opts("Dispose selected tasks"))
        vim.keymap.set("x", "s", actions.stop_selected_tasks, opts("Stop selected tasks"))
        vim.keymap.set("x", "r", actions.restart_selected_tasks, opts("Restart selected tasks"))
      end,
    })
  end,
  keys = require("plugins.overseer.mappings").keys,
}
