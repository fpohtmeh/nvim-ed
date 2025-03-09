local M = {}

M.package = {
  pending = "",
  installed = "󰄳",
  uninstalled = "󰚌",
}

M.mark = ""
M.separator = ""

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

return M
