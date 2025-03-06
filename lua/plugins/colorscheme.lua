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
      hl.SnacksDashboardHeader = { fg = c.blue }
      hl.SnacksDashboardDesc = { fg = c.green }
      hl.SnacksDashboardIcon = { fg = c.blue }
      hl.SnacksDashboardKey = { fg = c.blue }
      hl.SnacksDashboardTitle = { fg = c.blue }
      hl.SnacksNotifierBorderInfo = { fg = c.blue }
      hl.SnacksNotifierIconInfo = { fg = c.blue }

      -- Statusline
      hl.MiniStatuslineDevinfo = { fg = c.blue, bg = c.bg_highlight }
      hl.MiniStatuslineFilename = { fg = c.green, bg = c.bg }
      hl.MiniStatuslineFileinfo = { fg = c.blue, bg = c.bg_highlight }
      hl.MiniStatuslineInactive = { fg = c.green, bg = c.bg }

      -- Indentation
      hl.MiniIndentscopeSymbol = { fg = c.green }
    end,
  },
  init = function()
    require("tokyonight").load()
  end,
}
