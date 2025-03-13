return {
  "alexxGmZ/e-ink.nvim",
  lazy = require("core.colorscheme").default ~= "e-ink",
  priority = 1000,
  config = function()
    require("e-ink").setup()
    vim.cmd.colorscheme("e-ink")
    vim.opt.background = "light"
  end,
}
