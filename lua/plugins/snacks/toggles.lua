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

  require("plugins.mini-cursorword.core").toggle():map("<leader>uh")
  require("plugins.render-markdown.core").toggle():map("<leader>um")
  require("plugins.git.toggles").current_line_blame():map("<leader>ug")
end

return M
