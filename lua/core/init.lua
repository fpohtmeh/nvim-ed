local M = {}

_G.dd = function(...)
  Snacks.debug.inspect(...)
end

M.border = "single"

M.keys = {
  next = ";",
  prev = ",",
  window = { "j", "k", "l", "h", ";" },
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
