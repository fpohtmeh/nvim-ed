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

H.prompts = {}

H.prompts.translate = [[
You are a Translator. Please help me to translate content.
These are rules to detect source and target languages, sorted by priority:
- If first non-empty line contains only a two-letter language code (like "fr", "uk"), use that as the target language for translation.
- If first non-empty line contains two two-letter language codes separated by a space (like "en fr", "es de", etc.), use the first as source and second as target.
- If input is English, translate to Ukrainian
- Otherwise translate to English
Answer only with the translation, don't print source or target language or other explanations.
If my input sounds as a question, just translate it don't provide the answer to the question.
]]

H.prompts.help = [[
You are a Universal Helper. Please help to explain things, generate contents, etc.
]]

H.prompt_library = {
  ["Language Translator"] = {
    strategy = "chat",
    description = "Translate the text from one language to another",
    opts = {
      short_name = "translator",
      ignore_system_prompt = true,
    },
    prompts = {
      { role = "system", content = H.prompts.translate },
      { role = "user", content = "" },
    },
  },
  ["Universal Helper"] = {
    strategy = "chat",
    description = "Help with any question",
    opts = {
      short_name = "helper",
      ignore_system_prompt = true,
    },
    prompts = {
      { role = "system", content = H.prompts.help },
      { role = "user", content = "" },
    },
  },
}

H.opts = {
  strategies = H.strategies,
  adapters = H.adapters,
  display = H.display,
  prompt_library = H.prompt_library,
}

H.modes = { "n", "i", "v" }

H.inline_action = function()
  local input = vim.fn.input("CodeCompanion: ")
  if input ~= "" then
    vim.cmd("CodeCompanion " .. input)
  end
end

H.open_translator = function()
  require("codecompanion").prompt("translator")
end

H.open_helper = function()
  require("codecompanion").prompt("helper")
end

H.keys = {
  { "<C-g>c", "<cmd>CodeCompanionChat Toggle<cr>", desc = "CodeCompanion: Toggle Chat", mode = H.modes },
  { "<C-g>a", "<cmd>CodeCompanionActions<cr>", desc = "CodeCompanion: Actions", mode = H.modes },
  { "<C-g>r", H.inline_action, desc = "CodeCompanion: Inline", mode = H.modes },
  { "<C-g>t", H.open_translator, desc = "CodeCompanion: Translate", mode = H.modes },
  { "<C-g>h", H.open_helper, desc = "CodeCompanion: Helper", mode = H.modes },
}

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
