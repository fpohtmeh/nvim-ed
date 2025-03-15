local H = {}

H.prompts = {}

H.prompts.translate = [[
You are a Translator. Please help me translate content.
These are rules to detect source and target languages, sorted by priority:
- If first non-empty line contains only a two-letter language code (like "fr", "uk"), use that as the target language for translation.
- If first non-empty line contains two two-letter language codes separated by a space (like "en fr", "es de", etc.), use the first as source and second as target.
- If input is English, translate to Ukrainian
- Otherwise translate to English
Answer only with the translation, don't print source or target language or other explanations
]]

H.prompts.explain = [[
You are an AI assistant helping developers.
Provide concise, technical explanations.
Aim for 20 words or less if it's clear enough.
]]

return {
  Translate = function(plugin, params)
    plugin.cmd.ChatNew(params, H.prompts.translate)
  end,
  Explain = function(plugin, params)
    plugin.cmd.ChatNew(params, H.prompts.explain)
  end,
}
