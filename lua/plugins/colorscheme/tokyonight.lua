return {
  "folke/tokyonight.nvim",
  lazy = Ed.colorscheme ~= "tokyonight",
  priority = 1000,
  opts = {
    style = "moon",
    on_highlights = function(hl, c)
      local default_fg = "#1B1D2B"
      -- General
      hl.LineNr = { fg = c.dark5 }
      hl.LineNrAbove = { fg = c.dark5 }
      hl.LineNrBelow = { fg = c.dark5 }
      hl.CursorLineNr = { fg = c.green, bg = hl.CursorLine.bg }
      hl.Comment = { fg = c.comment, italic = false }
      hl.PmenuThumb = { bg = c.fg }
      hl.WinSeparator = { fg = c.blue }
      -- Selection
      hl.YankHighlight = { fg = default_fg, bg = c.yellow }
      -- Snacks
      hl.SnacksDashboardHeader = { fg = c.blue }
      hl.SnacksDashboardDesc = { fg = c.green }
      hl.SnacksDashboardIcon = { fg = c.blue }
      hl.SnacksDashboardKey = { fg = c.blue }
      hl.SnacksDashboardTitle = { fg = c.blue }
      hl.SnacksNotifierBorderInfo = { fg = c.blue }
      hl.SnacksNotifierIconInfo = { fg = c.blue }
      hl.SnacksPickerBoxTitle = { fg = c.green, bg = c.bg_dark }
      hl.SnacksPickerInputTitle = { fg = c.green, bg = c.bg_dark }
      hl.SnacksPickerInputBorder = { fg = c.green, bg = c.bg_dark }
      hl.SnacksPickerSelected = { fg = c.green, bg = c.bg_dark }
      hl.SnacksZenIcon = { fg = default_fg, bg = c.green }
      -- Diagnostic
      hl.DiagnosticUnnecessary = { fg = c.comment }
      -- Indentation
      hl.MiniIndentscopeSymbol = { fg = c.green }
      -- Flash
      hl.FlashCurrent = { fg = c.fg, bg = c.blue0 }
      hl.FlashMatch = { fg = default_fg, bg = c.blue }
      hl.FlashLabel = { fg = default_fg, bg = c.yellow }
      -- Cursor word
      hl.MiniCursorword = { bg = c.bg_visual }
      hl.MiniCursorwordCurrent = { bg = hl.CursorLine.bg }
      -- Trailspace
      hl.MiniTrailspace = { bg = c.red1, fg = c.red1 }
      -- Incline
      hl.InclineNormal = { bg = c.bg }
      hl.InclineNormalNC = { bg = c.bg }
      -- Git
      hl.GitSignsCurrentLineBlame = { fg = c.comment }
      -- Plugins
      require("plugins.render-markdown.fn").setup_highlights(hl, c)
      require("plugins.mini-statusline.fn").setup_highlights(hl, c)
      require("plugins.grug-far.fn").setup_highlights(hl, c)
    end,
  },
  init = function()
    require("tokyonight").load()
  end,
}
