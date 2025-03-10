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
    "snacks_terminal",
    "OverseerForm",
    "OverseerList",
    "OverseerOutput",
    "Outline",
  },
}

return M
