local H = {}

H.tools = {
  groups = {
    dev = {
      description = "Developer - Can run code, edit code and modify files",
      system_prompt = "Describe what the developer should do",
      tools = { "editor", "files", "cmd_runner" },
    },
  },
}

H.strategies = {
  chat = {
    adapter = "anthropic",
    tools = H.tools,
  },
  inline = {
    adapter = "anthropic",
  },
  cmd = {
    adapter = "anthropic",
  },
}

H.adapters = {
  anthropic = function()
    return require("codecompanion.adapters").extend("anthropic", {
      env = {
        api_key = "ANTHROPIC_API_KEY",
      },
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

H.prompt_library = require("plugins.code-companion.prompts").library

H.opts = {
  strategies = H.strategies,
  adapters = H.adapters,
  display = H.display,
  prompt_library = H.prompt_library,
}

H.keys = require("plugins.code-companion.keys")

H.dependencies = {
  "nvim-lua/plenary.nvim",
  "nvim-treesitter/nvim-treesitter",
  "echasnovski/mini.diff",
}

return {
  "olimorris/codecompanion.nvim",
  opts = H.opts,
  keys = H.keys,
  dependencies = H.dependencies,
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
}
