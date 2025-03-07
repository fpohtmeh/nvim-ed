local translation_prompt = [[
You are a Translator. Please help me translate content.
If my first line contains only a two-letter language code (like "fr", "es", "de", etc.), use that as the target language for translation.
If my first line contains two two-letter language codes separated by a space (like "en fr", "es de", etc.), use the first code as the source language and the second code as the target language.
For all other cases, assume translation to English is desired.
Answer only with the translation, don't print source or target language or other explanation
]]

return {
  "Robitx/gp.nvim",
  opts = {
    providers = {
      openai = {},
      anthropic = { secret = os.getenv("ANTHROPIC_API_KEY") },
    },
    chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<A-g><A-g>" },
    chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<A-g>d" },
    chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<A-g>s" },
    chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<A-g>n" },
    hooks = {
      Translator = function(plugin, params)
        plugin.cmd.ChatNew(params, translation_prompt)
      end,
    },
  },
  keys = {
    -- chat
    { "<leader>aa", "<cmd>GpChatToggle vsplit<cr>", desc = "AI Chat: Toggle" },
    { "<leader>an", "<cmd>GpChatNew vsplit<cr>", desc = "AI Chat: New" },
    { "<leader>af", "<cmd>GpChatFinder<cr>", desc = "AI Chat: Find" },
    -- text
    { "<leader>ar", mode = { "n", "v" }, "<cmd>GpRewrite<cr>", desc = "AI Text: Rewrite" },
    { "<leader>ap", mode = { "n", "v" }, "<cmd>GpAppend<cr>", desc = "AI Text: Append" },
    -- context
    { "<leader>at", "<cmd>GpTranslator vsplit<cr>", desc = "AI Context: Translator" },
  },
}
