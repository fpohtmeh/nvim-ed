local H = {}
local icons = require("core.icons")

H.diagnostics_signs = {
  ERROR = "%#MiniStatuslineDiagnosticError#" .. icons.diagnostics.error .. "%#MiniStatuslineDevinfo#",
  WARN = "%#MiniStatuslineDiagnosticWarn#" .. icons.diagnostics.warn .. "%#MiniStatuslineDevinfo#",
  INFO = "%#MiniStatuslineDiagnosticInfo#" .. icons.diagnostics.info .. "%#MiniStatuslineDevinfo#",
  HINT = "%#MiniStatuslineDiagnosticHint#" .. icons.diagnostics.hint .. "%#MiniStatuslineDevinfo#",
}

H.section_diagnostics = function(args)
  local section = require("mini.statusline").section_diagnostics(args)
  return section:sub(2)
end

H.active = function()
  local this = require("mini.statusline")
  local mode, mode_hl = this.section_mode({ trunc_width = 120 })
  local git = this.section_git({ trunc_width = 40 })
  local diff = this.section_diff({ trunc_width = 75 })
  local diagnostics = H.section_diagnostics({ trunc_width = 75, signs = H.diagnostics_signs, icon = "" })
  local filename = this.section_filename({ trunc_width = 140 })
  local fileinfo = this.section_fileinfo({ trunc_width = 120 })
  local location = this.section_location({ trunc_width = 75 })
  local search = this.section_searchcount({ trunc_width = 75 })

  return this.combine_groups({
    { hl = mode_hl, strings = { mode } },
    { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
    "%<",
    { hl = "MiniStatuslineFilename", strings = { filename } },
    "%=",
    { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
    { hl = mode_hl, strings = { search, location } },
  })
end

return {
  "echasnovski/mini.statusline",
  lazy = false,
  version = false,
  opts = {
    content = { active = H.active },
  },
}
