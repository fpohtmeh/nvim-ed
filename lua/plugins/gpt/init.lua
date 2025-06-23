return {
  "Robitx/gp.nvim",
  opts = {
    providers = {
      openai = {},
      anthropic = { secret = os.getenv("ANTHROPIC_API_KEY") },
    },
    -- Title
    chat_user_prefix = "## Me:",
    chat_assistant_prefix = { "## GP ", "({{agent}})" },
    -- Shortcuts
    chat_shortcut_respond = { shortcut = "<C-s>", modes = { "n", "i", "v" } },
    chat_shortcut_delete = { shortcut = "<C-e>d", modes = { "n" } },
    chat_shortcut_stop = { shortcut = "<C-e>x", modes = { "n" } },
    chat_shortcut_new = { shortcut = "<C-e>n", modes = { "n" } },
    -- Misc
    template_selection = "{{selection}}",
    hooks = require("plugins.gpt.hooks"),
  },
  keys = require("plugins.gpt.keys"),
}
