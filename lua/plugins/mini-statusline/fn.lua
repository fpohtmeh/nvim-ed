local M = {}

M.setup_highlights = function(hl, colors)
  hl.MiniStatuslineDiagnosticError = { fg = hl.DiagnosticError.fg }
  hl.MiniStatuslineDiagnosticWarn = { fg = hl.DiagnosticWarn.fg }
  hl.MiniStatuslineDiagnosticInfo = { fg = hl.DiagnosticInfo.fg }
  hl.MiniStatuslineDiagnosticHint = { fg = hl.DiagnosticHint.fg }
  hl.MiniStatuslineDevinfo = { fg = colors.blue, bg = colors.bg_highlight }
  hl.MiniStatuslineFilename = { fg = colors.blue, bg = colors.bg }
  hl.MiniStatuslineFileinfo = { fg = colors.blue, bg = colors.bg_highlight }
  hl.MiniStatuslineBigFileinfo = { fg = colors.red, bg = colors.bg_highlight, bold = true }
  hl.MiniStatuslineBuffers = { fg = colors.blue, bg = colors.bg_highlight }
  hl.MiniStatuslineUnsaved = { fg = colors.red, bg = colors.bg_highlight, bold = true }
  hl.MiniStatuslineModified = { fg = colors.green, bg = colors.bg_highlight, bold = true }
  hl.MiniStatuslineGitAdded = { fg = colors.git.add }
  hl.MiniStatuslineGitModified = { fg = colors.git.change }
  hl.MiniStatuslineGitRemoved = { fg = colors.git.delete }
end

return M
