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
      hl.MiniStatuslineDiagnosticError = { fg = hl.DiagnosticError.fg }
      hl.MiniStatuslineDiagnosticWarn = { fg = hl.DiagnosticWarn.fg }
      hl.MiniStatuslineDiagnosticInfo = { fg = hl.DiagnosticInfo.fg }
      hl.MiniStatuslineDiagnosticHint = { fg = hl.DiagnosticHint.fg }
      -- Statusline
      hl.MiniStatuslineDevinfo = { fg = c.blue, bg = c.bg_highlight }
      hl.MiniStatuslineFilename = { fg = c.blue, bg = c.bg }
      hl.MiniStatuslineFileinfo = { fg = c.blue, bg = c.bg_highlight }
      hl.MiniStatuslineBigFileinfo = { fg = c.red, bg = c.bg_highlight, bold = true }
      hl.MiniStatuslineBuffers = { fg = c.fg }
      hl.MiniStatuslineUnsaved = { fg = c.red, bold = true }
      hl.MiniStatuslineModified = { fg = c.green, bold = true }
      hl.MiniStatuslineGitAdded = { fg = c.git.add }
      hl.MiniStatuslineGitModified = { fg = c.git.change }
      hl.MiniStatuslineGitRemoved = { fg = c.git.delete }
      -- Indentation
      hl.MiniIndentscopeSymbol = { fg = c.green }
      -- Flash
      hl.FlashCurrent = { fg = c.fg, bg = c.blue0 }
      hl.FlashMatch = { fg = default_fg, bg = c.blue }
      hl.FlashLabel = { fg = default_fg, bg = c.yellow }
      -- Cursor word
      hl.MiniCursorword = { bg = c.bg_visual }
      hl.MiniCursorwordCurrent = { bg = hl.CursorLine.bg }
      -- Incline
      hl.InclineNormal = { bg = c.bg }
      hl.InclineNormalNC = { bg = c.bg }
      -- Markdown
      require("plugins.render-markdown.core").setup_highlights(hl, c)
    end,
  },
  init = function()
    require("tokyonight").load()
  end,
}
