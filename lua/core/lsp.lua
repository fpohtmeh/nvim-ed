local M = {}
local H = {}

H.pick = {}
H.pick.definition = function()
  Snacks.picker.lsp_definitions()
end
H.pick.declaration = function()
  Snacks.picker.lsp_declarations()
end
H.pick.reference = function()
  Snacks.picker.lsp_references()
end
H.pick.implementation = function()
  Snacks.picker.lsp_implementations()
end
H.pick.type_definition = function()
  Snacks.picker.lsp_type_definitions()
end

H.rename = function()
  return ":" .. require("inc_rename").config.cmd_name .. " " .. vim.fn.expand("<cword>")
end

H.code_action = function()
  vim.lsp.buf.code_action()
end

H.diagnostic = {}
H.diagnostic.jump = function(count, severity)
  return function()
    vim.diagnostic.jump({
      count = count,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = false,
    })
  end
end

H.map_lsp = function(buf)
  local map = vim.keymap.set
  map("n", "gR", H.rename, { buffer = buf, expr = true, desc = "Rename" })
  map("n", "gd", H.pick.definition, { buffer = buf, desc = "Goto Definition" })
  map("n", "gD", H.pick.declaration, { buffer = buf, desc = "Goto Declaration" })
  map("n", "gr", H.pick.reference, { buffer = buf, nowait = true, desc = "References" })
  map("n", "gI", H.pick.implementation, { buffer = buf, desc = "Goto Implementation" })
  map("n", "gY", H.pick.type_definition, { buffer = buf, desc = "Goto Type Definition" })
  map({ "n", "v" }, "gA", H.code_action, { buffer = buf, expr = true, desc = "Code Action" })
end

H.map_prev_next = function(buf)
  local map = vim.keymap.set
  local keys = require("core").keys
  map("n", keys.prev .. "d", H.diagnostic.jump(-1), { buffer = buf, desc = "Prev Diagnostic" })
  map("n", keys.next .. "d", H.diagnostic.jump(1), { buffer = buf, desc = "Next Diagnostic" })
  map("n", keys.prev .. "e", H.diagnostic.jump(-1, "ERROR"), { buffer = buf, desc = "Prev Error" })
  map("n", keys.next .. "e", H.diagnostic.jump(1, "ERROR"), { buffer = buf, desc = "Next Error" })
  map("n", keys.prev .. "w", H.diagnostic.jump(-1, "WARN"), { buffer = buf, desc = "Prev Warning" })
  map("n", keys.next .. "w", H.diagnostic.jump(1, "WARN"), { buffer = buf, desc = "Next Warning" })
end

M.create_autocmds = function()
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      H.map_lsp(args.buf)
      H.map_prev_next(args.buf)
    end,
  })
end

return M
