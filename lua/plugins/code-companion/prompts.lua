local M = {}
local H = {}

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

H.prompts.fix_phrase = [[
You are Writer. Please help me to fix the phrase in the provided language.
Ensure that phrase sound natural for the language and for the native speakers.
Please be brief, the output should not be much longer than input.
Try to detect the area and use the corresponding phrasing.
]]

H.prompts.fix_phrase_content = function(context)
  local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

  return string.format(
    [[Please fix this text from buffer %d:

```%s
%s
```
]],
    context.bufnr,
    context.filetype,
    code
  )
end

H.prompts.help = [[
You are a Universal Helper. Please help to explain things, generate contents, etc.
]]

M.library = {}

M.library["Language Translator"] = {
  strategy = "chat",
  description = "Translate the text from one language to another",
  opts = {
    short_name = "translate",
    ignore_system_prompt = true,
  },
  prompts = {
    { role = "system", content = H.prompts.translate },
    { role = "user", content = "" },
  },
}

M.library["Fix Phrase"] = {
  strategy = "inline",
  description = "Fix the phrase",
  opts = {
    short_name = "fix_phrase",
    placement = "replace",
    ignore_system_prompt = true,
    modes = { "v" },
  },
  prompts = {
    { role = "system", content = H.prompts.fix_phrase },
    {
      role = "user",
      content = H.prompts.fix_phrase_content,
    },
  },
}

M.library["Help"] = {
  strategy = "chat",
  description = "Help with any question",
  opts = {
    short_name = "help",
    ignore_system_prompt = true,
  },
  prompts = {
    { role = "system", content = H.prompts.help },
    { role = "user", content = "" },
  },
}

return M
