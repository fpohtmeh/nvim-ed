local icons = require("core.icons")
local keymaps = require("plugins.grug-far.keymaps")

return {
  "MagicDuck/grug-far.nvim",
  opts = {
    debounceMs = 200,
    maxSearchMatches = 2000,
    windowCreationCommand = "split",
    resultsSeparatorLineChar = icons.separator,
    staticTitle = "search",
    helpLine = { enabled = false },
    showCompactInputs = true,
    showInputsTopPadding = false,
    resultLocation = {
      numberLabelPosition = "inline",
      numberLabelFormat = "#%d ",
    },
    icons = {
      resultsEngineLeft = "[",
      resultsEngineRight = "]" .. icons.separator,
    },
    spinnerStates = icons.spinners,
    keymaps = keymaps.buffer,
  },
  keys = keymaps.global,
}
