local M = {}

function M.setup()
  Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
  Snacks.toggle.diagnostics():map("<leader>ud")
  Snacks.toggle.line_number():map("<leader>ul")
  Snacks.toggle.option("relativenumber", { name = "Relative Numbers" }):map("<leader>uL")

  local format = require("core.format")
  format.toggle(false):map("<leader>uF")
  format.toggle(true):map("<leader>uf")

  Snacks.toggle
    .option("scrolloff", { off = 0, on = vim.o.scrolloff > 0 and vim.o.scrolloff or 2, name = "Scrolloff" })
    :map("<leader>us")

  Snacks.toggle({
    name = "Cursor Word",
    get = function()
      return vim.g.minicursorword_disable == true
    end,
    set = function(state)
      vim.g.minicursorword_disable = state or nil
    end,
  }):map("<leader>uh")
end

return M
