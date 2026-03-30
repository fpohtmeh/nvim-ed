local actions = require("plugins.overseer.actions")

local options = {
  task_list = {
    bindings = {
      ["<C-h>"] = false,
      ["<C-j>"] = false,
      ["<C-k>"] = false,
      ["<C-l>"] = false,
      ["dd"] = false,
      ["d"] = "Dispose",
      ["D"] = actions.dispose_all_tasks,
      ["s"] = "Stop",
      ["S"] = actions.stop_all_tasks,
      ["r"] = actions.restart_task,
      ["R"] = actions.restart_all_tasks,
      ["<CR>"] = actions.open_task_output,
      ["a"] = "RunAction",
      ["p"] = actions.toggle_pin,
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
