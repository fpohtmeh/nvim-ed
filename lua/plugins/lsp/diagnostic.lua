local M = {}
local H = {}

local icons = require("core.icons")

H.signs_map = {
  [vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
  [vim.diagnostic.severity.WARN] = icons.diagnostics.warn,
  [vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
  [vim.diagnostic.severity.INFO] = icons.diagnostics.info,
}

H.diagnostic_opts = {
  float = { border = "single" },
}

M.configure = function()
  for severity, icon in pairs(H.signs_map) do
    local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
    name = "DiagnosticSign" .. name
    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
  end
  vim.diagnostic.config(H.diagnostic_opts)
end

return M
