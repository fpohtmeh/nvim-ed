local M = {}
local H = {}

H.excluded_filetypes = {
  "lazy",
  "noice",
  "snacks_dashboard",
  "snacks_terminal",
  "OverseerForm",
  "OverseerList",
  "OverseerOutput",
  "grug-far",
}

H.callback = function()
  local fn = require("core.fn")
  local filetype = vim.bo.filetype
  vim.b.minicursorword_disable = fn.is_visual_mode() or vim.tbl_contains(H.excluded_filetypes, filetype)
end

M.create_autocmds = function()
  vim.api.nvim_create_autocmd({ "CursorMoved", "ModeChanged" }, {
    pattern = "*",
    callback = H.callback,
  })
end

M.toggle = function()
  return Snacks.toggle({
    name = "Cursor Word",
    get = function()
      return vim.g.minicursorword_disable == true
    end,
    set = function(state)
      vim.g.minicursorword_disable = state or nil
    end,
  })
end

return M
