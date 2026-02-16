return {
  "chrisgrieser/nvim-various-textobjs",
  event = "LazyFile",
  opts = {
    forwardLooking = { big = 30 },
    keymaps = { useDefaults = false },
  },
  keys = {
    -- stylua: ignore start
    { mode = { "o", "x" }, ";i", function() require("various-textobjs").restOfIndentation() end, desc = "Rest of indentation"  },
    { mode = { "o", "x" }, ";p", function() require("various-textobjs").restOfParagraph() end, desc = "Rest of paragraph"  },
    { mode = { "o", "x" }, ";b", function() require("various-textobjs").toNextClosingBracket() end, desc = "Next closing bracket"  },
    { mode = { "o", "x" }, ";q", function() require("various-textobjs").toNextQuotationMark() end, desc = "Next quotation mark" },
    -- stylua: ignore end
  },
}
