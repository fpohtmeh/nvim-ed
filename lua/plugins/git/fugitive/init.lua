vim.g.fugitive_no_maps = 1

return {
  "tpope/vim-fugitive",
  cmd = { "G", "Git" },
  opt = {},
  keys = require("plugins.git.fugitive.keys"),
}
