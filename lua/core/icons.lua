local M = {}

M.package = {
  pending = "",
  installed = "󰄳",
  uninstalled = "󰚌",
}

M.branch = ""
M.search = ""
M.modified = "●"
M.mark = ""
M.separator = "─"
M.file = ""
M.directory = ""
M.buffers = "󰪏"
M.readonly = "󰍁"
M.terminal = "λ"
M.prompt = "❯"
M.claude = "󱚟"

M.diagnostics = {
  error = " ",
  warn = " ",
  hint = " ",
  info = " ",
}

M.git = {
  icon = "󰊢",
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
