local M = {}

M.package = {
  pending = "",
  installed = "󰄳",
  uninstalled = "󰚌",
}

M.search = ""
M.modified = "●"
M.mark = ""
M.separator = "─"
M.file = ""
M.directory = ""
M.buffers = "󰪏"
M.readonly = "󰍁"

M.diagnostics = {
  error = " ",
  warn = " ",
  hint = " ",
  info = " ",
}

M.git = {
  added = " ",
  modified = " ",
  removed = " ",
}

M.spinners = {
  "⠋",
  "⠙",
  "⠹",
  "⠸",
  "⠼",
  "⠴",
  "⠦",
  "⠧",
  "⠇",
  "⠏",
}

return M
