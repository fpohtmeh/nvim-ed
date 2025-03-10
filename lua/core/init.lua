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
    "log",
    "noice",
    "snacks_dashboard",
    "Outline",
  },
}

return M
