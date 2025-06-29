local H = {}

H.tools = {
  groups = {
    dev = {
      description = "Developer - Can run code, edit code and modify files",
      tools = { "create_file", "read_file", "insert_edit_into_file", "cmd_runner" },
    },
  },
}

H.strategies = {
  chat = {
    adapter = "anthropic",
    tools = H.tools,
    opts = {},
  },
  inline = { adapter = "anthropic" },
  cmd = { adapter = "anthropic" },
}

H.adapters = {
  anthropic = function()
    return require("codecompanion.adapters").extend("anthropic", {
      env = { api_key = "ANTHROPIC_API_KEY" },
    })
  end,
}

H.display = {
  diff = {
    provider = "mini_diff",
  },
  chat = {
    auto_scroll = false,
    start_in_insert_mode = true,
  },
}

H.opts = {
  strategies = H.strategies,
  adapters = H.adapters,
  display = H.display,
  extensions = {
    history = { enabled = true },
  },
}

H.dependencies = {
  "nvim-lua/plenary.nvim",
  "nvim-treesitter/nvim-treesitter",
  "echasnovski/mini.diff",
  "ravitemer/codecompanion-history.nvim",
}

return {
  "olimorris/codecompanion.nvim",
  opts = H.opts,
  keys = {
    { "<C-g>t", "<cmd>CodeCompanionChat Toggle<cr>", desc = "CodeCompanion: Toggle", mode = { "n", "i", "v" } },
  },
  dependencies = H.dependencies,
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionHistory" },
}
