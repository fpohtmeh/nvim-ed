local H = {}

H.create_highlights = function()
  local palette = require("e-ink.palette")
  local mono = palette.mono()
  local colors = palette.everforest()
  local default_fg = mono[16]

  local hl = {}
  -- Selection
  hl.YankHighlight = { fg = default_fg, bg = mono[10] }
  -- Tabline
  hl.TabLineInactive = { fg = mono[10], bg = mono[1], bold = false }
  hl.TabLineActive = { fg = mono[1], bg = mono[10], bold = true }
  -- Flash
  hl.FlashLabel = { fg = default_fg, bg = colors.green }

  for group, spec in pairs(hl) do
    vim.api.nvim_set_hl(0, group, spec)
  end
end

return {
  "alexxGmZ/e-ink.nvim",
  lazy = Ed.colorscheme ~= "e-ink",
  priority = 1000,
  config = function()
    require("e-ink").setup()
    vim.cmd.colorscheme("e-ink")
    vim.opt.background = "light"
    H.create_highlights()
  end,
}
