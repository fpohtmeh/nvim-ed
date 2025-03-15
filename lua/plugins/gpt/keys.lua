local H = {}

H.modes = {
  n = { "n" },
  v = { "v" },
  nv = { "n", "v" },
  nivx = { "n", "i", "v", "x" },
}

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

  -- chat
  append("<c-g>t", "GpChatToggle vsplit", "AI Chat: Toggle", H.modes.nv)
  append("<c-g>n", "GpChatNew vsplit", "AI Chat: New", H.modes.nv)
  append("<c-g>f", "GpChatFinder", "AI Chat: Find", H.modes.nv)
  append("<c-g>p", "GpChatPaste", "AI Chat: Paste", H.modes.v)
  -- text
  append("<c-g>r", "GpRewrite", "AI Text: Rewrite", H.modes.nv)
  append("<c-g>j", "GpAppend", "AI Text: Append", H.modes.nv)
  append("<c-g>k", "GpPrepend", "AI Text: Prepend", H.modes.nv)
  -- context
  append("<C-g>T", "GpTranslate vsplit", "AI Context: Translate", H.modes.nv)
  append("<C-g>E", "GpExplain vsplit", "AI Context: Explain", H.modes.nv)

  return mappings
end

return H.create_mappings
