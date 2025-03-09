local M = {}

M.pick = {}
M.pick.definition = function()
  Snacks.picker.lsp_definitions()
end
M.pick.declaration = function()
  Snacks.picker.lsp_declarations()
end
M.pick.reference = function()
  Snacks.picker.lsp_references()
end
M.pick.implementation = function()
  Snacks.picker.lsp_implementations()
end
M.pick.type_definition = function()
  Snacks.picker.lsp_type_definitions()
end

M.rename = function()
  return ":" .. require("inc_rename").config.cmd_name .. " " .. vim.fn.expand("<cword>")
end

M.diagnostic = {}
M.diagnostic.goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity, float = false })
  end
end

return M
