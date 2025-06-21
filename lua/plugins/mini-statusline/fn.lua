local M = {}

M.setup_highlights = function(hl, colors)
  hl.MiniStatuslineDiagnosticError = { fg = hl.DiagnosticError.fg, bg = colors.bg }
  hl.MiniStatuslineDiagnosticWarn = { fg = hl.DiagnosticWarn.fg, bg = colors.bg }
  hl.MiniStatuslineDiagnosticInfo = { fg = hl.DiagnosticInfo.fg, bg = colors.bg }
  hl.MiniStatuslineDiagnosticHint = { fg = hl.DiagnosticHint.fg, bg = colors.bg }
  hl.MiniStatuslineDevinfo = { fg = colors.blue, bg = colors.bg_highlight }
  hl.MiniStatuslineDirectory = { fg = colors.magenta, bg = colors.bg }
  hl.MiniStatuslineFilename = { fg = colors.blue, bg = colors.bg }
  hl.MiniStatuslineFileinfo = { fg = colors.blue, bg = colors.bg_highlight }
  hl.MiniStatuslineBigFileinfo = { fg = colors.red, bg = colors.bg_highlight, bold = true }
  hl.MiniStatuslineBuffers = { fg = colors.blue, bg = colors.bg_highlight }
  hl.MiniStatuslineUnsaved = { fg = colors.red, bg = colors.bg_highlight, bold = true }
  hl.MiniStatuslineModified = { fg = colors.green, bg = colors.bg_highlight, bold = true }
  hl.MiniStatuslineGitAdded = { fg = colors.git.add, bg = colors.bg }
  hl.MiniStatuslineGitModified = { fg = colors.git.change, bg = colors.bg }
  hl.MiniStatuslineGitRemoved = { fg = colors.git.delete, bg = colors.bg }
end

return M
