return {
  "Robitx/gp.nvim",
  opts = {
    providers = {
      openai = {},
      anthropic = { secret = os.getenv("ANTHROPIC_API_KEY") },
    },
    chat_shortcut_respond = { shortcut = "<c-g><c-g>", modes = { "n", "i", "v", "x" } },
    chat_shortcut_delete = { shortcut = "<c-g>d", modes = { "n" } },
    chat_shortcut_stop = { shortcut = "<c-g>s", modes = { "n" } },
    chat_shortcut_new = { shortcut = "<c-g>n", modes = { "n" } },
    template_selection = "{{selection}}",
    hooks = require("plugins.gpt.hooks"),
  },
  keys = require("plugins.gpt.keys"),
}
