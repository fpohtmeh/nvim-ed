return {
  "alexxGmZ/e-ink.nvim",
  lazy = Ed.colorscheme ~= "e-ink",
  priority = 1000,
  config = function()
    require("e-ink").setup()
    vim.cmd.colorscheme("e-ink")
    vim.opt.background = "light"
  end,
}
