local M = {}

local fn = require("plugins.grug-far.fn")

M.buffer = {
  help = { n = "g?" },
  replace = { n = "<C-s>" },
  qflist = { n = "<c-q>" },
  refresh = { n = "<C-e>r" },
  gotoLocation = { n = "<enter>" },
  historyOpen = { n = "<C-e>h" },
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
  { "<leader>rr", fn.open, mode = { "n", "v" }, desc = "Search and Replace" },
  { "<leader>rw", fn.open_with_word, desc = "Search and Replace (Word)" },
  { "<leader>rf", fn.open_with_file, mode = { "n", "v" }, desc = "Search and Replace (In File)" },
  { "<leader>rd", fn.open_with_directory, mode = { "n", "v" }, desc = "Search and Replace (In Directory)" },
}

M.attach_to_buffer = function(bufnr)
  -- stylua: ignore start
  vim.keymap.set("n", "<C-e>f", fn.toggle.fixed_strings, { buffer = bufnr, desc = "Toggle fixed strings" })
  vim.keymap.set("n", "<C-e>i", fn.toggle.ignore, { buffer = bufnr, desc = "Toggle ignore files" })
  vim.keymap.set("n", "<C-e>h", fn.toggle.hidden, { buffer = bufnr, desc = "Toggle hidden" })
  vim.keymap.set("n", "<C-e>s", fn.toggle.smart_case, { buffer = bufnr, desc = "Toggle smart case" })
  -- stylua: ignore end
end

return M
