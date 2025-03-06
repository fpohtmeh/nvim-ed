local icons = require("core.icons")
local keymaps = require("plugins.grug-far.keymaps")

return {
  "MagicDuck/grug-far.nvim",
  opts = {
    debounceMs = 200,
    maxSearchMatches = 9999,
    windowCreationCommand = "split",
    resultsSeparatorLineChar = icons.separator,
    staticTitle = "search",
    helpLine = { enabled = false },
    resultLocation = {
      numberLabelPosition = "inline",
      numberLabelFormat = "#%d ",
    },
    icons = {
      resultsEngineLeft = "[",
      resultsEngineRight = "]" .. icons.separator,
    },
    keymaps = keymaps.buffer,
  },
  keys = keymaps.global,
}
