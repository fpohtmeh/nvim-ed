local M = {}
local H = {}

local icons = require("core.icons").diagnostics
local severity = vim.diagnostic.severity

H.diagnostic_opts = {
  float = { border = "single" },
  virtual_lines = { current_line = true },
  signs = {
    text = {
      [severity.ERROR] = icons.error,
      [severity.WARN] = icons.warn,
      [severity.HINT] = icons.hint,
      [severity.INFO] = icons.info,
    },
    texthl = {
      [severity.ERROR] = "DiagnosticSignError",
      [severity.WARN] = "DiagnosticSignWarn",
      [severity.HINT] = "DiagnosticSignHint",
      [severity.INFO] = "DiagnosticSignInfo",
    },
    numhl = {},
    linehl = {},
  },
}

M.configure = function()
  vim.diagnostic.config(H.diagnostic_opts)
end

return M
