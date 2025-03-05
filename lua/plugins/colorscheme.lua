return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "moon",
    on_highlights = function(hl, c)
      hl.LineNr = { fg = c.dark5 }
      hl.LineNrAbove = { fg = c.dark5 }
      hl.LineNrBelow = { fg = c.dark5 }
      hl.CursorLineNr = { fg = c.green, bg = hl.CursorLine.bg }
      hl.Comment = { fg = c.comment, italic = false }
      hl.PmenuThumb = { bg = c.fg }
      hl.WinSeparator = { fg = c.blue }

      -- Snacks
      hl.SnacksDashboardHeader = hl.ErrorMsg
      hl.SnacksDashboardTitle = hl.Comment
    end,
  },
  init = function()
    require("tokyonight").load()
  end,
}
