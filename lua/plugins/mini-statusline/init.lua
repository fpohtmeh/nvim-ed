local H = {}

H.active = function()
  local this = require("mini.statusline")
  local sections = require("plugins.mini-statusline.sections")

  local mode = sections.mode()
  local git = sections.git()
  local diff = sections.diff()
  local diagnostics = sections.diagnostics()
  local buffers = sections.buffers()
  local directory = sections.directory()
  local filename = sections.filename()
  local fileinfo = sections.fileinfo()
  local location = sections.location()
  local search = sections.searchcount()

  return this.combine_groups({
    mode,
    buffers,
    git,
    "%<", -- Mark general truncate point
    directory,
    filename,
    "%=", -- End left alignment
    { strings = { diff, diagnostics } },
    fileinfo,
    { hl = mode.hl, strings = { search, location } },
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
