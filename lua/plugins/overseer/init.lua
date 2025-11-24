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
    default_detail = 2,
    bindings = {
      ["<C-h>"] = false,
      ["<C-j>"] = false,
      ["<C-k>"] = false,
      ["<C-l>"] = false,
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
