local H = {}

H.modes = { "n", "i", "v" }

H.inline_action = function()
  local input = vim.fn.input("CodeCompanion: ")
  if input ~= "" then
    vim.cmd("CodeCompanion " .. input)
  end
end

H.make_prompt = function(prompt_name)
  return function()
    require("codecompanion").prompt(prompt_name)
  end
end

return {
  { "<C-g>c", "<cmd>CodeCompanionChat Toggle<cr>", desc = "CodeCompanion: Toggle Chat", mode = H.modes },
  { "<C-g>a", "<cmd>CodeCompanionActions<cr>", desc = "CodeCompanion: Actions", mode = H.modes },
  { "<C-g>r", H.inline_action, desc = "CodeCompanion: Inline", mode = H.modes },
  { "<C-g>t", H.make_prompt("translate"), desc = "CodeCompanion: Translate", mode = H.modes },
  { "<C-g>h", H.make_prompt("help"), desc = "CodeCompanion: Help", mode = H.modes },
}
