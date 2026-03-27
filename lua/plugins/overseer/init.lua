local function set_filetypes()
  local strategy = require("overseer.strategy.terminal")
  local start = strategy.start
  strategy.start = function(self, task)
    start(self, task)
    vim.bo[self.bufnr].filetype = "OverseerOutput"
  end
end

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
      ["s"] = "Stop",
      ["r"] = "<Cmd>lua require('plugins.overseer.actions').restart_task()<CR>",
      ["S"] = "<Cmd>lua require('plugins.overseer.actions').stop_all_tasks()<CR>",
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
    set_filetypes()
  end,
  version = "1.6.0",
  keys = require("plugins.overseer.mappings").keys,
}
