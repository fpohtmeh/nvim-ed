vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.snacks_animate = false
vim.g.snacks_dim = false
vim.g.snacks_scroll = false

local opt = vim.opt

opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
opt.cmdheight = 0
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = " ",
  eob = " ",
}
opt.foldenable = false
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.laststatus = 3
opt.list = true
opt.number = true
opt.relativenumber = true
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.smartindent = true
opt.softtabstop = 4
opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
opt.tabstop = 4
opt.termguicolors = true
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.virtualedit = "block"
opt.winminwidth = 5
opt.wrap = false

if vim.fn.has("win32") == 1 then
  require("core.terminal").setup("pwsh")
end
