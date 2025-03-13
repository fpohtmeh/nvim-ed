local M = {}

M.defer_refresh = function()
  vim.defer_fn(function()
    require("incline").refresh()
  end, 100)
end

M.toggle_zoom = function()
  require("incline").toggle()
end

return M
