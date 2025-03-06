local M = {}

local actions = require("plugins.grug-far.actions")

M.buffer = {
  help = { n = "g?" },
  replace = { n = "<c-s>" },
  qflist = { n = "<c-q>" },
  refresh = { n = "<A-r>" },
  gotoLocation = { n = "<enter>" },
  historyOpen = { n = "<A-h>" },
  close = false,
  abort = false,
  openLocation = false,
  syncLine = false,
  syncLocations = false,
  historyAdd = false,
  openNextLocation = false,
  openPrevLocation = false,
  pickHistoryEntry = false,
  toggleShowCommand = false,
  previewLocation = false,
  swapEngine = false,
  swapReplacementInterpreter = false,
  applyNext = false,
  applyPrev = false,
}

M.global = {
  { "<leader>rr", actions.search_and_replace, desc = "Search and Replace" },
  { "<leader>rr", mode = "v", actions.search_and_replace_selection, desc = "Search and Replace selection" },
  { "<leader>rw", actions.search_and_replace_word, desc = "Search and Replace word" },
  { "<leader>rf", actions.search_and_replace_in_file, desc = "Search and Replace in file" },
  {
    "<leader>rf",
    mode = "v",
    actions.search_and_replace_selection_in_file,
    desc = "Search and Replace selection in file",
  },
  { "<leader>rd", actions.search_and_replace_in_directory, desc = "Search and Replace in directory" },
  {
    "<leader>rd",
    mode = "v",
    actions.search_and_replace_selection_in_directory,
    desc = "Search and Replace selection in directory",
  },
}

M.attach_to_buffer = function(bufnr)
  -- stylua: ignore start
  vim.keymap.set("n", "<A-f>f", actions.toggle.fixed_strings, { buffer = bufnr, desc = "Toggle fixed strings" })
  vim.keymap.set("n", "<A-f>i", actions.toggle.ignore, { buffer = bufnr, desc = "Toggle ignore files" })
  vim.keymap.set("n", "<A-f>h", actions.toggle.hidden, { buffer = bufnr, desc = "Toggle hidden" })
  vim.keymap.set("n", "<A-f>s", actions.toggle.smart_case, { buffer = bufnr, desc = "Toggle smart case" })
  -- stylua: ignore end
end

return M
