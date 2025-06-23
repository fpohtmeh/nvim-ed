local H = {}

H.create = function(keys, cmd, desc, mode)
  if mode == "v" then
    return { keys, ":<C-u>'<,'>" .. cmd .. "<cr>", desc = desc, mode = mode }
  end
  return { keys, "<cmd>" .. cmd .. "<cr>", desc = desc, mode = mode }
end

H.create_mappings = function()
  local mappings = {}

  local append = function(keys, cmd, desc, modes)
    for _, m in ipairs({ "n", "v" }) do
      if vim.list_contains(modes, m) then
        table.insert(mappings, H.create(keys, cmd, desc, m))
      end
    end
  end

  local modes = { "n", "v" }
  -- Chat
  append("<C-g>g", "GpChatToggle vsplit", "GP Chat: Toggle", modes)
  append("<C-g>f", "GpChatFinder", "GP Chat: Find", modes)
  -- Text
  append("<C-g>r", "GpRewrite", "GP Buffer: Rewrite", modes)
  append("<C-g>j", "GpAppend", "GP Buffer: Append", modes)
  append("<C-g>k", "GpPrepend", "GP Buffer: Prepend", modes)
  -- Context
  append("<C-g>T", "GpTranslate vsplit", "GP Context: Translate", modes)
  append("<C-g>E", "GpExplain vsplit", "GP Context: Explain", modes)
  append("<C-g>F", "GpRewrite FixPhrase", "GP Context: Fix Phrase", modes)

  return mappings
end

return H.create_mappings
