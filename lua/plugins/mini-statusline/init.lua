local H = {}

H.active = function()
  local this = require("mini.statusline")
  local sections = require("plugins.mini-statusline.sections")

  local mode, mode_hl = this.section_mode({ trunc_width = 120 })
  local git = this.section_git({ trunc_width = 40 })
  local diff = sections.section_diff("MiniStatuslineFilename")
  local diagnostics = sections.section_diagnostics("MiniStatuslineFilename")
  local filename = this.section_filename({ trunc_width = 140 })
  local fileinfo = this.section_fileinfo({ trunc_width = 120 })
  local location = this.section_location({ trunc_width = 75 })
  local search = this.section_searchcount({ trunc_width = 75 })

  return this.combine_groups({
    { hl = mode_hl, strings = { mode } },
    { hl = "MiniStatuslineDevinfo", strings = { git } },
    "%<",
    { hl = "MiniStatuslineFilename", strings = { filename, diff } },
    "%=",
    { strings = { diagnostics } },
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
