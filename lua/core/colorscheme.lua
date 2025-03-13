local M = {}

local H = {}
H.all = { "tokyonight", "e-ink" }
H.env_var = vim.env.NVIM_COLORSCHEME
H.default = "tokyonight"
-- H.default = "e-ink"

M.default = H.env_var and vim.tbl_contains(H.all, H.env_var) or H.default

return M
