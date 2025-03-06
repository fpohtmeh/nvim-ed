local M = {}

M.border = "single"

M.keys = {
  next = ";",
  prev = ",",
}

M.indentation = {
  excluded_filetypes = {
    "help",
    "lazy",
    "snacks_dashboard",
    "log",
    "Outline",
  },
}

return M
